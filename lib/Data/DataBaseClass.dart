import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class DataBaseClass {
  DataBaseClass._();

  static final DataBaseClass getInstance = DataBaseClass._();

  Database? db;

  // Constants for table and column names (Good Practice!)
  static const int _dbVersion = 2; // Set the new database version
  static const String _dbName = 'QuranDB.db';

  final PrayerTimesTable = 'TimeTable';
  final ColumnTimeSNO = 'sno';
  final ColumnTimeText = 'timeName';
  final ColumnTimeData = 'time';

  final QuranTable = 'QuranTable';
  final TranslatedQuranTable = 'TranslatedQuranTable';
  final ColumnSurahId = 'id';
  final ColumnSurahNumber = 'number';
  final ColumnSurahName = 'name';
  final ColumnEnglishName = 'englishName';
  final ColumnEnglishNameTranslation = 'englishNameTranslation';
  final ColumnRevelationType = 'revelationType';
  final ColumnAyahs = 'ayahs';

  final FavoritesTable = 'FavoritesTable';
  final FavoriteSurahId = 'id';
  final FavoriteSurahName = 'surahName';
  final FavoriteSurahAyahs = 'ayahs';
  final FavoriteSurahAddedAt = 'addedAt';


  Future<Database> getDB() async {
    if (db != null) {
      return db!;
    }
    db = await openDB();
    return db!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, _dbName);

    return await openDatabase(
      dbPath,
      version: _dbVersion, // UPDATED: Incremented version to 2
      onCreate: (Database db, int version) async {
        // This function runs ONLY when the database is created for the first time.
        // It should create the complete schema for a new user.
        await _createTables(db);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        // This function runs when the version number is increased.
        // It's used to migrate existing users' data.
        if (oldVersion < 2) {
          // If the user was on version 1, they don't have the FavoritesTable.
          // So, we create it for them.
          await db.execute('''
            CREATE TABLE $FavoritesTable (
              $FavoriteSurahId INTEGER PRIMARY KEY AUTOINCREMENT,
              $FavoriteSurahName TEXT UNIQUE,
              $FavoriteSurahAyahs TEXT,
              $FavoriteSurahAddedAt TEXT
            )
          ''');
        }
        // Example for future upgrades:
        // if (oldVersion < 3) {
        //   await db.execute('ALTER TABLE $SomeTable ADD COLUMN newColumn TEXT;');
        // }
      },
    );
  }

  // Helper method to create all tables for a new installation
  Future<void> _createTables(Database db) async {
     await db.execute('''
        CREATE TABLE $PrayerTimesTable (
          $ColumnTimeSNO INTEGER PRIMARY KEY AUTOINCREMENT,
          $ColumnTimeText TEXT,
          $ColumnTimeData TEXT)
      ''');

      await db.execute('''
        CREATE TABLE $QuranTable (
          $ColumnSurahId INTEGER PRIMARY KEY,
          $ColumnSurahNumber INTEGER,
          $ColumnSurahName TEXT,
          $ColumnEnglishName TEXT,
          $ColumnEnglishNameTranslation TEXT,
          $ColumnRevelationType TEXT,
          $ColumnAyahs TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE $TranslatedQuranTable (
          $ColumnSurahId INTEGER PRIMARY KEY,
          $ColumnSurahNumber INTEGER,
          $ColumnSurahName TEXT,
          $ColumnEnglishName TEXT,
          $ColumnEnglishNameTranslation TEXT,
          $ColumnRevelationType TEXT,
          $ColumnAyahs TEXT
        )
      ''');

      await db.execute('''
          CREATE TABLE $FavoritesTable (
            $FavoriteSurahId INTEGER PRIMARY KEY AUTOINCREMENT,
            $FavoriteSurahName TEXT UNIQUE,
            $FavoriteSurahAyahs TEXT,
            $FavoriteSurahAddedAt TEXT
          )
      ''');
  }


  // ----- Favourites -----
   Future<int> addFavorite(String surahName, List ayahs) async {
     final db = await getDB();
     return await db.insert(
      FavoritesTable,
      {
        FavoriteSurahName: surahName,
        FavoriteSurahAyahs: jsonEncode(ayahs),
        FavoriteSurahAddedAt: DateTime.now().toIso8601String(),
      },
       conflictAlgorithm: ConflictAlgorithm.replace,
     );
   }

   Future<List<Map<String, dynamic>>> getFavorites() async {
      final db = await getDB();
      final result = await db.query(FavoritesTable, orderBy: '$FavoriteSurahAddedAt DESC');
      return result.map((e) {
        final map = Map<String, dynamic>.from(e);
        // Ensure the 'ayahs' key exists before decoding
        if (map.containsKey(FavoriteSurahAyahs) && map[FavoriteSurahAyahs] != null) {
           map['ayahs'] = jsonDecode(map[FavoriteSurahAyahs] as String);
        }
        return map;
      }).toList();
   }

   Future<int> removeFavorite(String surahName) async {
     final db = await getDB();
     return await db.delete(
       FavoritesTable,
        where: '$FavoriteSurahName = ?',
        whereArgs: [surahName],
     );
   }

   Future<bool> isFavorite(String surahName) async {
     final db = await getDB();
     final result = await db.query(
       FavoritesTable,
        where: '$FavoriteSurahName = ?',
        whereArgs: [surahName],
     );
    return result.isNotEmpty;
   }


  // ----- Prayer Times -----
  Future<bool> addNote(String timeName, String timeData) async {
    var db = await getDB();
    int rowsEffected = await db.insert(PrayerTimesTable, {
      ColumnTimeText: timeName,
      ColumnTimeData: timeData,
    });
    return rowsEffected > 0;
  }

  Future<List<Map<String, dynamic>>> getAllTimesData() async {
    var db = await getDB();
    List<Map<String, dynamic>> getDataList = await db.query(PrayerTimesTable);
    return getDataList;
  }


  // ----- Arabic Surahs and Tranlated Surahs -----
  Future<void> insertArabicSurahs(List<Map<String, dynamic>> surahs) async {
    final db = await getDB();
    final batch = db.batch();
    for (var surah in surahs) {
      batch.insert(
        QuranTable,
        {
          'id': surah['number'],
          'number': surah['number'],
          'name': surah['name'],
          'englishName': surah['englishName'],
          'englishNameTranslation': surah['englishNameTranslation'],
          'revelationType': surah['revelationType'],
          'ayahs': jsonEncode(surah['ayahs']),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> insertEnglishSurahs(List<Map<String, dynamic>> translations) async {
    final db = await getDB();
    final batch = db.batch();
    for (var surah in translations) {
      batch.insert(
        TranslatedQuranTable,
        {
          'id': surah['id'],
          'number': surah['number'],
          'name': surah['name'],
          'englishName': surah['englishName'],
          'englishNameTranslation': surah['englishNameTranslation'],
          'revelationType': surah['revelationType'],
          'ayahs': jsonEncode(surah['ayahs']),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getArabicSurahs() async {
    final db = await getDB();
    final result = await db.query(QuranTable);
    return result.map((e) {
      final map = Map<String, dynamic>.from(e);
      if (map.containsKey(ColumnAyahs) && map[ColumnAyahs] != null) {
        map['ayahs'] = jsonDecode(map[ColumnAyahs] as String);
      }
      return map;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getEnglishSurahs() async {
    final db = await getDB();
    final result = await db.query(TranslatedQuranTable);
    return result.map((e) {
      final map = Map<String, dynamic>.from(e);
       if (map.containsKey(ColumnAyahs) && map[ColumnAyahs] != null) {
        map['ayahs'] = jsonDecode(map[ColumnAyahs] as String);
      }
      return map;
    }).toList();
  }

  Future<bool> isArabicSurahsEmpty() async {
    final db = await getDB();
    final result = await db.query(QuranTable, limit: 1);
    return result.isEmpty;
  }

  Future<bool> isEnglishSurahsEmpty() async {
    final db = await getDB();
    final result = await db.query(TranslatedQuranTable, limit: 1);
    return result.isEmpty;
  }

  Future<List<Map<String, dynamic>>> fetchAndStoreArabicData() async {
    try {
      final response = await http.get(Uri.parse('https://api.alquran.cloud/v1/quran/quran-uthmani'));
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result is Map<String, dynamic> && result['data']['surahs'] is List) {
          final surahs = List<Map<String, dynamic>>.from(result['data']['surahs']);
          await insertArabicSurahs(surahs);
          return surahs;
        } else {
          throw Exception('Unexpected API response structure');
        }
      } else {
        throw Exception('Failed to fetch Arabic Quran data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching Arabic Quran data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAndStoreEnglishData() async {
    try {
      final response = await http.get(Uri.parse('https://api.alquran.cloud/v1/quran/en.asad'));
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result is Map<String, dynamic> && result['data']['surahs'] is List) {
          final surahs = List<Map<String, dynamic>>.from(result['data']['surahs']);
          await insertEnglishSurahs(surahs);
          return surahs;
        } else {
          throw Exception('Unexpected API response structure');
        }
      } else {
        throw Exception('Failed to fetch English Quran data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching English Quran data: $e');
    }
  }

 }

