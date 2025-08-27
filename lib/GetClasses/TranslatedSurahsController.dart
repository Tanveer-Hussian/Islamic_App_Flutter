import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_app/Data/DataBaseClass.dart';

class TranslatedSurahsController extends GetxController {
  final DataBaseClass dbHelper = DataBaseClass.getInstance;

  // Observable lists for Arabic and English surahs
  var arabicSurahs = <Map<String, dynamic>>[].obs;
  var englishSurahs = <Map<String, dynamic>>[].obs;

  // Observable lists for filtered search results
  var filteredArabicSurahs = <Map<String, dynamic>>[].obs;
  var filteredEnglishSurahs = <Map<String, dynamic>>[].obs;

  // Loading state
  var isLoading = true.obs;

  // Search text controller
  TextEditingController searchTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getTranslationData();
    // Listener for search text changes
    searchTextController.addListener(() {
      filterSurahs(searchTextController.text);
    });
  }

  // Fetches Quranic data from the database
  Future<void> getTranslationData() async {
    try {
      isLoading.value = true;
      bool isArabicEmpty = await dbHelper.isArabicSurahsEmpty();
      bool isEnglishEmpty = await dbHelper.isEnglishSurahsEmpty();

      if (isArabicEmpty) {
        arabicSurahs.value = await dbHelper.fetchAndStoreArabicData();
      } else {
        arabicSurahs.value = await dbHelper.getArabicSurahs();
      }

      if (isEnglishEmpty) {
        englishSurahs.value = await dbHelper.fetchAndStoreEnglishData();
      } else {
        englishSurahs.value = await dbHelper.getEnglishSurahs();
      }

      // Initialize filtered lists with all surahs
      filteredArabicSurahs.value = arabicSurahs;
      filteredEnglishSurahs.value = englishSurahs;
    } catch (e) {
      // Handle potential errors
      print("Error fetching data: $e");
      Get.snackbar("Error", "Failed to load Quranic data.");
    } finally {
      isLoading.value = false;
    }
  }

  // Filters surahs based on user input
  void filterSurahs(String query) {
    // Trim whitespace from the query
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      // If search is empty, show all surahs
      filteredArabicSurahs.value = arabicSurahs;
      filteredEnglishSurahs.value = englishSurahs;
    } else {
      // Filter by English name, Arabic name, or Surah number
      List<Map<String, dynamic>> filteredEnglish = englishSurahs
          .where((surah) {
            final englishName = surah['englishName'].toString().toLowerCase();
            final arabicName = surah['name'].toString().toLowerCase(); // Assuming 'name' is Arabic
            final surahNumber = surah['number'].toString();
            final lowerCaseQuery = trimmedQuery.toLowerCase();

            return englishName.contains(lowerCaseQuery) ||
                   arabicName.contains(lowerCaseQuery) ||
                   surahNumber == trimmedQuery; // Exact match for number
          })
          .toList();

      List<int> filteredNumbers =
          filteredEnglish.map((s) => s['number'] as int).toList();

      List<Map<String, dynamic>> filteredArabic = arabicSurahs
          .where((surah) => filteredNumbers.contains(surah['number']))
          .toList();

      filteredEnglishSurahs.value = filteredEnglish;
      filteredArabicSurahs.value = filteredArabic;
    }
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }
}
