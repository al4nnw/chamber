import 'package:flutter/material.dart';

class Chamber {
  static final Map<String, List<String>> _logs = {};

  static void log(String message, [String key = 'general']) {
    final timestamp = DateTime.now();
    final entry = "${timestamp.toIso8601String()} [$key] - $message";
    _logs.putIfAbsent(key, () => []).add(entry);
  }

  static void clear([String? key]) {
    if (key != null) {
      _logs[key]?.clear();
    } else {
      _logs.clear();
    }
  }

  static List<String> get(String? key) {
    if (key == null) {
      return _logs.entries.expand((entry) => entry.value).toList();
    }

    return _logs[key] ?? [];
  }

  static void display(BuildContext context, [String? key]) {
    final entries = get(key);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logs'),
          content: SingleChildScrollView(
              child: ListBody(
            children: entries
                .expand((entry) => [
                      Text(entry),
                      Divider(),
                    ])
                .toList(),
          )),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
