import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

extension LocalizedText on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  bool get isUrdu => Localizations.localeOf(this).languageCode == 'ur';

  TextStyle localizedStyle(TextStyle? base) {
    if (!isUrdu) return base ?? const TextStyle();
    return AppTheme.urduTextStyle(this, base: base);
  }
}
