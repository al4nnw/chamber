import 'package:flutter/material.dart';
import 'package:log_chamber/l10n/app_localizations.dart';
import '../log_chamber.dart';

/// `ChamberDialog` is a widget that displays logs in a dialog.
/// It allows for viewing and searching through logs, and offers full-screen mode for better visibility.
///
/// This dialog is designed to work with the `Chamber` class for log management.
class ChamberDialog extends StatefulWidget {
  /// Localizations for the application.
  /// Used to translate strings within the dialog.
  final AppLocalizations localizations;

  /// Optional key to filter logs.
  /// If provided, only logs associated with this key are displayed.
  final String? logKey;

  /// Constructs a `ChamberDialog`.
  ///
  /// [localizations] must be provided to ensure proper string translations.
  /// [logKey] is optional and used to filter logs.
  const ChamberDialog({
    super.key,
    required this.localizations,
    this.logKey,
  });

  @override
  State<ChamberDialog> createState() => _ChamberDialogState();
}

class _ChamberDialogState extends State<ChamberDialog> {
  /// A list of logs to be displayed in the dialog.
  late List<String> logs;

  /// Indicates if the dialog is in full-screen mode.
  bool isFullscreen = false;

  /// Value used for searching within the logs.
  String searchValue = "";

  @override
  void initState() {
    super.initState();

    // Initializes the logs based on the provided log key.
    logs = Chamber.get(widget.logKey);
  }

  @override
  Widget build(BuildContext context) {
    // Building the UI for the dialog.
    return AlertDialog(
      // Adjusts padding based on whether the dialog is in full-screen mode.
      insetPadding: EdgeInsets.all(isFullscreen ? 0 : 16),
      contentPadding: EdgeInsets.all(isFullscreen ? 0 : 16),
      title: Column(
        children: [
          // Top bar with title and fullscreen toggle.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.localizations.translate('logs')),
              IconButton(
                onPressed: () {
                  setState(() {
                    isFullscreen = !isFullscreen;
                  });
                },
                icon: Icon(Icons.fullscreen),
              )
            ],
          ),
          // Search bar shown only in full-screen mode.
          isFullscreen
              ? Column(
                  children: [
                    Divider(),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          searchValue = value.toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: widget.localizations.translate('search'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                )
              : SizedBox.shrink(),
        ],
      ),
      content: Column(
        mainAxisSize: isFullscreen ? MainAxisSize.max : MainAxisSize.min,
        crossAxisAlignment: isFullscreen ? CrossAxisAlignment.stretch : CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(250, 250, 250, 1),
              borderRadius: BorderRadius.all(Radius.circular(isFullscreen ? 0 : 16)),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              physics: BouncingScrollPhysics(),
              child: AnimatedCrossFade(
                sizeCurve: Curves.easeIn,
                duration: const Duration(milliseconds: 300),
                crossFadeState: logs.isEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                firstChild: Text(widget.localizations.translate('noRegisterFound')),
                secondChild: ListBody(
                  children: logs.expand((entry) {
                    if (searchValue.isNotEmpty && !entry.toLowerCase().contains(searchValue)) {
                      return [SizedBox.shrink()];
                    }

                    return [
                      Text(entry),
                      Divider(),
                    ];
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        // Button to clear logs.
        TextButton(
          child: Text(widget.localizations.translate('clean')),
          onPressed: () {
            Chamber.clear();
            setState(() {
              logs = [];
            });
          },
        ),
        // Button to close the dialog.
        TextButton(
          child: Text(widget.localizations.translate('close')),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
