import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamic_app/GetClasses/FavoritesController.dart';
import 'package:islamic_app/UI/QuranRead/ReadFullSurah.dart';

class Favorites extends StatelessWidget {
  final controller = Get.put(FavoritesController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Obx(() {
          if (controller.favoriteSurahs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.bookmark_border_rounded,
                    size: 90,
                    color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "No favorites yet",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Mark Surahs as favorite to see them here",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: controller.favoriteSurahs.length,
            itemBuilder: (context, index) {
              final surah = controller.favoriteSurahs[index];

              final ayahsList = surah['ayahs'] as List?;
              final ayahsCount = ayahsList?.length ?? 0;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    if (ayahsList != null) {
                      Get.to(() => ReadFullSurah(
                          surahName: surah['surahName'], ayahs: ayahsList));
                    }
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Theme.of(context)
                              .primaryColor
                              .withOpacity(0.30),
                          child: Icon(
                            Icons.menu_book_rounded,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Surah ${surah['surahName']}',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? Colors.white
                                      : Colors.grey.shade900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$ayahsCount Ayahs',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: isDark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            controller.removeFromFavorites(surah['surahName']);
                          },
                          icon: Icon(
                            Icons.bookmark,
                            color: Colors.redAccent,
                            size: 26,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
