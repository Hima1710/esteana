// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'استعانة';

  @override
  String get startJourney => 'ابدأ رحلتي';

  @override
  String get welcomeToJourney => 'مرحباً بك في رحلتك';

  @override
  String get loginGoogle => 'الدخول بجوجل';

  @override
  String get continueGuest => 'المتابعة كضيف';

  @override
  String get skip => 'تخطي';

  @override
  String get guestSyncMessage => 'سجّل الدخول لحفظ إنجازتك للأبد.';

  @override
  String get loginRequired => 'سجّل الدخول لطلب الدعاء.';

  @override
  String get timeRemaining => 'يتبقى';

  @override
  String get dhikrComingSoon => 'قسم الأذكار قريباً.';

  @override
  String get qiblaComingSoon => 'محدد القبلة قريباً.';

  @override
  String get share => 'مشاركة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get submit => 'إرسال';

  @override
  String get nextPrayer => 'الصلاة القادمة';

  @override
  String get quickAccess => 'وصول سريع';

  @override
  String get prayerTimes => 'مواعيد الصلاة';

  @override
  String get prayerTimesMonth => 'مواعيد الشهر';

  @override
  String get fullMonth => 'الشهر بالكامل';

  @override
  String get dateHijri => 'هجري';

  @override
  String get dateGregorian => 'ميلادي';

  @override
  String get quran => 'مصحف';

  @override
  String get mushafIndex => 'فهرس المصحف';

  @override
  String get mushafLoading => 'جاري تحميل المصحف…';

  @override
  String get mushafViewImages => 'عرض صور الصفحات';

  @override
  String get mushafViewText => 'عرض النص';

  @override
  String get tabSurahs => 'السور';

  @override
  String get tabJuzs => 'الأجزاء';

  @override
  String get tabLastRead => 'آخر تصفح';

  @override
  String get tabBookmarks => 'العلامات';

  @override
  String get noResults => 'لا توجد نتائج';

  @override
  String get continueReading => 'متابعة القراءة';

  @override
  String get noBookmarks => 'لا توجد علامات بعد';

  @override
  String get noLastRead => 'لا يوجد تقدم قراءة بعد';

  @override
  String get makki => 'مكي';

  @override
  String get madani => 'مدني';

  @override
  String versesCount(int count) {
    return '$count آية';
  }

  @override
  String juz(int number) {
    return 'الجزء $number';
  }

  @override
  String get searchSurahOrVerse => 'بحث سورة أو آية…';

  @override
  String pageOf(int current, int total) {
    return 'صفحة $current من $total';
  }

  @override
  String get adhkar => 'أذكار';

  @override
  String get dhikrCategoryMorning => 'أذكار الصباح';

  @override
  String get dhikrCategoryEvening => 'أذكار المساء';

  @override
  String get dhikrCategoryAfterPrayer => 'أذكار بعد الصلاة';

  @override
  String get dhikrCategorySleep => 'أذكار النوم';

  @override
  String get dhikrCategoryTawba => 'التوبة والاستغفار';

  @override
  String get dhikrDescMorning => 'أذكار تقال من طلوع الفجر إلى الزوال';

  @override
  String get dhikrDescEvening => 'أذكار تقال من العصر إلى منتصف الليل';

  @override
  String get dhikrDescAfterPrayer => 'أذكار عقب كل صلاة';

  @override
  String get dhikrDescSleep => 'أذكار قبل النوم';

  @override
  String get dhikrDescTawba => 'مئة استغفار يومياً تُكسبك الونس والمغفرة';

  @override
  String get tawbaCompletionMessage =>
      'أحسنت! مئة استغفار اليوم. اللهم اغفر لنا وتب علينا.';

  @override
  String get qibla => 'قبلة';

  @override
  String get qiblaDirection => 'اتجاه القبلة';

  @override
  String get pleaseCalibrate => 'يرجى معايرة الجهاز بحركة شكل 8.';

  @override
  String get locationDenied =>
      'تم رفض الموقع. فعّله من الإعدادات لإيجاد القبلة.';

  @override
  String get locationRequired => 'الموقع مطلوب لحساب اتجاه القبلة.';

  @override
  String get qiblaAligned => 'أنت متجه نحو القبلة';

  @override
  String get sensorsError => 'البوصلة غير متوفرة. تحقق من حساسات الجهاز.';

  @override
  String get actionTitle => 'أنا مسلم بأفعالي';

  @override
  String get actionOfDay => 'تحدي اليوم';

  @override
  String get todayChallenge =>
      'اقرأ صفحة من كتاب نافع وطبّق أمراً واحداً مما قرأت.';

  @override
  String get myDailyTasks => 'مهامي اليومية';

  @override
  String get noTasksToday => 'لا توجد مهام اليوم. أضف من القائمة.';

  @override
  String get done => 'تم';

  @override
  String get dailyTaskDailyPrayers => 'الصلوات الخمس';

  @override
  String get dailyTaskSmile => 'الابتسامة';

  @override
  String get dailyTaskGratitude => 'الامتنان والحمد';

  @override
  String get luminousPieces => 'القطع النورانية';

  @override
  String progressMsg(int count) {
    return 'في أسبوع، قمت بـ $count فعل خير';
  }

  @override
  String get prayForMe => 'ادعُ لي';

  @override
  String get prayForMeHint =>
      'مساحة لطلب الدعاء من إخوتك. شارك حاجتك أو ادعُ لمن شارك.';

  @override
  String get requestPrayer => 'اطلب الدعاء';

  @override
  String get iPrayed => 'دعوت لك';

  @override
  String get groupChallenges => 'تحديات جماعية';

  @override
  String get joinReading => 'قراءة جماعية هذا الأسبوع';

  @override
  String get joinReadingHint => 'انضم لمجموعة واقرأ معاً';

  @override
  String get dhikrChallenge => 'تحدي الأذكار';

  @override
  String get dhikrChallengeHint => 'أكمل أذكار الصباح والمساء مع الآخرين';

  @override
  String get dailyWisdom => 'مقولة اليوم';

  @override
  String get shortClips => 'مقاطع قصيرة';

  @override
  String get mihrab => 'المحراب';

  @override
  String get athari => 'أثري';

  @override
  String get majlis => 'المجلس';

  @override
  String get zad => 'زاد';

  @override
  String get history => 'التاريخ';

  @override
  String get masterTreasury => 'الصندوق الجامع';

  @override
  String get todaysDhikr => 'أذكار اليوم';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get theme => 'المظهر';

  @override
  String get themeSystem => 'حسب الجهاز';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get about => 'حول التطبيق';

  @override
  String get version => 'الإصدار';
}
