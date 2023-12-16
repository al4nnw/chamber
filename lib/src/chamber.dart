import 'package:flutter/material.dart';
import 'package:log_chamber/l10n/app_localizations.dart';
import 'package:log_chamber/src/chamber_config.dart';

import 'chamber_dialog.dart';

class Chamber {
  static ChamberConfig config = ChamberConfig();

  static final Map<String, List<String>> _logs = {};

  static log(String message, [String key = 'general']) {
    if (!isAuthorized()) return;

    final timestamp = DateTime.now();
    final entry = "${_formatTime(timestamp)} [$key] - $message";

    if ((_logs[key]?.length ?? 0) >= config.maxLogSize) {
      _logs[key]?.removeAt(0);
    }

    _logs.putIfAbsent(key, () => []).add(entry);
  }

  static String _formatTime(DateTime time) {
    if (config.formatTime != null) {
      return config.formatTime!(time);
    }

    final hours = "${time.hour}:${time.minute}:${time.second}.${time.millisecond}";
    final date = "${time.day}/${time.month}/${time.year}";

    return "$date $hours";
  }

  static void clear([String? key]) {
    if (!isAuthorized()) return;

    if (key != null) {
      _logs[key]?.clear();
    } else {
      _logs.clear();
    }
  }

  static List<String> get([String? key]) {
    if (!isAuthorized()) return [];

    if (key == null) {
      return _logs.entries.expand((entry) => entry.value).toList();
    }

    return _logs[key] ?? [];
  }

  static Future<void> display(BuildContext context, [String? key]) async {
    if (!isAuthorized()) return;
    AppLocalizations localizations = AppLocalizations.of(context);

    await localizations.load();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChamberDialog(
          localizations: localizations,
          logKey: key,
        );
      },
    );
  }

  static bool isAuthorized() {
    return config.isUserAuthorized;
  }
}
