// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appName => 'بل کیلکولیٹر';

  @override
  String get appTagline => 'اپنے بجلی بل کا تخمینہ لگائیں';

  @override
  String get splashLoading => 'لوڈ ہو رہا ہے...';

  @override
  String get signInWelcome =>
      'اپنے بجلی بل کا تخمینہ لگانے کے لیے سائن ان کریں';

  @override
  String get continueWithGoogle => 'گوگل کے ساتھ جاری رکھیں';

  @override
  String get continueWithPhone => 'فون نمبر کے ساتھ جاری رکھیں';

  @override
  String get continueWithEmail => 'ای میل کے ساتھ جاری رکھیں';

  @override
  String get continueAsGuest => 'مہمان کے طور پر جاری رکھیں';

  @override
  String get phoneNumber => 'فون نمبر';

  @override
  String get enterPhoneHint => 'اپنا فون نمبر درج کریں';

  @override
  String get sendOtp => 'OTP بھیجیں';

  @override
  String get enterOtp => '6 ہندسوں کا OTP درج کریں';

  @override
  String get verifyOtp => 'OTP کی تصدیق کریں';

  @override
  String resendOtpIn(int seconds) {
    return '$seconds سیکنڈ میں دوبارہ بھیجیں';
  }

  @override
  String get resendOtp => 'OTP دوبارہ بھیجیں';

  @override
  String get email => 'ای میل';

  @override
  String get password => 'پاس ورڈ';

  @override
  String get login => 'لاگ ان';

  @override
  String get createAccount => 'اکاؤنٹ بنائیں';

  @override
  String get switchToCreateAccount => 'اکاؤنٹ نہیں ہے؟ بنائیں';

  @override
  String get switchToLogin => 'پہلے سے اکاؤنٹ ہے؟ لاگ ان کریں';

  @override
  String get chooseLanguage => 'Choose your language';

  @override
  String get chooseLanguageUrdu => 'اپنی زبان منتخب کریں';

  @override
  String get english => 'English';

  @override
  String get urdu => 'اردو (Urdu)';

  @override
  String get continueButton => 'جاری رکھیں';

  @override
  String get selectProvider => 'اپنی بجلی کمپنی منتخب کریں';

  @override
  String get selectProviderUrdu => 'اپنی بجلی کمپنی منتخب کریں';

  @override
  String get consumerCategory => 'صارف کی قسم';

  @override
  String get protected => 'محفوظ';

  @override
  String get unprotected => 'غیر محفوظ';

  @override
  String get commercialComingSoon => 'تجارتی (جلد آ رہا ہے)';

  @override
  String get next => 'اگلا';

  @override
  String get enterUnits => 'اپنی استعمال کردہ یونٹس درج کریں (kWh)';

  @override
  String get enterUnitsUrdu => 'اپنی استعمال کردہ یونٹس درج کریں';

  @override
  String get unitsHelper => 'پچھلے بل یا میٹر ریڈنگ سے یونٹس دیکھیں';

  @override
  String get calculateBill => 'بل کیلکولیٹ کریں';

  @override
  String get calculateBillUrdu => 'بل کیلکولیٹ کریں';

  @override
  String get invalidUnits => 'براہ کرم درست مثبت یونٹس درج کریں';

  @override
  String get editSelection => 'تبدیل کریں';

  @override
  String get estimatedBill => 'تخمینی بل';

  @override
  String get totalEstimatedBill => 'کل تخمینی بل';

  @override
  String get energyCharges => 'بجلی چارجز';

  @override
  String get fixedCharges => 'فکسڈ چارجز';

  @override
  String get gst => 'سیلز ٹیکس (GST)';

  @override
  String get fpa => 'برقی ایندھن ایڈجسٹمنٹ (FPA)';

  @override
  String get electricityDuty => 'الیکٹریسٹی ڈیوٹی';

  @override
  String get disclaimer =>
      'یہ ایک تخمینہ ہے، آپ کا رسمی بل نہیں۔ حقیقی بل ٹیکس، ایڈجسٹمنٹ یا بلنگ سائیکل کی وجہ سے مختلف ہو سکتا ہے۔';

  @override
  String ratesLastUpdated(String date) {
    return 'ریٹس آخری بار اپ ڈیٹ: $date';
  }

  @override
  String get ratesMayBeOutdated =>
      'ریٹس تازہ ترین نہیں ہو سکتے۔ اپ ڈیٹ کے لیے انٹرنیٹ سے منسلک ہوں۔';

  @override
  String get share => 'شیئر کریں';

  @override
  String get reportIssue => 'مسئلہ رپورٹ کریں';

  @override
  String get calculateAgain => 'دوبارہ کیلکولیٹ کریں';

  @override
  String get reportIssueTitle => 'اس تخمینے میں مسئلہ رپورٹ کریں';

  @override
  String get actualBillOptional => 'آپ کا حقیقی بل کتنا تھا؟ (اختیاری)';

  @override
  String get sendViaWhatsapp => 'واٹس ایپ سے بھیجیں';

  @override
  String get sendViaEmail => 'ای میل سے بھیجیں';

  @override
  String get settings => 'ترتیبات';

  @override
  String get home => 'ہوم';

  @override
  String get history => 'تاریخ';

  @override
  String get historyComingSoon => 'بل کی تاریخ جلد آ رہی ہے';

  @override
  String get account => 'اکاؤنٹ';

  @override
  String get guestUser => 'مہمان صارف';

  @override
  String get signIn => 'سائن ان';

  @override
  String get signOut => 'سائن آؤٹ';

  @override
  String get language => 'زبان';

  @override
  String get theme => 'تھیم';

  @override
  String get themeLight => 'لائٹ';

  @override
  String get themeDark => 'ڈارک';

  @override
  String get themeSystem => 'سسٹم';

  @override
  String get aboutApp => 'اس ایپ کے بارے میں';

  @override
  String get aboutAppDescription =>
      'یہ ایپ NEPRA کے عوامی ٹیرف ڈیٹا پر مبنی تخمینی بجلی بل فراہم کرتی ہے۔ اعداد صرف حوالے کے لیے ہیں۔';

  @override
  String get rateThisApp => 'ایپ کو ریٹ کریں';

  @override
  String get privacyPolicy => 'رازداری کی پالیسی';

  @override
  String get feedback => 'رائے بھیجیں';

  @override
  String version(String version) {
    return 'ورژن $version';
  }

  @override
  String get pkr => 'PKR';

  @override
  String get units => 'یونٹس';

  @override
  String shareBillText(
    String disco,
    String category,
    String units,
    String amount,
  ) {
    return 'بجلی بل تخمینہ\nDISCO: $disco\nقسم: $category\nیونٹس: $units kWh\nتخمینی بل: PKR $amount\n\nنوٹ: یہ صرف تخمینہ ہے۔';
  }

  @override
  String feedbackWhatsappMessage(
    String disco,
    String category,
    String units,
    String estimated,
    String actual,
  ) {
    return 'بل تخمینہ مسئلہ رپورٹ\nDISCO: $disco\nقسم: $category\nیونٹس: $units\nتخمینہ: PKR $estimated\nحقیقی (اگر دیا): $actual';
  }

  @override
  String get adPlaceholder => 'اشتہار';

  @override
  String get loginSuccess => 'خوش آمدید!';

  @override
  String get loginFailed => 'لاگ ان ناکام۔ دوبارہ کوشش کریں۔';

  @override
  String get otpSent => 'OTP آپ کے فون پر بھیج دیا گیا';

  @override
  String get selectDiscoAndCategory => 'براہ کرم DISCO اور قسم منتخب کریں';
}
