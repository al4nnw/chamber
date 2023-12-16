import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  AppLocalizations(this.locale);

  Future<bool> load() async {
    String jsonPath;
    if (locale.languageCode == 'pt' && locale.countryCode == 'BR') {
      jsonPath = 'l10n/pt.json'; // Adjust the path if needed
    } else {
      jsonPath = 'l10n/${locale.languageCode}.json';
    }

    String jsonString = await rootBundle.loadString(jsonPath);
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? "";
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}
