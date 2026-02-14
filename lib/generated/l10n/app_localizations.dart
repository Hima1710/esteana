import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Esteana'**
  String get appTitle;

  /// No description provided for @startJourney.
  ///
  /// In en, this message translates to:
  /// **'Start My Journey'**
  String get startJourney;

  /// No description provided for @welcomeToJourney.
  ///
  /// In en, this message translates to:
  /// **'Welcome to your Journey'**
  String get welcomeToJourney;

  /// No description provided for @loginGoogle.
  ///
  /// In en, this message translates to:
  /// **'Login with Google'**
  String get loginGoogle;

  /// No description provided for @continueGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueGuest;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @guestSyncMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to save your progress forever.'**
  String get guestSyncMessage;

  /// No description provided for @loginRequired.
  ///
  /// In en, this message translates to:
  /// **'Sign in to request prayer.'**
  String get loginRequired;

  /// No description provided for @timeRemaining.
  ///
  /// In en, this message translates to:
  /// **'Time remaining'**
  String get timeRemaining;

  /// No description provided for @dhikrComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Dhikr section coming soon.'**
  String get dhikrComingSoon;

  /// No description provided for @qiblaComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Qibla finder coming soon.'**
  String get qiblaComingSoon;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @nextPrayer.
  ///
  /// In en, this message translates to:
  /// **'Next Prayer'**
  String get nextPrayer;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// No description provided for @prayerTimes.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get prayerTimes;

  /// No description provided for @prayerTimesMonth.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times – Month'**
  String get prayerTimesMonth;

  /// No description provided for @fullMonth.
  ///
  /// In en, this message translates to:
  /// **'Full month'**
  String get fullMonth;

  /// No description provided for @dateHijri.
  ///
  /// In en, this message translates to:
  /// **'Hijri'**
  String get dateHijri;

  /// No description provided for @dateGregorian.
  ///
  /// In en, this message translates to:
  /// **'Gregorian'**
  String get dateGregorian;

  /// No description provided for @quran.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get quran;

  /// No description provided for @mushafIndex.
  ///
  /// In en, this message translates to:
  /// **'Mushaf Index'**
  String get mushafIndex;

  /// No description provided for @mushafLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading Mushaf…'**
  String get mushafLoading;

  /// No description provided for @mushafViewImages.
  ///
  /// In en, this message translates to:
  /// **'View page images'**
  String get mushafViewImages;

  /// No description provided for @mushafViewText.
  ///
  /// In en, this message translates to:
  /// **'View text'**
  String get mushafViewText;

  /// No description provided for @tabSurahs.
  ///
  /// In en, this message translates to:
  /// **'Surahs'**
  String get tabSurahs;

  /// No description provided for @tabJuzs.
  ///
  /// In en, this message translates to:
  /// **'Juzs'**
  String get tabJuzs;

  /// No description provided for @tabLastRead.
  ///
  /// In en, this message translates to:
  /// **'Last Read'**
  String get tabLastRead;

  /// No description provided for @tabBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get tabBookmarks;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// No description provided for @continueReading.
  ///
  /// In en, this message translates to:
  /// **'Continue reading'**
  String get continueReading;

  /// No description provided for @noBookmarks.
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet'**
  String get noBookmarks;

  /// No description provided for @noLastRead.
  ///
  /// In en, this message translates to:
  /// **'No reading progress yet'**
  String get noLastRead;

  /// No description provided for @makki.
  ///
  /// In en, this message translates to:
  /// **'Makki'**
  String get makki;

  /// No description provided for @madani.
  ///
  /// In en, this message translates to:
  /// **'Madani'**
  String get madani;

  /// No description provided for @versesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} verses'**
  String versesCount(int count);

  /// No description provided for @juz.
  ///
  /// In en, this message translates to:
  /// **'Juz {number}'**
  String juz(int number);

  /// No description provided for @searchSurahOrVerse.
  ///
  /// In en, this message translates to:
  /// **'Search surah or verse…'**
  String get searchSurahOrVerse;

  /// No description provided for @pageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String pageOf(int current, int total);

  /// No description provided for @adhkar.
  ///
  /// In en, this message translates to:
  /// **'Dhikr'**
  String get adhkar;

  /// No description provided for @dhikrCategoryMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning Adhkar'**
  String get dhikrCategoryMorning;

  /// No description provided for @dhikrCategoryEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening Adhkar'**
  String get dhikrCategoryEvening;

  /// No description provided for @dhikrCategoryAfterPrayer.
  ///
  /// In en, this message translates to:
  /// **'Adhkar After Prayer'**
  String get dhikrCategoryAfterPrayer;

  /// No description provided for @dhikrCategorySleep.
  ///
  /// In en, this message translates to:
  /// **'Bedtime Adhkar'**
  String get dhikrCategorySleep;

  /// No description provided for @dhikrCategoryTawba.
  ///
  /// In en, this message translates to:
  /// **'Repentance & Istighfar'**
  String get dhikrCategoryTawba;

  /// No description provided for @dhikrDescMorning.
  ///
  /// In en, this message translates to:
  /// **'Adhkar said from dawn until noon'**
  String get dhikrDescMorning;

  /// No description provided for @dhikrDescEvening.
  ///
  /// In en, this message translates to:
  /// **'Adhkar said from afternoon until midnight'**
  String get dhikrDescEvening;

  /// No description provided for @dhikrDescAfterPrayer.
  ///
  /// In en, this message translates to:
  /// **'Adhkar after each prayer'**
  String get dhikrDescAfterPrayer;

  /// No description provided for @dhikrDescSleep.
  ///
  /// In en, this message translates to:
  /// **'Adhkar before sleep'**
  String get dhikrDescSleep;

  /// No description provided for @dhikrDescTawba.
  ///
  /// In en, this message translates to:
  /// **'A hundred istighfar daily for comfort and forgiveness'**
  String get dhikrDescTawba;

  /// No description provided for @tawbaCompletionMessage.
  ///
  /// In en, this message translates to:
  /// **'Well done! A hundred istighfar today. O Allah, forgive us and accept our repentance.'**
  String get tawbaCompletionMessage;

  /// No description provided for @qibla.
  ///
  /// In en, this message translates to:
  /// **'Qibla'**
  String get qibla;

  /// No description provided for @qiblaDirection.
  ///
  /// In en, this message translates to:
  /// **'Qibla Direction'**
  String get qiblaDirection;

  /// No description provided for @pleaseCalibrate.
  ///
  /// In en, this message translates to:
  /// **'Please calibrate your device by moving it in a figure-8 pattern.'**
  String get pleaseCalibrate;

  /// No description provided for @locationDenied.
  ///
  /// In en, this message translates to:
  /// **'Location access was denied. Enable it in settings to find Qibla.'**
  String get locationDenied;

  /// No description provided for @locationRequired.
  ///
  /// In en, this message translates to:
  /// **'Location is required to calculate Qibla direction.'**
  String get locationRequired;

  /// No description provided for @qiblaAligned.
  ///
  /// In en, this message translates to:
  /// **'You are facing the Qibla'**
  String get qiblaAligned;

  /// No description provided for @sensorsError.
  ///
  /// In en, this message translates to:
  /// **'Compass unavailable. Please check device sensors.'**
  String get sensorsError;

  /// No description provided for @actionTitle.
  ///
  /// In en, this message translates to:
  /// **'I am a Muslim by my Actions'**
  String get actionTitle;

  /// No description provided for @actionOfDay.
  ///
  /// In en, this message translates to:
  /// **'Action of the Day'**
  String get actionOfDay;

  /// No description provided for @todayChallenge.
  ///
  /// In en, this message translates to:
  /// **'Read a page from a beneficial book and apply one thing you read.'**
  String get todayChallenge;

  /// No description provided for @myDailyTasks.
  ///
  /// In en, this message translates to:
  /// **'My Daily Tasks'**
  String get myDailyTasks;

  /// No description provided for @noTasksToday.
  ///
  /// In en, this message translates to:
  /// **'No tasks for today. Add from the list.'**
  String get noTasksToday;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @dailyTaskDailyPrayers.
  ///
  /// In en, this message translates to:
  /// **'Daily Prayers'**
  String get dailyTaskDailyPrayers;

  /// No description provided for @dailyTaskSmile.
  ///
  /// In en, this message translates to:
  /// **'Smile'**
  String get dailyTaskSmile;

  /// No description provided for @dailyTaskGratitude.
  ///
  /// In en, this message translates to:
  /// **'Gratitude and Praise'**
  String get dailyTaskGratitude;

  /// No description provided for @luminousPieces.
  ///
  /// In en, this message translates to:
  /// **'Luminous Pieces'**
  String get luminousPieces;

  /// No description provided for @progressMsg.
  ///
  /// In en, this message translates to:
  /// **'In a week, you\'ve done {count} good deeds'**
  String progressMsg(int count);

  /// No description provided for @prayForMe.
  ///
  /// In en, this message translates to:
  /// **'Pray for me'**
  String get prayForMe;

  /// No description provided for @prayForMeHint.
  ///
  /// In en, this message translates to:
  /// **'A space to request prayer from your brothers and sisters. Share your need or pray for those who shared.'**
  String get prayForMeHint;

  /// No description provided for @requestPrayer.
  ///
  /// In en, this message translates to:
  /// **'Request prayer'**
  String get requestPrayer;

  /// No description provided for @iPrayed.
  ///
  /// In en, this message translates to:
  /// **'I prayed for you'**
  String get iPrayed;

  /// No description provided for @groupChallenges.
  ///
  /// In en, this message translates to:
  /// **'Group Challenges'**
  String get groupChallenges;

  /// No description provided for @joinReading.
  ///
  /// In en, this message translates to:
  /// **'Join a reading group this week'**
  String get joinReading;

  /// No description provided for @joinReadingHint.
  ///
  /// In en, this message translates to:
  /// **'Join a group and read together'**
  String get joinReadingHint;

  /// No description provided for @dhikrChallenge.
  ///
  /// In en, this message translates to:
  /// **'Dhikr Challenge'**
  String get dhikrChallenge;

  /// No description provided for @dhikrChallengeHint.
  ///
  /// In en, this message translates to:
  /// **'Complete morning and evening adhkar with others'**
  String get dhikrChallengeHint;

  /// No description provided for @dailyWisdom.
  ///
  /// In en, this message translates to:
  /// **'Daily Wisdom'**
  String get dailyWisdom;

  /// No description provided for @shortClips.
  ///
  /// In en, this message translates to:
  /// **'Short Clips'**
  String get shortClips;

  /// No description provided for @mihrab.
  ///
  /// In en, this message translates to:
  /// **'Al-Mihrab'**
  String get mihrab;

  /// No description provided for @athari.
  ///
  /// In en, this message translates to:
  /// **'Athari'**
  String get athari;

  /// No description provided for @majlis.
  ///
  /// In en, this message translates to:
  /// **'Al-Majlis'**
  String get majlis;

  /// No description provided for @zad.
  ///
  /// In en, this message translates to:
  /// **'Zad'**
  String get zad;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @masterTreasury.
  ///
  /// In en, this message translates to:
  /// **'Master Treasury'**
  String get masterTreasury;

  /// No description provided for @todaysDhikr.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Dhikr'**
  String get todaysDhikr;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @build.
  ///
  /// In en, this message translates to:
  /// **'Build'**
  String get build;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @collectiveReading.
  ///
  /// In en, this message translates to:
  /// **'Collective Reading'**
  String get collectiveReading;

  /// No description provided for @joinVideoCall.
  ///
  /// In en, this message translates to:
  /// **'Join video call'**
  String get joinVideoCall;

  /// No description provided for @startVideoCall.
  ///
  /// In en, this message translates to:
  /// **'Start video call'**
  String get startVideoCall;

  /// No description provided for @giveControl.
  ///
  /// In en, this message translates to:
  /// **'Give control'**
  String get giveControl;

  /// No description provided for @controllerLabel.
  ///
  /// In en, this message translates to:
  /// **'Controller'**
  String get controllerLabel;

  /// No description provided for @participants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participants;

  /// No description provided for @createRoom.
  ///
  /// In en, this message translates to:
  /// **'Create reading session'**
  String get createRoom;

  /// No description provided for @joinRoom.
  ///
  /// In en, this message translates to:
  /// **'Join with code'**
  String get joinRoom;

  /// No description provided for @roomCode.
  ///
  /// In en, this message translates to:
  /// **'Room code'**
  String get roomCode;

  /// No description provided for @youAreController.
  ///
  /// In en, this message translates to:
  /// **'You are the controller'**
  String get youAreController;

  /// No description provided for @teacherLabel.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get teacherLabel;

  /// No description provided for @studentLabel.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get studentLabel;

  /// No description provided for @activeReadingSessions.
  ///
  /// In en, this message translates to:
  /// **'Active reading sessions'**
  String get activeReadingSessions;

  /// No description provided for @noActiveSessions.
  ///
  /// In en, this message translates to:
  /// **'No active sessions at the moment'**
  String get noActiveSessions;

  /// No description provided for @publicRoom.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get publicRoom;

  /// No description provided for @privateRoom.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get privateRoom;

  /// No description provided for @createOrJoin.
  ///
  /// In en, this message translates to:
  /// **'Create or join with code'**
  String get createOrJoin;

  /// No description provided for @endReading.
  ///
  /// In en, this message translates to:
  /// **'End reading'**
  String get endReading;

  /// No description provided for @endReadingConfirm.
  ///
  /// In en, this message translates to:
  /// **'End the reading session and save to log?'**
  String get endReadingConfirm;

  /// No description provided for @readingEnded.
  ///
  /// In en, this message translates to:
  /// **'Reading ended and saved to log'**
  String get readingEnded;

  /// No description provided for @saveAssignmentForStudent.
  ///
  /// In en, this message translates to:
  /// **'Save assignment for student'**
  String get saveAssignmentForStudent;

  /// No description provided for @selectStudent.
  ///
  /// In en, this message translates to:
  /// **'Select student'**
  String get selectStudent;

  /// No description provided for @assignmentSaved.
  ///
  /// In en, this message translates to:
  /// **'Assignment saved'**
  String get assignmentSaved;

  /// No description provided for @noStudentsToAssign.
  ///
  /// In en, this message translates to:
  /// **'No student to assign to'**
  String get noStudentsToAssign;

  /// No description provided for @myStudyTasks.
  ///
  /// In en, this message translates to:
  /// **'My study tasks'**
  String get myStudyTasks;

  /// No description provided for @myStudyTasksHint.
  ///
  /// In en, this message translates to:
  /// **'Assignments from your teacher'**
  String get myStudyTasksHint;

  /// No description provided for @noAssignments.
  ///
  /// In en, this message translates to:
  /// **'No assignments yet'**
  String get noAssignments;

  /// No description provided for @tasbih.
  ///
  /// In en, this message translates to:
  /// **'Tasbih'**
  String get tasbih;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @downloadMushafOffline.
  ///
  /// In en, this message translates to:
  /// **'Download Mushaf for offline use'**
  String get downloadMushafOffline;

  /// No description provided for @downloadMushafOfflineHint.
  ///
  /// In en, this message translates to:
  /// **'About 80 MB. You can read the full Quran without internet.'**
  String get downloadMushafOfflineHint;

  /// No description provided for @downloadingPage.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String downloadingPage(int current, int total);

  /// No description provided for @downloadComplete.
  ///
  /// In en, this message translates to:
  /// **'Mushaf downloaded. You can read offline.'**
  String get downloadComplete;

  /// No description provided for @downloadPartial.
  ///
  /// In en, this message translates to:
  /// **'Downloaded {downloaded} of {total} pages. Some failed (no connection). Connect to the internet and try again to complete.'**
  String downloadPartial(int downloaded, int total);

  /// No description provided for @downloadCancelled.
  ///
  /// In en, this message translates to:
  /// **'Download cancelled.'**
  String get downloadCancelled;

  /// No description provided for @mushafOffline.
  ///
  /// In en, this message translates to:
  /// **'Mushaf (offline)'**
  String get mushafOffline;

  /// No description provided for @occasionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Islamic occasions'**
  String get occasionsTitle;

  /// No description provided for @daysUntilOccasion.
  ///
  /// In en, this message translates to:
  /// **'{count} days left'**
  String daysUntilOccasion(int count);

  /// No description provided for @todayIsOccasion.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayIsOccasion;

  /// No description provided for @daysSinceOccasion.
  ///
  /// In en, this message translates to:
  /// **'Passed {count} days ago'**
  String daysSinceOccasion(int count);

  /// No description provided for @hijriDateAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Hijri date adjustment'**
  String get hijriDateAdjustment;

  /// No description provided for @hijriDateAdjustmentHint.
  ///
  /// In en, this message translates to:
  /// **'Add or subtract one day if official sighting differs from calculation.'**
  String get hijriDateAdjustmentHint;

  /// No description provided for @hijriPlusOne.
  ///
  /// In en, this message translates to:
  /// **'+1 day'**
  String get hijriPlusOne;

  /// No description provided for @hijriMinusOne.
  ///
  /// In en, this message translates to:
  /// **'−1 day'**
  String get hijriMinusOne;

  /// No description provided for @hijriOffsetValue.
  ///
  /// In en, this message translates to:
  /// **'Offset: {value} day(s)'**
  String hijriOffsetValue(int value);

  /// No description provided for @microphonePermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Microphone access is required for the collective reading call.'**
  String get microphonePermissionRequired;

  /// No description provided for @cameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera access is required for the collective reading call.'**
  String get cameraPermissionRequired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
