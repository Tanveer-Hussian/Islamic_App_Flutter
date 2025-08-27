import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:islamic_app/UI/HijriCalender/HijriCalenderPage.dart';
import 'package:islamic_app/UI/PrayerTimes/PrayerTimesPage.dart';
import 'package:islamic_app/UI/QuranRead/HolyQuranRead.dart';
import 'package:islamic_app/UI/QuranTranslation/QuranTranslationRead.dart';
import 'package:islamic_app/UI/SideMenuBar/About%20App.dart';
import 'package:islamic_app/UI/SideMenuBar/Favorites.dart';
import 'package:islamic_app/main.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(

      drawer: WholeDrawer(),

      appBar: AppBar(
        title: Text('Islamic App'),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Icons.menu),
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search_rounded))
        ],
      ),
     
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          children: [

            /// Welcome Card
          Container(
             width: screenWidth * 0.9,
             height: screenHeight * 0.22,
             padding: EdgeInsets.all(screenWidth * 0.04),
             decoration: BoxDecoration(
               gradient: LinearGradient(
                 colors: Theme.of(context).brightness == Brightness.dark
                 ? [
                   Colors.grey.shade900,
                   Colors.grey.shade800,
                  ]
                 : [
                   Colors.white,
                   Colors.grey.shade200,
                   ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                       ? Colors.black.withOpacity(0.6)
                       : Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
               ),
              child: CarouselSlider(
                options: CarouselOptions(
                   height: screenHeight * 0.18,             
                   autoPlay: true,
                   enlargeCenterPage: true,
                   viewportFraction: 0.85,
                   aspectRatio: 16 / 9,
                   autoPlayInterval: Duration(seconds: 4),
                 ),
                items: [
                   DuaCard(context, "رَبِّ زِدْنِي عِلْمًا", "My Lord, increase me in knowledge."),
                   DuaCard(context, "اللّهُمَّ اغْفِرْ لِي", "O Allah, forgive me."),
                   DuaCard(context, "رَبَّنَا تَقَبَّلْ مِنَّا", "Our Lord, accept from us."),
                   DuaCard(context, "اللَّهُمَّ اجْعَلْنِي مِنَ التَّوَّابِينَ", "O Allah, make me among those who repent."),
                   DuaCard(context, "اللَّهُمَّ اشْرَحْ لِي صَدْرِي", "O Allah, expand my chest with comfort."),
                   DuaCard(context, "اللَّهُمَّ ارْزُقْنِي الْجَنَّةَ", "O Allah, grant me Paradise."),
                   DuaCard(context, "رَبِّ اشْفِ مَرْضَانَا", "My Lord, heal our sick."),],

              ),
            ),

            SizedBox(height: screenHeight * 0.04),

            /// Menu Grid
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: screenWidth * 0.020,
              mainAxisSpacing: screenWidth * 0.020,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                HomeMenuCard(
                    img: 'assets/quran.png',
                    label: 'Read Holy Quran',
                    color: Colors.green,
                    onTap: () => Get.to(() => HolyQuranRead()),
                    isDark: isDark, ),
                HomeMenuCard(
                    img: 'assets/learn-language.png',
                    label: 'Quran with Translation',
                    color: Colors.blue,
                    onTap: () => Get.to(() => QuranTranlationRead()),
                    isDark: isDark),
                HomeMenuCard(
                    img: 'assets/time.png',
                    label: 'Prayer Times',
                    color: Colors.deepOrange,
                    onTap: () => Get.to(() => PrayerTimesPage()),
                    isDark: isDark,),
                HomeMenuCard(
                    img: 'assets/calendar.png',
                    label: 'Hijri Calender',
                    color: Colors.green,
                    onTap: () => Get.to(() => HijriCalenderPage()),
                    isDark: isDark, ),
              ],
            ),
         
          ],
        ),
      ),
    );
  }

  /// Drawer
  Drawer WholeDrawer() {
    final ThemeController themeController = Get.find();

    return Drawer(
      child: Column(
        children: [
          /// Header
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade700, Colors.green.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Theme.of(Get.context!).cardColor, // ✅ Dark mode aware
                  child: Icon(Icons.person, color: Colors.green, size: 36),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Assalamualaikum",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    Text("Guest User",
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                  ],
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text("Main Menu",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ),

          DrawerWidget("Read Holy Quran", FeatherIcons.bookOpen, Colors.green,
              () => Get.to(() => HolyQuranRead())),
          DrawerWidget("Quran Translation", FeatherIcons.globe, Colors.blue,
              () => Get.to(() => QuranTranlationRead())),
          DrawerWidget("View Prayer Times", FeatherIcons.clock, Colors.orange,
              () => Get.to(() => PrayerTimesPage())),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text("Other",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ),

          DrawerWidget("Favourites", FeatherIcons.bookmark, Colors.redAccent,
              () => Get.to(() => Favorites())),

          /// ✅ Dark Mode Toggle
          Obx(() {
            return SwitchListTile(
              title: Text("Dark Mode"),
              secondary: Icon(
                themeController.isDark.value
                    ? FeatherIcons.moon
                    : FeatherIcons.sun,
                color: Colors.blueGrey,
              ),
              value: themeController.isDark.value,
              onChanged: (val) {
                themeController.toggleTheme();
              },
            );
          }),

          DrawerWidget("About App", FeatherIcons.info, Colors.red,
              () => Get.to(() => AboutAppPage())),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text("© 2025 Islamic App",
                style: TextStyle(
                    fontSize: 12, color: Theme.of(Get.context!).hintColor)),
          ),
        ],
      ),
    );
  }
}

/// Drawer Widget
Padding DrawerWidget(String title, IconData icon, Color color, VoidCallback onTouch) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: GestureDetector(
      onTap: onTouch,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 1,
        color: Theme.of(Get.context!).cardColor, // ✅ Dark mode aware
        child: ListTile(
          leading: Icon(icon, color: color),
          title: Text(title, style: Theme.of(Get.context!).textTheme.bodyMedium),
          trailing: Icon(Icons.arrow_back_ios, size: 18),
        ),
      ),
    ),
  );
}

/// Home Menu Icon
class HomeMenuCard extends StatelessWidget {
  final String img;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final isDark;

  const HomeMenuCard({
    required this.img,
    required this.label,
    required this.color,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: isDark? Colors.grey[850]: Theme.of(context).cardColor, 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: color.withOpacity(0.2),
                child: Image.asset(img,width: 30, height: 30,)
              ),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium, // ✅ Dark mode aware
              )
            ],
          ),
        ),
      ),
    );
  }
}


Widget DuaCard(BuildContext context, String arabic, String translation) {
  return Container(
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.symmetric(horizontal: 6),
    height: MediaQuery.of(context).size.height*0.18,
    width: MediaQuery.of(context).size.width*0.7,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: Theme.of(context).brightness == Brightness.dark
            ? [Colors.teal.shade700, Colors.teal.shade500]
            : [Colors.green.shade300, Colors.green.shade100],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black.withOpacity(0.4)
              : Colors.grey.withOpacity(0.2),
          blurRadius: 6,
          offset: Offset(2, 4),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          arabic,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Text(
          translation,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white70
                : Colors.black54,
          ),
        ),
      ],
    ),
  );
}

