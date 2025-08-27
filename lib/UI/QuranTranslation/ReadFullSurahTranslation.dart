import 'package:flutter/material.dart';

class ReadFullSurahTranslation extends StatelessWidget {
  final String surahName;
  final List<dynamic> arabicAyahs;
  final List<dynamic> englishAyahs;

  ReadFullSurahTranslation({
    super.key,
    required this.surahName,
    required this.arabicAyahs,
    required this.englishAyahs,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(surahName),
        backgroundColor: Colors.green[700], // keep AppBar green always
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: screenHeight * 0.02,
        ),
        child: ListView.builder(
          itemCount: arabicAyahs.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 3,
              color: isDark ? Colors.grey[850] : Colors.white, // card background
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.015,
                  horizontal: screenWidth * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Arabic Ayah
                    Text(
                      arabicAyahs[index]['text'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: 4),
                    // English Translation
                    Text(
                      englishAyahs[index]['text'],
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: isDark ? Colors.grey[300] : Colors.black87,
                      ),
                    ),
                    // Ayah Number
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: EdgeInsets.only(top: 4),
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                        child: Text(
                          arabicAyahs[index]['number'].toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
