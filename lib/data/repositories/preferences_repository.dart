import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';

class PreferencesRepository {
  PreferencesRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _languageKey = 'language_code';
  static const _themeKey = 'theme_mode';
  static const _onboardingCompleteKey = 'onboarding_complete';
  static const _sessionKey = 'has_session';
  static const _authMethodKey = 'auth_method';
  static const _displayNameKey = 'display_name';
  static const _lastDiscoKey = 'last_disco';
  static const _lastCategoryKey = 'last_category';
  static const _calculationCountKey = 'calculation_count';

  String get languageCode => _prefs.getString(_languageKey) ?? 'en';

  Future<void> setLanguageCode(String code) =>
      _prefs.setString(_languageKey, code);

  AppThemeMode get themeMode {
    final value = _prefs.getString(_themeKey) ?? 'system';
    return AppThemeMode.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AppThemeMode.system,
    );
  }

  Future<void> setThemeMode(AppThemeMode mode) =>
      _prefs.setString(_themeKey, mode.name);

  bool get onboardingComplete => _prefs.getBool(_onboardingCompleteKey) ?? false;

  Future<void> setOnboardingComplete(bool value) =>
      _prefs.setBool(_onboardingCompleteKey, value);

  bool get hasSession => _prefs.getBool(_sessionKey) ?? false;

  Future<void> setHasSession(bool value) => _prefs.setBool(_sessionKey, value);

  AuthMethod get authMethod {
    final value = _prefs.getString(_authMethodKey);
    if (value == null) return AuthMethod.none;
    return AuthMethod.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AuthMethod.none,
    );
  }

  Future<void> setAuthMethod(AuthMethod method) =>
      _prefs.setString(_authMethodKey, method.name);

  String? get displayName => _prefs.getString(_displayNameKey);

  Future<void> setDisplayName(String? name) {
    if (name == null) return _prefs.remove(_displayNameKey);
    return _prefs.setString(_displayNameKey, name);
  }

  String? get lastDisco => _prefs.getString(_lastDiscoKey);

  Future<void> setLastDisco(String disco) =>
      _prefs.setString(_lastDiscoKey, disco);

  ConsumerCategory? get lastCategory {
    final value = _prefs.getString(_lastCategoryKey);
    if (value == null) return null;
    return value == 'protected'
        ? ConsumerCategory.protected
        : ConsumerCategory.unprotected;
  }

  Future<void> setLastCategory(ConsumerCategory category) =>
      _prefs.setString(_lastCategoryKey, category.key);

  int get calculationCount => _prefs.getInt(_calculationCountKey) ?? 0;

  Future<int> incrementCalculationCount() async {
    final next = calculationCount + 1;
    await _prefs.setInt(_calculationCountKey, next);
    return next;
  }

  Future<void> clearSession() async {
    await _prefs.remove(_sessionKey);
    await _prefs.remove(_authMethodKey);
    await _prefs.remove(_displayNameKey);
  }
}
