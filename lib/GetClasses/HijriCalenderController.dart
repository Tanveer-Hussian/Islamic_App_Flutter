import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';

class HijriCalendercontroller extends GetxController{
   var selectedDate = HijriCalendar.now().obs;

   void updateDate(HijriCalendar date){
     selectedDate.value = date;
   }


}