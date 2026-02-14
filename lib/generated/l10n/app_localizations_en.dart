// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Esteana';

  @override
  String get startJourney => 'Start My Journey';

  @override
  String get welcomeToJourney => 'Welcome to your Journey';

  @override
  String get loginGoogle => 'Login with Google';

  @override
  String get continueGuest => 'Continue as Guest';

  @override
  String get skip => 'Skip';

  @override
  String get guestSyncMessage => 'Sign in to save your progress forever.';

  @override
  String get loginRequired => 'Sign in to request prayer.';

  @override
  String get timeRemaining => 'Time remaining';

  @override
  String get dhikrComingSoon => 'Dhikr section coming soon.';

  @override
  String get qiblaComingSoon => 'Qibla finder coming soon.';

  @override
  String get share => 'Share';

  @override
  String get cancel => 'Cancel';

  @override
  String get submit => 'Submit';

  @override
  String get nextPrayer => 'Next Prayer';

  @override
  String get quickAccess => 'Quick Access';

  @override
  String get prayerTimes => 'Prayer Times';

  @override
  String get prayerTimesMonth => 'Prayer Times – Month';

  @override
  String get fullMonth => 'Full month';

  @override
  String get dateHijri => 'Hijri';

  @override
  String get dateGregorian => 'Gregorian';

  @override
  String get quran => 'Quran';

  @override
  String get mushafIndex => 'Mushaf Index';

  @override
  String get mushafLoading => 'Loading Mushaf…';

  @override
  String get mushafViewImages => 'View page images';

  @override
  String get mushafViewText => 'View text';

  @override
  String get tabSurahs => 'Surahs';

  @override
  String get tabJuzs => 'Juzs';

  @override
  String get tabLastRead => 'Last Read';

  @override
  String get tabBookmarks => 'Bookmarks';

  @override
  String get noResults => 'No results';

  @override
  String get continueReading => 'Continue reading';

  @override
  String get noBookmarks => 'No bookmarks yet';

  @override
  String get noLastRead => 'No reading progress yet';

  @override
  String get makki => 'Makki';

  @override
  String get madani => 'Madani';

  @override
  String versesCount(int count) {
    return '$count verses';
  }

  @override
  String juz(int number) {
    return 'Juz $number';
  }

  @override
  String get searchSurahOrVerse => 'Search surah or verse…';

  @override
  String pageOf(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get adhkar => 'Dhikr';

  @override
  String get dhikrCategoryMorning => 'Morning Adhkar';

  @override
  String get dhikrCategoryEvening => 'Evening Adhkar';

  @override
  String get dhikrCategoryAfterPrayer => 'Adhkar After Prayer';

  @override
  String get dhikrCategorySleep => 'Bedtime Adhkar';

  @override
  String get dhikrCategoryTawba => 'Repentance & Istighfar';

  @override
  String get dhikrDescMorning => 'Adhkar said from dawn until noon';

  @override
  String get dhikrDescEvening => 'Adhkar said from afternoon until midnight';

  @override
  String get dhikrDescAfterPrayer => 'Adhkar after each prayer';

  @override
  String get dhikrDescSleep => 'Adhkar before sleep';

  @override
  String get dhikrDescTawba =>
      'A hundred istighfar daily for comfort and forgiveness';

  @override
  String get tawbaCompletionMessage =>
      'Well done! A hundred istighfar today. O Allah, forgive us and accept our repentance.';

  @override
  String get qibla => 'Qibla';

  @override
  String get qiblaDirection => 'Qibla Direction';

  @override
  String get pleaseCalibrate =>
      'Please calibrate your device by moving it in a figure-8 pattern.';

  @override
  String get locationDenied =>
      'Location access was denied. Enable it in settings to find Qibla.';

  @override
  String get locationRequired =>
      'Location is required to calculate Qibla direction.';

  @override
  String get qiblaAligned => 'You are facing the Qibla';

  @override
  String get sensorsError =>
      'Compass unavailable. Please check device sensors.';

  @override
  String get actionTitle => 'I am a Muslim by my Actions';

  @override
  String get actionOfDay => 'Action of the Day';

  @override
  String get todayChallenge =>
      'Read a page from a beneficial book and apply one thing you read.';

  @override
  String get myDailyTasks => 'My Daily Tasks';

  @override
  String get noTasksToday => 'No tasks for today. Add from the list.';

  @override
  String get done => 'Done';

  @override
  String get dailyTaskDailyPrayers => 'Daily Prayers';

  @override
  String get dailyTaskSmile => 'Smile';

  @override
  String get dailyTaskGratitude => 'Gratitude and Praise';

  @override
  String get luminousPieces => 'Luminous Pieces';

  @override
  String progressMsg(int count) {
    return 'In a week, you\'ve done $count good deeds';
  }

  @override
  String get prayForMe => 'Pray for me';

  @override
  String get prayForMeHint =>
      'A space to request prayer from your brothers and sisters. Share your need or pray for those who shared.';

  @override
  String get requestPrayer => 'Request prayer';

  @override
  String get iPrayed => 'I prayed for you';

  @override
  String get groupChallenges => 'Group Challenges';

  @override
  String get joinReading => 'Join a reading group this week';

  @override
  String get joinReadingHint => 'Join a group and read together';

  @override
  String get dhikrChallenge => 'Dhikr Challenge';

  @override
  String get dhikrChallengeHint =>
      'Complete morning and evening adhkar with others';

  @override
  String get dailyWisdom => 'Daily Wisdom';

  @override
  String get shortClips => 'Short Clips';

  @override
  String get mihrab => 'Al-Mihrab';

  @override
  String get athari => 'Athari';

  @override
  String get majlis => 'Al-Majlis';

  @override
  String get zad => 'Zad';

  @override
  String get history => 'History';

  @override
  String get masterTreasury => 'Master Treasury';

  @override
  String get todaysDhikr => 'Today\'s Dhikr';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get build => 'Build';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get collectiveReading => 'Collective Reading';

  @override
  String get joinVideoCall => 'Join video call';

  @override
  String get startVideoCall => 'Start video call';

  @override
  String get giveControl => 'Give control';

  @override
  String get controllerLabel => 'Controller';

  @override
  String get participants => 'Participants';

  @override
  String get createRoom => 'Create reading session';

  @override
  String get joinRoom => 'Join with code';

  @override
  String get roomCode => 'Room code';

  @override
  String get youAreController => 'You are the controller';

  @override
  String get teacherLabel => 'Teacher';

  @override
  String get studentLabel => 'Student';

  @override
  String get activeReadingSessions => 'Active reading sessions';

  @override
  String get noActiveSessions => 'No active sessions at the moment';

  @override
  String get publicRoom => 'Public';

  @override
  String get privateRoom => 'Private';

  @override
  String get createOrJoin => 'Create or join with code';

  @override
  String get endReading => 'End reading';

  @override
  String get endReadingConfirm => 'End the reading session and save to log?';

  @override
  String get readingEnded => 'Reading ended and saved to log';

  @override
  String get saveAssignmentForStudent => 'Save assignment for student';

  @override
  String get selectStudent => 'Select student';

  @override
  String get assignmentSaved => 'Assignment saved';

  @override
  String get noStudentsToAssign => 'No student to assign to';

  @override
  String get myStudyTasks => 'My study tasks';

  @override
  String get myStudyTasksHint => 'Assignments from your teacher';

  @override
  String get noAssignments => 'No assignments yet';

  @override
  String get tasbih => 'Tasbih';

  @override
  String get reset => 'Reset';

  @override
  String get downloadMushafOffline => 'Download Mushaf for offline use';

  @override
  String get downloadMushafOfflineHint =>
      'About 80 MB. You can read the full Quran without internet.';

  @override
  String downloadingPage(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get downloadComplete => 'Mushaf downloaded. You can read offline.';

  @override
  String downloadPartial(int downloaded, int total) {
    return 'Downloaded $downloaded of $total pages. Some failed (no connection). Connect to the internet and try again to complete.';
  }

  @override
  String get downloadCancelled => 'Download cancelled.';

  @override
  String get mushafOffline => 'Mushaf (offline)';

  @override
  String get occasionsTitle => 'Islamic occasions';

  @override
  String daysUntilOccasion(int count) {
    return '$count days left';
  }

  @override
  String get todayIsOccasion => 'Today';

  @override
  String daysSinceOccasion(int count) {
    return 'Passed $count days ago';
  }

  @override
  String get hijriDateAdjustment => 'Hijri date adjustment';

  @override
  String get hijriDateAdjustmentHint =>
      'Add or subtract one day if official sighting differs from calculation.';

  @override
  String get hijriPlusOne => '+1 day';

  @override
  String get hijriMinusOne => '−1 day';

  @override
  String hijriOffsetValue(int value) {
    return 'Offset: $value day(s)';
  }

  @override
  String get microphonePermissionRequired =>
      'Microphone access is required for the collective reading call.';

  @override
  String get cameraPermissionRequired =>
      'Camera access is required for the collective reading call.';
}
