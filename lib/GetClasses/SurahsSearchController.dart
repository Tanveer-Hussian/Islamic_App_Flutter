// quran_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_app/Data/DataBaseClass.dart';

class SurahsSearchController extends GetxController {
  final DataBaseClass dbHelper = DataBaseClass.getInstance;

  // Use Rx variables for reactive state management
  var isLoading = true.obs;
  var allSurahs = <Map<String, dynamic>>[].obs;
  var filteredSurahs = <Map<String, dynamic>>[].obs;

  late TextEditingController searchedText;

  @override
  void onInit() {
    super.onInit();
    searchedText = TextEditingController();
    // Fetch the initial data
    fetchAndLoadSurahs();
    // Add a listener to the search controller
    searchedText.addListener(() {
      performSearch();
    });
  }

  @override
  void onClose() {
    // Dispose the controller to prevent memory leaks
    searchedText.dispose();
    super.onClose();
  }

  void fetchAndLoadSurahs() async {
    try {
      isLoading(true);
      List<Map<String, dynamic>> surahs;
      if (await dbHelper.isArabicSurahsEmpty()) {
        surahs = await dbHelper.fetchAndStoreArabicData();
      } else {
        surahs = await dbHelper.getArabicSurahs();
      }
      allSurahs.assignAll(surahs);
      filteredSurahs.assignAll(allSurahs); // Initially, filtered list is the full list
    } catch (e) {
      // Handle potential errors, e.g., show a snackbar
      Get.snackbar("Error", "Failed to load Surah data.");
      print("Error fetching Surahs: $e");
    } finally {
      isLoading(false);
    }
  }

  void performSearch() {
    final searchTerm = searchedText.text.toLowerCase();
    if (searchTerm.isEmpty) {
      // If search is empty, show all surahs
      filteredSurahs.assignAll(allSurahs);
    } else {
      // Otherwise, filter the list
      filteredSurahs.assignAll(allSurahs.where((surah) {
        final englishName = surah['englishName'].toString().toLowerCase();
        final englishNameTranslation =
            surah['englishNameTranslation'].toString().toLowerCase();
        final surahNumber = surah['number'].toString();

        return englishName.contains(searchTerm) ||
            englishNameTranslation.contains(searchTerm) ||
            surahNumber.contains(searchTerm);
      }).toList());
    }
  }
}
