import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_app/GetClasses/PrayerTimingController.dart';

class PrayerTimesPage extends StatelessWidget {
  final PrayerTimingController helper = Get.put(PrayerTimingController());

  final Map<String, IconData> prayerIcons = {
    'Fajr': FeatherIcons.moon,
    'Dhuhr': FeatherIcons.sun,
    'Asr': FeatherIcons.cloud,
    'Maghrib': FeatherIcons.sunset,
    'Isha': FeatherIcons.star,
  };

  final Map<String, Color> prayerColors = {
    'Fajr': Color(0xFF1E3A8A),
    'Dhuhr': Color(0xFFFBBF24),
    'Asr': Color.fromARGB(255, 249, 166, 22),
    'Maghrib': Color.fromARGB(255, 246, 72, 19),
    'Isha': Color(0xFF6B21A8),
  };

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final today = DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('Namaz Times - ${helper.cityName.value}',
            style: TextStyle(fontWeight: FontWeight.bold))),
      ),
      body: Obx(() {
        final timings = helper.prayerTimings.value;

        if (helper.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (timings == null) {
          return Center(
              child: Text('No data available', style: TextStyle(fontSize: 18)));
        }
          // Find next prayer
        String? nextPrayer = getNextPrayer(timings);

        return RefreshIndicator(
          onRefresh: () async {
            await helper.fetchPrayerTimes();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.03),
            child: Column(
              children: [
                Text(today,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                SizedBox(height: screenHeight * 0.05),
                Expanded(
                  child: ListView(
                    children: [
                      prayerTimeCard(isDark,'Fajr', timings.fajr, prayerIcons['Fajr']!,
                          screenWidth, prayerColors['Fajr']!, nextPrayer),
                      prayerTimeCard(isDark,'Dhuhr', timings.dhuhr,
                          prayerIcons['Dhuhr']!, screenWidth, prayerColors['Dhuhr']!,nextPrayer),
                      prayerTimeCard(isDark,'Asr', timings.asr, prayerIcons['Asr']!,
                          screenWidth, prayerColors['Asr']!, nextPrayer),
                      prayerTimeCard(isDark,'Maghrib', timings.maghrib,
                          prayerIcons['Maghrib']!, screenWidth, prayerColors['Maghrib']!, nextPrayer),
                      prayerTimeCard(isDark,'Isha', timings.isha, prayerIcons['Isha']!,
                          screenWidth, prayerColors['Isha']!, nextPrayer),
                    ],
                  ),
                ),
                if (helper.isLoading.isFalse)
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Prayer times are auto-synced\nSwipe down to refresh",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // 🔹 Detect next prayer
  String? getNextPrayer(timings) {
    final now = DateTime.now();
    final format = DateFormat("HH:mm a");

    Map<String, String> times = {
      "Fajr": timings.fajr,
      "Dhuhr": timings.dhuhr,
      "Asr": timings.asr,
      "Maghrib": timings.maghrib,
      "Isha": timings.isha,
    };

    for (var entry in times.entries) {
      final prayerTime = format.parse(entry.value);
      final todayPrayer = DateTime(now.year, now.month, now.day, prayerTime.hour, prayerTime.minute);
      if (now.isBefore(todayPrayer)) {
        return entry.key; // return first prayer that hasn't happened yet
      }
    }

    return "Fajr"; // fallback: next day Fajr
  }

 
  Widget prayerTimeCard( bool isDark,String name, String time, IconData icon, double screenWidth, Color iconColor, String? nextPrayer) {
      
      bool isNext = (name == nextPrayer);

    return Card(
      elevation: isNext ? 6 : 2, // 🔹 Highlight with more shadow
      color: isNext ? Colors.blueAccent.withOpacity(0.9) : isDark?Colors.grey[700] : Colors.grey[500], // 🔹 Subtle background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 16, horizontal: screenWidth * 0.06),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 30, color: iconColor),
            SizedBox(width: 20),
            Expanded(
                child: Text(name,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: isNext ? FontWeight.bold : FontWeight.w600,
                        color: isNext ? Colors.white : isDark? Colors.white70: Colors.black))),
            Text(time,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
                    color: isNext ? Colors.white : isDark? Colors.white70: Colors.black)),
          ],
        ),
      ),
    );
  }


}
