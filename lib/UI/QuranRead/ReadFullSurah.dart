import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamic_app/GetClasses/FavoritesController.dart';

class ReadFullSurah extends StatefulWidget {
  const ReadFullSurah({super.key, required this.surahName, required this.ayahs});

  final String surahName;
  final List<dynamic> ayahs;

  @override
  State<ReadFullSurah> createState() => _ReadFullSurahState();
}

class _ReadFullSurahState extends State<ReadFullSurah> {
  final controller = Get.put(FavoritesController());

  @override
  void initState() {
    super.initState();
    controller.checkFavorite(widget.surahName);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.surahName,
          style: GoogleFonts.notoNaskhArabic(fontWeight: FontWeight.bold),
        ),
        actions: [
          Obx(() {
            final isFav = controller.isFav.value;
            return IconButton(
              onPressed: () {
                if (isFav) {
                  controller.removeFromFavorites(widget.surahName);
                } else {
                  controller.addToFavorites(widget.surahName, widget.ayahs);
                }
              },
              icon: Icon(
                Icons.bookmark,
                color: isFav ? Colors.red : (isDark ? Colors.white : Colors.black),
              ),
            );
          }),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [Colors.green[700]!, Colors.green[500]!]
                  : [Colors.green[700]!, Colors.green[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: ListView.builder(
          itemCount: widget.ayahs.length,
          itemBuilder: (context, ayahIndex) {
            return AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 300 + (ayahIndex * 100)),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                color: isDark ? Colors.grey[800] : Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.03,
                    vertical: screenWidth * 0.02,
                  ),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                          child: Text(
                            widget.ayahs[ayahIndex]['number'].toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.015),
                      Expanded(
                        child: Text(
                          widget.ayahs[ayahIndex]['text'],
                          style: GoogleFonts.notoNaskhArabic(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
