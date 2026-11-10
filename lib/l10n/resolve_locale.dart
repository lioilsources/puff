import 'package:flutter/widgets.dart';

/// Picks the best supported locale for the system locales, falling back to English
/// (Flutter would otherwise fall back to the first supported locale alphabetically).
Locale resolveLocale(List<Locale>? locales, Iterable<Locale> supported) {
  final wanted = [
    for (final l in locales ?? const <Locale>[])
      if (l.languageCode == 'no')
        Locale.fromSubtags(languageCode: 'nb', scriptCode: l.scriptCode, countryCode: l.countryCode)
      else
        l,
  ];
  final r = basicLocaleListResolution(wanted, supported);
  return wanted.any((l) => l.languageCode == r.languageCode) ? r : const Locale('en');
}
