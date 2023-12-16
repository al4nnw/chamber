import 'package:flutter/material.dart';
import 'package:log_chamber/l10n/app_localizations.dart';
import 'package:log_chamber/src/chamber_config.dart';

import 'chamber_dialog.dart';

/// `Chamber` is a utility class for managing logs within an application.
/// It provides functionalities to log messages with different keys, clear logs,
/// retrieve logs, and display logs in a dialog.
class Chamber {
  /// Configuration settings for the Chamber.
  static ChamberConfig config = ChamberConfig();

  /// A map holding the logs. Each key represents a log category and
  /// is associated with a list of log entries.
  static final Map<String, List<String>> _logs = {};

  /// Logs a message under a specified key.
  ///
  /// The message is timestamped and formatted before being added to the logs.
  /// If the size of the log for the given key exceeds [config.maxLogSize],
  /// the oldest log entry is removed.
  ///
  /// [message] is the log message to be added.
  /// [key] is an optional parameter, defaulting to 'general', used to categorize the log.
  static log(String message, [String key = 'general']) {
    if (!isAuthorized()) return;

    final timestamp = DateTime.now();
    final entry = "${_formatTime(timestamp)} [$key] - $message";

    if ((_logs[key]?.length ?? 0) >= config.maxLogSize) {
      _logs[key]?.removeAt(0);
    }

    _logs.putIfAbsent(key, () => []).add(entry);
  }

  /// Formats the time of a log entry.
  ///
  /// This method formats the provided [time] based on the [config.formatTime] function.
  /// If no custom format function is provided, it defaults to a standard format of "day/month/year hour:minute:second.millisecond".
  static String _formatTime(DateTime time) {
    if (config.formatTime != null) {
      return config.formatTime!(time);
    }

    final hours = "${time.hour}:${time.minute}:${time.second}.${time.millisecond}";
    final date = "${time.day}/${time.month}/${time.year}";

    return "$date $hours";
  }

  /// Clears the logs.
  ///
  /// If a [key] is provided, only the logs associated with that key are cleared.
  /// Otherwise, all logs are cleared.
  static void clear([String? key]) {
    if (!isAuthorized()) return;

    if (key != null) {
      _logs[key]?.clear();
    } else {
      _logs.clear();
    }
  }

  /// Retrieves a list of log entries.
  ///
  /// If a [key] is provided, it returns the logs associated with that key.
  /// If no key is provided, it returns all logs.
  static List<String> get([String? key]) {
    if (!isAuthorized()) return [];

    if (key == null) {
      return _logs.entries.expand((entry) => entry.value).toList();
    }

    return _logs[key] ?? [];
  }

  /// Displays the logs in a dialog.
  ///
  /// This method uses the `ChamberDialog` widget to display the logs.
  /// If a [key] is provided, only the logs associated with that key are displayed.
  ///
  /// [context] is the BuildContext where the dialog will be shown.
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

  /// Checks if the user is authorized to perform log operations.
  ///
  /// The method returns `true` if the user is authorized based on the [config.isUserAuthorized] setting.
  static bool isAuthorized() {
    return config.isUserAuthorized;
  }
}
