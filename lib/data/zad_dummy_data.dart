/// مقاطع قصيرة وهمية — روابط أو عناوين لتابة زاد.
class ShortClipItem {
  const ShortClipItem({
    required this.title,
    required this.description,
    this.videoUrl,
  });

  final String title;
  final String description;
  final String? videoUrl;
}

/// مقولات يومية وهمية — واحدة لكل يوم (حسب يوم السنة).
const List<String> kDailyQuotes = [
  '"وَمَا تَوْفِيقِي إِلَّا بِاللَّهِ ۚ عَلَيْهِ تَوَكَّلْتُ وَإِلَيْهِ أُنِيبُ" — هود: 88',
  '"رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ" — البقرة: 201',
  '"فَاذْكُرُونِي أَذْكُرْكُمْ وَاشْكُرُوا لِي وَلَا تَكْفُرُونِ" — البقرة: 152',
  '"إِنَّ مَعَ الْعُسْرِ يُسْرًا" — الشرح: 6',
  '"وَاصْبِرْ وَمَا صَبْرُكَ إِلَّا بِاللَّهِ" — النحل: 127',
  '"وَمَن يَتَوَكَّلْ عَلَى اللَّهِ فَهُوَ حَسْبُهُ" — الطلاق: 3',
  '"رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي" — طه: 25-26',
  '"إِنَّ اللَّهَ مَعَ الصَّابِرِينَ" — البقرة: 153',
];

/// مقولة اليوم حسب يوم السنة (تتكرر من القائمة).
String getDailyQuoteForToday() {
  final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
  return kDailyQuotes[dayOfYear % kDailyQuotes.length];
}

/// مقاطع قصيرة وهمية لتابة زاد.
const List<ShortClipItem> kShortClips = [
  ShortClipItem(
    title: 'مقطع 1',
    description: 'نص تراكب كما في الـ Reels — وصف قصير أو مقولة.',
    videoUrl: null,
  ),
  ShortClipItem(
    title: 'مقطع 2',
    description: 'فيديو قصير عن الأذكار والطمأنينة.',
    videoUrl: null,
  ),
  ShortClipItem(
    title: 'مقطع 3',
    description: 'كلمة عن الصبر والتوكل.',
    videoUrl: null,
  ),
  ShortClipItem(
    title: 'مقطع 4',
    description: 'نص تراكب كما في الـ Reels — وصف قصير أو مقولة.',
    videoUrl: null,
  ),
];
