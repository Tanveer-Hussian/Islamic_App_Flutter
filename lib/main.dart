import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamic_app/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('isDarkMode') ?? false; // consistent key

  final ThemeController themeController = Get.put(ThemeController());
  themeController.isDark.value = isDark;

  runApp(const MyApp());
}

/// Theme Controller for Dark/Light Mode
class ThemeController extends GetxController {
  var isDark = false.obs;

  ThemeMode get theme => isDark.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() async {
    isDark.value = !isDark.value;
    Get.changeThemeMode(theme);

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDarkMode", isDark.value); // ✅ consistent key
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(() => GetMaterialApp(
          title: 'Islamic App',
          debugShowCheckedModeBanner: false,

          /// Light Theme
          theme: ThemeData(
            primaryColor: Colors.green[700],
            scaffoldBackgroundColor: Colors.grey[100],
            fontFamily: GoogleFonts.notoNaskhArabic().fontFamily,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
            ),
            cardTheme: CardTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
              elevation: 3,
            ),
          ),

          /// Dark Theme
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.green[700],
            scaffoldBackgroundColor: Colors.black,
            fontFamily: GoogleFonts.notoNaskhArabic().fontFamily,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
            ),
            cardTheme: CardTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.grey[00],
              elevation: 3,
            ),
          ),

          /// Auto switch
          themeMode: themeController.theme,

          home: HomePage(),
        ));
  }
}
