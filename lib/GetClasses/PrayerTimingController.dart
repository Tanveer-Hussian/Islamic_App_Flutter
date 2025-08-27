import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:islamic_app/Api_Model/PrayerTimings_Model.dart';
import 'package:islamic_app/Data/DataBaseClass.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class PrayerTimingController extends GetxController {
  var prayerTimings = Rxn<PrayerTimings>();
  var cityName = "Your City".obs;
  RxBool isLoading = true.obs;
  final dbHelper = DataBaseClass.getInstance;

  static const List<String> _requiredKeys = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"];

  @override
  void onInit() {
    super.onInit();
    fetchPrayerTimes();
  }

  String _hhmm(String raw) {
    final m = RegExp(r'^(\d{1,2}:\d{2})').firstMatch(raw);
    return m != null ? m.group(1)! : raw;
  }

  DateTime? _tryParse24(String s) {
    try {
      return DateFormat('HH:mm').parse(s);
    } catch (_) {
      return null;
    }
  }

  Future<void> fetchPrayerTimes() async {
    isLoading.value = true;
    try {
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.none) {
        await loadFromLocal();
        return;
      }

      // 🔥 Try to get device location
      Position? position = await _getCurrentLocation();
      if (position == null) {
        cityName.value = "Location Unavailable"; // 🔥 No silent Karachi
        await _fetchDefaultPrayerTimes();
        return;
      }

      await _updateCityName(position.latitude, position.longitude);

      final response = await http.get(Uri.parse(
          'https://api.aladhan.com/v1/timings?latitude=${position.latitude}&longitude=${position.longitude}&method=2'));
      if (response.statusCode != 200) throw Exception('API ${response.statusCode}');

      final jsonData = jsonDecode(response.body);
      final timings = Map<String, dynamic>.from(jsonData['data']['timings']);
      final outputFormat = DateFormat('hh:mm a');

      final Map<String, String> formattedTimings = {};
      final Map<String, String> sanitizedForDb = {};

      for (var key in _requiredKeys) {
        if (timings.containsKey(key)) {
          final hhmm = _hhmm(timings[key] as String);
          final dt = _tryParse24(hhmm);
          formattedTimings[key] = dt != null ? outputFormat.format(dt) : hhmm;
          sanitizedForDb[key] = hhmm;
        }
      }

      prayerTimings.value = PrayerTimings.fromJson(formattedTimings);

      final db = await dbHelper.getDB();
      await db.delete(dbHelper.PrayerTimesTable);
      for (final e in sanitizedForDb.entries) {
        await dbHelper.addNote(e.key, e.value);
      }
    } catch (e) {
      print('fetchPrayerTimes error: $e');
      await loadFromLocal();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchDefaultPrayerTimes() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(
          'https://api.aladhan.com/v1/timingsByCity?city=Karachi&country=Pakistan&method=2'));

      if (response.statusCode != 200) throw Exception('API ${response.statusCode}');

      final jsonData = jsonDecode(response.body);
      final timings = Map<String, dynamic>.from(jsonData['data']['timings']);

      final outputFormat = DateFormat('hh:mm a');
      final Map<String, String> formattedTimings = {};
      final Map<String, String> sanitizedForDb = {};

      for (var key in _requiredKeys) {
        if (timings.containsKey(key)) {
          final hhmm = _hhmm(timings[key] as String);
          final dt = _tryParse24(hhmm);
          formattedTimings[key] = dt != null ? outputFormat.format(dt) : hhmm;
          sanitizedForDb[key] = hhmm;
        }
      }

      prayerTimings.value = PrayerTimings.fromJson(formattedTimings);

      final db = await dbHelper.getDB();
      await db.delete(dbHelper.PrayerTimesTable);
      for (final e in sanitizedForDb.entries) {
        await dbHelper.addNote(e.key, e.value);
      }

      // 🔥 Only set Karachi if cityName wasn’t resolved
      if (cityName.value == "Your City" || cityName.value == "Location Unavailable") {
        cityName.value = 'Karachi';
      }
    } catch (e) {
      print('Default fetch error: $e');
      await loadFromLocal();
    } finally {
      isLoading.value = false;
    }
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location Services are disabled');
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location Permissions are Denied');
          return null;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        print('Location permissions permanently denied');
        return null;
      }

      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      print('Location error: $e');
      return null;
    }
  }

  Future<void> _updateCityName(double latitude, double longitude) async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(latitude, longitude);
      if (placeMarks.isNotEmpty) {
        final p = placeMarks[0];
        cityName.value = p.locality?.isNotEmpty == true
            ? p.locality!
            : p.administrativeArea?.isNotEmpty == true
                ? p.administrativeArea!
                : p.country ?? 'Unknown Location';
      }
    } catch (e) {
      print('Error getting city name: $e');
      cityName.value = 'Unknown Location';
    }
  }

  Future<void> loadFromLocal() async {
    try {
      final localData = await dbHelper.getAllTimesData();
      if (localData.isEmpty) {
        print('No data in local DB');
        prayerTimings.value = null;
        return;
      }

      final Map<String, String> mapData = {
        for (var item in localData)
          item[dbHelper.ColumnTimeText] as String:
              item[dbHelper.ColumnTimeData] as String
      };

      final outputFormat = DateFormat('hh:mm a');
      final inputFormat = DateFormat('HH:mm');
      final Map<String, String> formattedTimings = {};

      for (var key in _requiredKeys) {
        if (mapData.containsKey(key)) {
          final raw = mapData[key]!;
          DateTime? dt;
          try {
            dt = inputFormat.parse(_hhmm(raw));
          } catch (_) {}
          formattedTimings[key] = dt != null ? outputFormat.format(dt) : raw;
        }
      }

      prayerTimings.value =
          formattedTimings.isEmpty ? null : PrayerTimings.fromJson(formattedTimings);
    } catch (e) {
      print('Local load error: $e');
      prayerTimings.value = null;
    }
  }
}
