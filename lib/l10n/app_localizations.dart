import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  Map<String, String>? _localizedStrings;

  AppLocalizations(this.locale);

  // Helper method to load the JSON file from the assets
  Future<String> _loadJsonFromAssets(String path) async {
    try {
      return await rootBundle.loadString(path);
    } catch (e) {
      // If an exception occurs, log the error and return a default empty JSON object
      debugPrint('Could not load the json file: $e');
      return '{}'; // Return an empty JSON object to prevent further exceptions
    }
  }

  Future<bool> load() async {
    String jsonPath = 'assets/l10n/${locale.languageCode}.json';
    if (locale.languageCode == 'pt' && locale.countryCode == 'BR') {
      jsonPath = 'assets/l10n/pt_BR.json'; // Adjust the path if needed
    }

    // Use the helper method to load the JSON file safely
    String jsonString = await _loadJsonFromAssets(jsonPath);
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    // Convert the dynamic values to String
    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
    return true;
  }

  String translate(String key) {
    return _localizedStrings?[key] ?? "";
  }

  static AppLocalizations of(BuildContext context) {
    // Attempt to get the instance of AppLocalizations
    AppLocalizations? appLocale = Localizations.of<AppLocalizations>(context, AppLocalizations);

    // Return the found instance or a default instance for 'en_US' if none is found
    return appLocale ?? AppLocalizations(Locale('en', 'US'));
  }
}
