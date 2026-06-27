class AppConstants {
  static const discos = [
    'LESCO',
    'PESCO',
    'IESCO',
    'MEPCO',
    'GEPCO',
    'FESCO',
    'HESCO',
    'SEPCO',
    'QESCO',
    'TESCO',
    'HAZECO',
    'K-Electric',
  ];

  static const feedbackWhatsappNumber = '923001234567';
  static const feedbackEmail = 'support@skypiontech.com';
  static const privacyPolicyUrl = 'https://skypiontech.com/privacy';
  static const playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.example.electricity_bill_calculator';

  static const ratesStaleDays = 30;
  static const interstitialEveryNthCalculation = 3;
}

enum ConsumerCategory { protected, unprotected }

enum AuthMethod { google, phone, email, guest, none }

enum AppThemeMode { light, dark, system }

enum LoginStatus { unknown, authenticated, unauthenticated }

extension ConsumerCategoryX on ConsumerCategory {
  String get key =>
      this == ConsumerCategory.protected ? 'protected' : 'unprotected';
}
