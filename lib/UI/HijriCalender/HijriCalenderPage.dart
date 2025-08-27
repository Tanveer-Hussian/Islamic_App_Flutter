import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hijri_picker/hijri_picker.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:islamic_app/GetClasses/HijriCalenderController.dart';
import 'package:islamic_app/Data/IslamicEvents.dart';

class HijriCalenderPage extends StatelessWidget {
  final HijriCalendercontroller controller = Get.put(HijriCalendercontroller());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hijri Calendar'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: [
            /// ✅ Today’s date + Selected Hijri date
            Obx(
              () => Card(
                elevation: 5,
                color: isDark ? Colors.grey[800] : Colors.teal.shade50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text(
                        'Today date is : ${HijriCalendar.now()}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.010),
                      Text(
                        "Selected Hijri Date : ${controller.selectedDate.value.hDay}/"
                        "${controller.selectedDate.value.hMonth}/"
                        "${controller.selectedDate.value.hYear}",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.03),

            /// ✅ Hijri Month Picker
            SizedBox(
              height: screenHeight * 0.4,
              child: Obx(
                () => Card(
                  elevation: 2,
                  color: isDark? Colors.green[600] : theme.cardColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: HijriMonthPicker(
                      selectedDate: controller.selectedDate.value,
                      firstDate: HijriCalendar()
                        ..hYear = 1400
                        ..hMonth = 1
                        ..hDay = 1,
                      lastDate: HijriCalendar()
                        ..hYear = 1500
                        ..hMonth = 12
                        ..hDay = 29,
                      onChanged: (date) {
                        controller.updateDate(date);
                      },
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.05),

            ///  Islamic Events
            Text(
              "Today's Islamic Events:",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 10),

            Obx(() {
              final todayEvents = islamicEvents.where((event) =>
                  event.day == controller.selectedDate.value.hDay &&
                  event.month == controller.selectedDate.value.hMonth).toList();

              if (todayEvents.isEmpty) {
                return Center(
                  child: Text(
                    "No Islamic event on Selected Date",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: todayEvents.length,
                itemBuilder: (context, index) {
                  final event = todayEvents[index];
                  return Card(
                    elevation: 3,
                    color: isDark ? theme.colorScheme.primaryContainer : Colors.lightBlue.shade100,
                    shadowColor: theme.shadowColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      width: screenWidth * 0.7,
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            event.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? theme.colorScheme.onPrimaryContainer
                                  : Colors.blue[900],
                            ),
                          ),
                          Text(
                            "Date: ${event.day}",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? theme.colorScheme.onPrimaryContainer
                                  : Colors.blueGrey[800],
                            ),
                          ),
                          if (event.description != null)
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                event.description,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isDark
                                      ? theme.colorScheme.onPrimaryContainer
                                      : Colors.black87,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
        
          ],
        ),
      ),
    );
  }
}
