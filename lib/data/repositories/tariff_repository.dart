import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
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
    await _cacheTariffs(json.encode(defaults.map((k, v) => MapEntry(k, v))));
    _memoryCache = defaults;
    return defaults;
  }

  Future<void> refreshTariffs() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );

      await remoteConfig.fetchAndActivate();

      final jsonStr = remoteConfig.getString('tariff_data');

      if (jsonStr.isNotEmpty) {
        final parsed = json.decode(jsonStr) as Map<String, dynamic>;
        _memoryCache = _parseTariffs(parsed);
        await _cacheTariffs(jsonStr);
        return;
      }
    } catch (e) {
      // Remote Config failed — fall back to cache or bundled defaults
    }

    // Fallback: bundled asset
    final defaults = await _loadDefaultTariffs();
    _memoryCache = defaults;
  }

  bool get isRatesStale {
    final cachedDate = _prefs.getString(_cacheDateKey);
    if (cachedDate == null) return false;
    try {
      final date = DateTime.parse(cachedDate);
      return DateTime.now().difference(date).inDays >
          AppConstants.ratesStaleDays;
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

  Future<void> _cacheTariffs(String jsonStr) async {
    await _prefs.setString(_cacheKey, jsonStr);
    await _prefs.setString(_cacheDateKey, DateTime.now().toIso8601String());
  }
}
