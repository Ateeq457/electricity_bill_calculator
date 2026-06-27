import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../data/models/tariff_model.dart';
import '../../data/repositories/preferences_repository.dart';
import '../../data/repositories/tariff_repository.dart';
import '../../data/services/bill_calculator_service.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main()');
});

final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  return PreferencesRepository(ref.watch(sharedPreferencesProvider));
});

final tariffRepositoryProvider = Provider<TariffRepository>((ref) {
  return TariffRepository(ref.watch(sharedPreferencesProvider));
});

final billCalculatorProvider = Provider<BillCalculatorService>((ref) {
  return BillCalculatorService();
});

final tariffsProvider = FutureProvider<Map<String, DiscoTariff>>((ref) async {
  final repo = ref.watch(tariffRepositoryProvider);
  await repo.refreshTariffs();
  return repo.loadTariffs();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(this._prefs) : super(Locale(_prefs.languageCode));

  final PreferencesRepository _prefs;

  Future<void> setLocale(String languageCode) async {
    await _prefs.setLanguageCode(languageCode);
    state = Locale(languageCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier(ref.watch(preferencesRepositoryProvider));
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._prefs) : super(_initialMode(_prefs.themeMode));

  final PreferencesRepository _prefs;

  static ThemeMode _initialMode(AppThemeMode mode) {
    return switch (mode) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.system => ThemeMode.system,
    };
  }

  Future<void> setAppThemeMode(AppThemeMode mode) async {
    await _prefs.setThemeMode(mode);
    state = _initialMode(mode);
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  return ThemeModeNotifier(ref.watch(preferencesRepositoryProvider));
});

class BillSession {
  const BillSession({this.disco, this.category, this.units, this.result});

  final String? disco;
  final ConsumerCategory? category;
  final int? units;
  final BillBreakdown? result;

  BillSession copyWith({
    String? disco,
    ConsumerCategory? category,
    int? units,
    BillBreakdown? result,
  }) {
    return BillSession(
      disco: disco ?? this.disco,
      category: category ?? this.category,
      units: units ?? this.units,
      result: result ?? this.result,
    );
  }
}

class BillSessionNotifier extends StateNotifier<BillSession> {
  BillSessionNotifier(this._prefs, this._calculator, this._tariffRepo)
    : super(const BillSession()) {
    _restore();
  }

  final PreferencesRepository _prefs;
  final BillCalculatorService _calculator;
  final TariffRepository _tariffRepo;

  void _restore() {
    state = BillSession(disco: _prefs.lastDisco, category: _prefs.lastCategory);
  }

  Future<void> setSelection({
    required String disco,
    required ConsumerCategory category,
  }) async {
    await _prefs.setLastDisco(disco);
    await _prefs.setLastCategory(category);
    state = state.copyWith(disco: disco, category: category);
  }

  Future<BillBreakdown?> calculate(int units) async {
    final disco = state.disco;
    final category = state.category;
    if (disco == null || category == null) return null;

    final tariffs = await _tariffRepo.loadTariffs();
    final tariff = tariffs[disco];
    if (tariff == null) return null;

    final result = _calculator.calculate(
      tariff: tariff,
      category: category,
      units: units,
      ratesStale: _tariffRepo.isRatesStale,
    );

    state = state.copyWith(units: units, result: result);
    await _prefs.incrementCalculationCount();
    return result;
  }
}

final billSessionProvider =
    StateNotifierProvider<BillSessionNotifier, BillSession>((ref) {
      return BillSessionNotifier(
        ref.watch(preferencesRepositoryProvider),
        ref.watch(billCalculatorProvider),
        ref.watch(tariffRepositoryProvider),
      );
    });

// ─── AUTH ───────────────────────────────────────────────────────────────────

class AuthState {
  const AuthState({
    required this.isAuthenticated,
    required this.method,
    this.displayName,
  });

  final bool isAuthenticated;
  final AuthMethod method;
  final String? displayName;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._prefs)
    : super(
        AuthState(
          isAuthenticated: FirebaseAuth.instance.currentUser != null,
          method: _prefs.authMethod,
          displayName:
              FirebaseAuth.instance.currentUser?.displayName ??
              _prefs.displayName,
        ),
      );

  final PreferencesRepository _prefs;

  Future<void> signIn({required AuthMethod method, String? displayName}) async {
    await _prefs.setHasSession(true);
    await _prefs.setAuthMethod(method);
    await _prefs.setDisplayName(displayName);
    state = AuthState(
      isAuthenticated: true,
      method: method,
      displayName: displayName,
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await _prefs.clearSession();
    state = const AuthState(isAuthenticated: false, method: AuthMethod.none);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(preferencesRepositoryProvider));
});

final calculationCountProvider = Provider<int>((ref) {
  return ref.watch(preferencesRepositoryProvider).calculationCount;
});

final onboardingCompleteProvider = Provider<bool>((ref) {
  return ref.watch(preferencesRepositoryProvider).onboardingComplete;
});

final appInitializationProvider = FutureProvider<void>((ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 1200));
  await ref.read(tariffsProvider.future);
});
