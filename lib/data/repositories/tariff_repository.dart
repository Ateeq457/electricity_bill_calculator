import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../models/tariff_model.dart';

class TariffRepository {
  TariffRepository(this._prefs);

  final SharedPreferences _prefs;
  static const _cacheKey = 'cached_tariffs_json';
  static const _cacheDateKey = 'cached_tariffs_date';

  Map<String, DiscoTariff>? _memoryCache;

  Future<Map<String, DiscoTariff>> loadTariffs() async {
    if (_memoryCache != null) return _memoryCache!;

    final cached = _prefs.getString(_cacheKey);
    if (cached != null) {
      _memoryCache = _parseTariffs(json.decode(cached) as Map<String, dynamic>);
      return _memoryCache!;
    }

    final defaults = await _loadDefaultTariffs();
    await _cacheTariffs(defaults);
    _memoryCache = defaults;
    return defaults;
  }

  Future<void> refreshTariffs() async {
    // Firebase Remote Config integration point — uses bundled defaults for now.
    final defaults = await _loadDefaultTariffs();
    await _cacheTariffs(defaults);
    _memoryCache = defaults;
  }

  bool get isRatesStale {
    final cachedDate = _prefs.getString(_cacheDateKey);
    if (cachedDate == null) return false;
    try {
      final date = DateTime.parse(cachedDate);
      return DateTime.now().difference(date).inDays > AppConstants.ratesStaleDays;
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, DiscoTariff>> _loadDefaultTariffs() async {
    final raw = await rootBundle.loadString('assets/data/default_tariffs.json');
    return _parseTariffs(json.decode(raw) as Map<String, dynamic>);
  }

  Map<String, DiscoTariff> _parseTariffs(Map<String, dynamic> json) {
    return json.map(
      (key, value) => MapEntry(
        key,
        DiscoTariff.fromJson(key, value as Map<String, dynamic>),
      ),
    );
  }

  Future<void> _cacheTariffs(Map<String, DiscoTariff> tariffs) async {
    final raw = await rootBundle.loadString('assets/data/default_tariffs.json');
    await _prefs.setString(_cacheKey, raw);
    await _prefs.setString(_cacheDateKey, DateTime.now().toIso8601String());
  }
}
