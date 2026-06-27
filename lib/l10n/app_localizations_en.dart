// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Bill Calculator';

  @override
  String get appTagline => 'Estimate your electricity bill';

  @override
  String get splashLoading => 'Loading...';

  @override
  String get signInWelcome => 'Sign in to estimate your electricity bill';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithPhone => 'Continue with Phone Number';

  @override
  String get continueWithEmail => 'Continue with Email';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get enterPhoneHint => 'Enter your phone number';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get enterOtp => 'Enter 6-digit OTP';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String resendOtpIn(int seconds) {
    return 'Resend code in ${seconds}s';
  }

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get createAccount => 'Create Account';

  @override
  String get switchToCreateAccount => 'Don\'t have an account? Create one';

  @override
  String get switchToLogin => 'Already have an account? Login';

  @override
  String get chooseLanguage => 'Choose your language';

  @override
  String get chooseLanguageUrdu => 'اپنی زبان منتخب کریں';

  @override
  String get english => 'English';

  @override
  String get urdu => 'اردو (Urdu)';

  @override
  String get continueButton => 'Continue';

  @override
  String get selectProvider => 'Select your electricity provider';

  @override
  String get selectProviderUrdu => 'اپنی بجلی کمپنی منتخب کریں';

  @override
  String get consumerCategory => 'Consumer Category';

  @override
  String get protected => 'Protected';

  @override
  String get unprotected => 'Unprotected';

  @override
  String get commercialComingSoon => 'Commercial (Coming Soon)';

  @override
  String get next => 'Next';

  @override
  String get enterUnits => 'Enter your consumed units (kWh)';

  @override
  String get enterUnitsUrdu => 'اپنی استعمال کردہ یونٹس درج کریں';

  @override
  String get unitsHelper =>
      'Find units on your previous bill or from your meter reading';

  @override
  String get calculateBill => 'Calculate Bill';

  @override
  String get calculateBillUrdu => 'بل کیلکولیٹ کریں';

  @override
  String get invalidUnits => 'Please enter a valid positive number of units';

  @override
  String get editSelection => 'Edit';

  @override
  String get estimatedBill => 'Estimated Bill';

  @override
  String get totalEstimatedBill => 'Total Estimated Bill';

  @override
  String get energyCharges => 'Energy Charges';

  @override
  String get fixedCharges => 'Fixed Charges';

  @override
  String get gst => 'Sales Tax (GST)';

  @override
  String get fpa => 'Fuel Adjustment (FPA)';

  @override
  String get electricityDuty => 'Electricity Duty';

  @override
  String get disclaimer =>
      'This is an estimate, not your official bill. Actual bill may vary due to taxes, adjustments, or billing cycle differences.';

  @override
  String ratesLastUpdated(String date) {
    return 'Rates last updated: $date';
  }

  @override
  String get ratesMayBeOutdated =>
      'Rates may not be the latest. Connect to internet to refresh.';

  @override
  String get share => 'Share';

  @override
  String get reportIssue => 'Report Issue';

  @override
  String get calculateAgain => 'Calculate Again';

  @override
  String get reportIssueTitle => 'Report an issue with this estimate';

  @override
  String get actualBillOptional =>
      'What was your actual bill amount? (optional)';

  @override
  String get sendViaWhatsapp => 'Send via WhatsApp';

  @override
  String get sendViaEmail => 'Send via Email';

  @override
  String get settings => 'Settings';

  @override
  String get home => 'Home';

  @override
  String get history => 'History';

  @override
  String get historyComingSoon => 'Bill history coming soon';

  @override
  String get account => 'Account';

  @override
  String get guestUser => 'Guest User';

  @override
  String get signIn => 'Sign In';

  @override
  String get signOut => 'Sign Out';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get aboutApp => 'About This App';

  @override
  String get aboutAppDescription =>
      'This app provides estimated electricity bills based on publicly available NEPRA tariff data. Figures are for reference only.';

  @override
  String get rateThisApp => 'Rate This App';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get feedback => 'Send Feedback';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get pkr => 'PKR';

  @override
  String get units => 'units';

  @override
  String shareBillText(
    String disco,
    String category,
    String units,
    String amount,
  ) {
    return 'Electricity Bill Estimate\nDISCO: $disco\nCategory: $category\nUnits: $units kWh\nEstimated Bill: PKR $amount\n\nDisclaimer: This is an estimate only.';
  }

  @override
  String feedbackWhatsappMessage(
    String disco,
    String category,
    String units,
    String estimated,
    String actual,
  ) {
    return 'Bill Estimate Issue Report\nDISCO: $disco\nCategory: $category\nUnits: $units\nEstimated: PKR $estimated\nActual (if provided): $actual';
  }

  @override
  String get adPlaceholder => 'Advertisement';

  @override
  String get loginSuccess => 'Welcome!';

  @override
  String get loginFailed => 'Login failed. Please try again.';

  @override
  String get otpSent => 'OTP sent to your phone';

  @override
  String get selectDiscoAndCategory => 'Please select a DISCO and category';
}
