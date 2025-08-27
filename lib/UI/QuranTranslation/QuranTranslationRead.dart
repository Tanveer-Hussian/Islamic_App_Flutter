import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamic_app/GetClasses/SurahsSearchController.dart';
import 'package:islamic_app/GetClasses/TranslatedSurahsController.dart';
import 'package:islamic_app/UI/QuranTranslation/ReadFullSurahTranslation.dart';
import 'package:shimmer/shimmer.dart';


class QuranTranlationRead extends GetView<TranslatedSurahsController> {
  const QuranTranlationRead({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    Get.put(TranslatedSurahsController());

    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = theme.brightness == Brightness.dark;


    return Scaffold(
  appBar: AppBar(
    title: Text(
      'Holy Quran Translation',
      style: GoogleFonts.notoNaskhArabic(
        fontWeight: FontWeight.w600,
        fontSize: 19,
      ),
    ),
    centerTitle: true,
    backgroundColor: Colors.green,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade700, Colors.green.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
  ),

  body: Padding(
    padding: EdgeInsets.only(
      top: screenHeight * 0.02,
      left: screenWidth * 0.06,
      right: screenWidth * 0.06,
    ),
    child: Column(
      children: [

        // 🔹 Search Box
        Container(
          width: screenWidth * 0.8,
          height: screenHeight * 0.06,
          decoration: BoxDecoration(
            color: isDark? Colors.grey[800]: Colors.white, // adapts with dark mode
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 1),
              )
            ],
          ),
          child: TextField(
            controller: controller.searchTextController,
            style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
            decoration: InputDecoration(
              hintText: 'Search Surah',
              hintStyle: GoogleFonts.poppins(
                color: Theme.of(context).hintColor,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.green[700],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        SizedBox(height: screenHeight * 0.03),

        // 🔹 Surah List
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return shimmerLoader(screenHeight, screenWidth);
            }
            if (controller.filteredArabicSurahs.isEmpty ||
                controller.filteredEnglishSurahs.isEmpty) {
              return Center(
                child: Text(
                  'No Data!',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: controller.filteredEnglishSurahs.length,
              itemBuilder: (context, surahIndex) {
                final englishSurah = controller.filteredEnglishSurahs[surahIndex];
                final arabicSurah = controller.filteredArabicSurahs
                    .firstWhere((s) => s['number'] == englishSurah['number']);
                final arabicAyahs = arabicSurah['ayahs'] as List;
                final englishAyahs = englishSurah['ayahs'] as List;

                return AnimatedOpacity(
                  opacity: 1.0,
                  duration: Duration(milliseconds: 300 + (surahIndex * 100)),
                  child: Card(
                    elevation: 1,
                    color: isDark ? Colors.grey[850] : Colors.white, // 🔹 adapts
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Surah ${englishSurah['englishName']}',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                        color: Theme.of(context).textTheme.bodyLarge!.color,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Meaning: ${englishSurah['englishNameTranslation']}',
                                      style: GoogleFonts.poppins(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 15,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                arabicSurah['name'],
                                style: GoogleFonts.notoNaskhArabic(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Theme.of(context).textTheme.bodyLarge!.color,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${englishSurah['revelationType']} Surah',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Surah Number : ${englishSurah['number']}',
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              Get.to(() => ReadFullSurahTranslation(
                                    surahName: englishSurah['englishName'],
                                    arabicAyahs: arabicAyahs,
                                    englishAyahs: englishAyahs,
                                  ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Read Surah',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
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

  // ShimmerLoader Widget
  Widget shimmerLoader(double screenHeight, double screenWidth) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
          itemCount: 7,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Container(
                width: screenWidth * 0.7,
                height: screenHeight * 0.17,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: screenWidth * 0.4,
                        height: 20,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: screenWidth * 0.6,
                        height: 14,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: screenWidth * 0.2,
                        height: 14,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

