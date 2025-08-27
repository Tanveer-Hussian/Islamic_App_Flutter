class IslamicEvents {
  final int day;
  final int month;
  final String title;
  final String description;

  IslamicEvents({
    required this.day,
    required this.month,
    required this.title,
    required this.description,
  });
}

final List<IslamicEvents> islamicEvents = [
  // Muharram
  IslamicEvents(day: 1, month: 1, title: "Islamic New year", description: "First day of Muharram, start of the Hijri year"),
  IslamicEvents(day: 9, month: 1, title: "Fast of Tasu’a", description: "Recommended fasting on the 9th of Muharram"),
  IslamicEvents(day: 10, month: 1, title: "Day of Ashura", description: "Commemoration of Imam Hussain’s (RA) martyrdom; fasting recommended"),
  
  // Safar
  IslamicEvents(day: 20, month: 2, title: "Arbaeen", description: "40th day after Ashura, observed in Shia tradition"),
  IslamicEvents(day: 17, month: 2, title: "Battle of Khaybar", description: "Muslim victory in 7 AH, date approximate"),
  
  // Rabi al-Awwal
  IslamicEvents(day: 5, month: 3, title: "Arrival in Quba", description: "Prophet (ﷺ) builds first mosque during Hijrah, 1 AH"),
  IslamicEvents(day: 12, month: 3, title: "Mawlid al-Nabi", description: "Birth of Prophet Muhammad (ﷺ), 12th in Sunni tradition, 17th in some Shia traditions"),
  
  // Rabi al-Thani
  IslamicEvents(day: 11, month: 4, title: "Wafat of Shaykh Abdul Qadir Jilani (RA)", description: "Passing of Sufi saint, 561 AH"),
  
  // Jumada al-Awwal
  IslamicEvents(day: 5, month: 5, title: "Battle of Mu’tah", description: "First battle with Byzantines, 8 AH, date approximate"),
  
  // Jumada al-Thani
  IslamicEvents(day: 20, month: 6, title: "Birth of Fatimah (RA)", description: "Daughter of Prophet (ﷺ), date approximate"),
  IslamicEvents(day: 3, month: 6, title: "Birth of Imam Husayn (RA)", description: "Grandson of Prophet (ﷺ), often dated to Sha’ban 4 AH in Shia tradition"),
  
  // Rajab
  IslamicEvents(day: 1, month: 7, title: "Start of Rajab", description: "Beginning of a sacred month"),
  IslamicEvents(day: 27, month: 7, title: "Isra and Mi’raj", description: "Night Journey and Ascension of Prophet (ﷺ), date traditional"),
  
  // Sha’ban
  IslamicEvents(day: 1, month: 8, title: "Start of Sha’ban", description: "Preparations for Ramadan"),
  IslamicEvents(day: 15, month: 8, title: "Shab-e-Barat", description: "Night of forgiveness, observed in some traditions"),
  IslamicEvents(day: 15, month: 8, title: "Birth of Imam Hasan (RA)", description: "Grandson of Prophet (ﷺ), often dated to Ramadan 3 AH in some sources"),
  
  // Ramadan
  IslamicEvents(day: 1, month: 9, title: "Start of Ramadan", description: "Beginning of the holy month of fasting"),
  IslamicEvents(day: 17, month: 9, title: "Battle of Badr", description: "First decisive Muslim victory, 2 AH"),
  IslamicEvents(day: 19, month: 9, title: "Ali ibn Abi Talib (RA) wounded", description: "Wounded in Kufa, 40 AH"),
  IslamicEvents(day: 20, month: 9, title: "Conquest of Makkah", description: "Muslims enter Makkah peacefully, 8 AH"),
  IslamicEvents(day: 21, month: 9, title: "Martyrdom of Ali (RA)", description: "Fourth Caliph passes away, 40 AH"),
  IslamicEvents(day: 27, month: 9, title: "Laylat al-Qadr", description: "Night of Power, typically 27th but may be any odd night in last ten days. \n Observed by majority as Laylat al-Qadr but Laylat al-Qadr is one from nights of 21, 23, 25, 17 and 29"),
  
  // Shawwal
  IslamicEvents(day: 1, month: 10, title: "Eid al-Fitr", description: "Festival of breaking the fast"),
  IslamicEvents(day: 15, month: 10, title: "Battle of Uhud", description: "Battle with Quraysh, 3 AH, date approximate"),
  IslamicEvents(day: 15, month: 10, title: "Martyrdom of Hamza (RA)", description: "Uncle of Prophet (ﷺ) martyred at Uhud, 3 AH"),
  IslamicEvents(day: 10, month: 10, title: "Marriage of Prophet (ﷺ) to Aisha (RA)", description: "Nikah after Hijrah, 1-2 AH, date approximate"),
  IslamicEvents(day: 1, month: 10, title: "Battle of Hunayn", description: "Victory after Makkah conquest, 8 AH, date approximate"),
  IslamicEvents(day: 1, month: 10, title: "Battle of Khandaq", description: "Trench defense, 5 AH, date approximate"),
  
  // Dhu al-Qa’dah
  IslamicEvents(day: 25, month: 11, title: "Treaty of Hudaybiyyah", description: "Peace agreement with Quraysh, 6 AH, date approximate"),
  
  // Dhu al-Hijjah
  IslamicEvents(day: 8, month: 12, title: "Day of Tarwiyah", description: "Pilgrims leave Makkah for Mina during Hajj"),
  IslamicEvents(day: 9, month: 12, title: "Day of Arafah", description: "Central day of Hajj, fasting recommended"),
  IslamicEvents(day: 9, month: 12, title: "Farewell Sermon", description: "Prophet (ﷺ) delivers last sermon, 10 AH"),
  IslamicEvents(day: 10, month: 12, title: "Eid al-Adha", description: "Festival of Sacrifice"),
  IslamicEvents(day: 11, month: 12, title: "First day of Tashreeq", description: "Days of remembrance in Mina"),
  IslamicEvents(day: 12, month: 12, title: "Second day of Tashreeq", description: "Continued rituals in Mina"),
  IslamicEvents(day: 13, month: 12, title: "Third day of Tashreeq", description: "Final day for pilgrims in Mina"),
  IslamicEvents(day: 18, month: 12, title: "Ghadir Khumm", description: "Prophet (ﷺ) addresses companions, 10 AH, emphasized in Shia tradition"),
  IslamicEvents(day: 18, month: 12, title: "Martyrdom of Uthman ibn Affan (RA)", description: "Third Caliph martyred, 35 AH"),

 ];

