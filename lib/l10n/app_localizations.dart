import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

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
    Locale('en'),
    Locale('ur'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Bill Calculator'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Estimate your electricity bill'**
  String get appTagline;

  /// No description provided for @splashLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get splashLoading;

  /// No description provided for @signInWelcome.
  ///
  /// In en, this message translates to:
  /// **'Sign in to estimate your electricity bill'**
  String get signInWelcome;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithPhone.
  ///
  /// In en, this message translates to:
  /// **'Continue with Phone Number'**
  String get continueWithPhone;

  /// No description provided for @continueWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with Email'**
  String get continueWithEmail;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @enterPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneHint;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit OTP'**
  String get enterOtp;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @resendOtpIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}s'**
  String resendOtpIn(int seconds);

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @switchToCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Create one'**
  String get switchToCreateAccount;

  /// No description provided for @switchToLogin.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get switchToLogin;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseLanguage;

  /// No description provided for @chooseLanguageUrdu.
  ///
  /// In en, this message translates to:
  /// **'اپنی زبان منتخب کریں'**
  String get chooseLanguageUrdu;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @urdu.
  ///
  /// In en, this message translates to:
  /// **'اردو (Urdu)'**
  String get urdu;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @selectProvider.
  ///
  /// In en, this message translates to:
  /// **'Select your electricity provider'**
  String get selectProvider;

  /// No description provided for @selectProviderUrdu.
  ///
  /// In en, this message translates to:
  /// **'اپنی بجلی کمپنی منتخب کریں'**
  String get selectProviderUrdu;

  /// No description provided for @consumerCategory.
  ///
  /// In en, this message translates to:
  /// **'Consumer Category'**
  String get consumerCategory;

  /// No description provided for @protected.
  ///
  /// In en, this message translates to:
  /// **'Protected'**
  String get protected;

  /// No description provided for @unprotected.
  ///
  /// In en, this message translates to:
  /// **'Unprotected'**
  String get unprotected;

  /// No description provided for @commercialComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Commercial (Coming Soon)'**
  String get commercialComingSoon;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @enterUnits.
  ///
  /// In en, this message translates to:
  /// **'Enter your consumed units (kWh)'**
  String get enterUnits;

  /// No description provided for @enterUnitsUrdu.
  ///
  /// In en, this message translates to:
  /// **'اپنی استعمال کردہ یونٹس درج کریں'**
  String get enterUnitsUrdu;

  /// No description provided for @unitsHelper.
  ///
  /// In en, this message translates to:
  /// **'Find units on your previous bill or from your meter reading'**
  String get unitsHelper;

  /// No description provided for @calculateBill.
  ///
  /// In en, this message translates to:
  /// **'Calculate Bill'**
  String get calculateBill;

  /// No description provided for @calculateBillUrdu.
  ///
  /// In en, this message translates to:
  /// **'بل کیلکولیٹ کریں'**
  String get calculateBillUrdu;

  /// No description provided for @invalidUnits.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid positive number of units'**
  String get invalidUnits;

  /// No description provided for @editSelection.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editSelection;

  /// No description provided for @estimatedBill.
  ///
  /// In en, this message translates to:
  /// **'Estimated Bill'**
  String get estimatedBill;

  /// No description provided for @totalEstimatedBill.
  ///
  /// In en, this message translates to:
  /// **'Total Estimated Bill'**
  String get totalEstimatedBill;

  /// No description provided for @energyCharges.
  ///
  /// In en, this message translates to:
  /// **'Energy Charges'**
  String get energyCharges;

  /// No description provided for @fixedCharges.
  ///
  /// In en, this message translates to:
  /// **'Fixed Charges'**
  String get fixedCharges;

  /// No description provided for @gst.
  ///
  /// In en, this message translates to:
  /// **'Sales Tax (GST)'**
  String get gst;

  /// No description provided for @fpa.
  ///
  /// In en, this message translates to:
  /// **'Fuel Adjustment (FPA)'**
  String get fpa;

  /// No description provided for @electricityDuty.
  ///
  /// In en, this message translates to:
  /// **'Electricity Duty'**
  String get electricityDuty;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'This is an estimate, not your official bill. Actual bill may vary due to taxes, adjustments, or billing cycle differences.'**
  String get disclaimer;

  /// No description provided for @ratesLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Rates last updated: {date}'**
  String ratesLastUpdated(String date);

  /// No description provided for @ratesMayBeOutdated.
  ///
  /// In en, this message translates to:
  /// **'Rates may not be the latest. Connect to internet to refresh.'**
  String get ratesMayBeOutdated;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @reportIssue.
  ///
  /// In en, this message translates to:
  /// **'Report Issue'**
  String get reportIssue;

  /// No description provided for @calculateAgain.
  ///
  /// In en, this message translates to:
  /// **'Calculate Again'**
  String get calculateAgain;

  /// No description provided for @reportIssueTitle.
  ///
  /// In en, this message translates to:
  /// **'Report an issue with this estimate'**
  String get reportIssueTitle;

  /// No description provided for @actualBillOptional.
  ///
  /// In en, this message translates to:
  /// **'What was your actual bill amount? (optional)'**
  String get actualBillOptional;

  /// No description provided for @sendViaWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Send via WhatsApp'**
  String get sendViaWhatsapp;

  /// No description provided for @sendViaEmail.
  ///
  /// In en, this message translates to:
  /// **'Send via Email'**
  String get sendViaEmail;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @historyComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Bill history coming soon'**
  String get historyComingSoon;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @guestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guestUser;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

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

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About This App'**
  String get aboutApp;

  /// No description provided for @aboutAppDescription.
  ///
  /// In en, this message translates to:
  /// **'This app provides estimated electricity bills based on publicly available NEPRA tariff data. Figures are for reference only.'**
  String get aboutAppDescription;

  /// No description provided for @rateThisApp.
  ///
  /// In en, this message translates to:
  /// **'Rate This App'**
  String get rateThisApp;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get feedback;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// No description provided for @pkr.
  ///
  /// In en, this message translates to:
  /// **'PKR'**
  String get pkr;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'units'**
  String get units;

  /// No description provided for @shareBillText.
  ///
  /// In en, this message translates to:
  /// **'Electricity Bill Estimate\nDISCO: {disco}\nCategory: {category}\nUnits: {units} kWh\nEstimated Bill: PKR {amount}\n\nDisclaimer: This is an estimate only.'**
  String shareBillText(
    String disco,
    String category,
    String units,
    String amount,
  );

  /// No description provided for @feedbackWhatsappMessage.
  ///
  /// In en, this message translates to:
  /// **'Bill Estimate Issue Report\nDISCO: {disco}\nCategory: {category}\nUnits: {units}\nEstimated: PKR {estimated}\nActual (if provided): {actual}'**
  String feedbackWhatsappMessage(
    String disco,
    String category,
    String units,
    String estimated,
    String actual,
  );

  /// No description provided for @adPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Advertisement'**
  String get adPlaceholder;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get loginSuccess;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get loginFailed;

  /// No description provided for @otpSent.
  ///
  /// In en, this message translates to:
  /// **'OTP sent to your phone'**
  String get otpSent;

  /// No description provided for @selectDiscoAndCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a DISCO and category'**
  String get selectDiscoAndCategory;
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
      <String>['en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
