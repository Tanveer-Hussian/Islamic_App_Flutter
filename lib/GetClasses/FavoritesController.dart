import 'package:get/get.dart';
import 'package:islamic_app/Data/DataBaseClass.dart';
import 'dart:convert';

class FavoritesController extends GetxController {
  var favoriteSurahs = <Map<String, dynamic>>[].obs;
  var isFav = false.obs;   // <-- add this reactive bool
  final db = DataBaseClass.getInstance;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    favoriteSurahs.value = await db.getFavorites();
  }

  Future<void> addToFavorites(String surahName, List ayahs) async {
    await db.addFavorite(surahName, ayahs);
    isFav.value = true;
    await loadFavorites();
  }

  Future<void> removeFromFavorites(String surahName) async {
    await db.removeFavorite(surahName);
    isFav.value = false;
    await loadFavorites();
  }

  Future<void> checkFavorite(String surahName) async {
    isFav.value = await db.isFavorite(surahName);
  }
}
