import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamic_app/GetClasses/SurahsSearchController.dart';
import 'package:islamic_app/UI/QuranRead/ReadFullSurah.dart';
import 'package:shimmer/shimmer.dart';

class HolyQuranRead extends StatelessWidget {
  final SurahsSearchController controller = Get.put(SurahsSearchController());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Holy Quran'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(
            top: screenHeight * 0.02,
            left: screenWidth * 0.07,
            right: screenWidth * 0.07),
        child: Column(
          children: [
            /// Search Box
            Container(
              width: screenWidth * 0.8,
              height: screenHeight * 0.06,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.grey[300]!,
                          blurRadius: 8,
                          offset: const Offset(0, 1),
                        ),
                      ],
              ),
              child: TextField(
                controller: controller.searchedText,
                style: GoogleFonts.poppins(
                    color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: 'Search Surah',
                  hintStyle: GoogleFonts.poppins(
                      color: isDark ? Colors.grey[400] : Colors.grey[600]),
                  prefixIcon:
                      Icon(Icons.search, color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            /// 📖 Surah List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return shimmerLoader(screenHeight, screenWidth, isDark);
                }
                if (controller.filteredSurahs.isEmpty) {
                  return Center(
                      child: Text('No Data!',
                          style: GoogleFonts.poppins(
                              color: isDark ? Colors.white70 : Colors.black87)));
                }

                return ListView.builder(
                  itemCount: controller.filteredSurahs.length,
                  itemBuilder: (context, surahIndex) {
                    final surah = controller.filteredSurahs[surahIndex];
                    final ayahs = surah['ayahs'] as List<dynamic>;

                    return AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(milliseconds: 300 + (surahIndex * 100)),
                      child: Card(
                        elevation: 2,
                        color: isDark ? Colors.grey[850] : Colors.grey[200],
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Surah Name & Arabic
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Surah ${surah['englishName']}',
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 16,
                                                  color: isDark
                                                      ? Colors.white
                                                      : Colors.black),
                                              overflow: TextOverflow.ellipsis),
                                          SizedBox(height: 4),
                                          Text(
                                            'Meaning: ${surah['englishNameTranslation']}',
                                            style: GoogleFonts.poppins(
                                                color: isDark
                                                    ? Colors.grey[400]
                                                    : Colors.grey[600],
                                                fontSize: 15),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(surah['name'],
                                        style: GoogleFonts.notoNaskhArabic(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: isDark
                                                ? Colors.green[300]
                                                : Colors.green[700])),
                                  ]),
                              SizedBox(height: 8),

                              /// Revelation Type
                              Text('${surah['revelationType']} Surah',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black87)),
                              SizedBox(height: 6),

                              /// Surah Number
                              Text('Surah Number : ${surah['number']}',
                                  style: TextStyle(
                                      color: isDark
                                          ? Colors.grey[300]
                                          : Colors.black)),

                              SizedBox(height: 8),

                              /// Read Button
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(() => ReadFullSurah(
                                        surahName: surah['englishName'],
                                        ayahs: ayahs,
                                      ));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[700],
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                                child: Center(
                                    child: Text("Read Surah",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600))),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// ⭐ Shimmer Loader with Dark Mode Support
  Widget shimmerLoader(
      double screenHeight, double screenWidth, bool isDark) {
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[500]! : Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              width: screenWidth * 0.7,
              height: screenHeight * 0.17,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: screenWidth * 0.4,
                        height: 20,
                        color: isDark ? Colors.grey[700] : Colors.grey[300]),
                    const SizedBox(height: 8),
                    Container(
                        width: screenWidth * 0.6,
                        height: 14,
                        color: isDark ? Colors.grey[700] : Colors.grey[300]),
                    const SizedBox(height: 8),
                    Container(
                        width: screenWidth * 0.2,
                        height: 14,
                        color: isDark ? Colors.grey[700] : Colors.grey[300]),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
