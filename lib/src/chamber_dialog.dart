import 'package:flutter/material.dart';
import 'package:log_chamber/l10n/app_localizations.dart';

import '../log_chamber.dart';

class ChamberDialog extends StatefulWidget {
  final String? logKey;
  const ChamberDialog({
    super.key,
    this.logKey,
  });

  @override
  State<ChamberDialog> createState() => _ChamberDialogState();
}

class _ChamberDialogState extends State<ChamberDialog> {
  late List<String> logs;

  bool isFullscreen = false;
  String searchValue = "";

  @override
  void initState() {
    super.initState();

    logs = Chamber.get(widget.logKey);
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    return AlertDialog(
        insetPadding: EdgeInsets.all(isFullscreen ? 0 : 16),
        contentPadding: EdgeInsets.all(isFullscreen ? 0 : 16),
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(localizations.translate('logs')),
                IconButton(
                    onPressed: () {
                      setState(() {
                        isFullscreen = !isFullscreen;
                      });
                    },
                    icon: Icon(Icons.fullscreen))
              ],
            ),
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
                          hintText: localizations.translate('search'),
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
        content: Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(250, 250, 250, 1),
              borderRadius: BorderRadius.all(Radius.circular(isFullscreen ? 0 : 16))),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            physics: BouncingScrollPhysics(),
            child: AnimatedCrossFade(
              sizeCurve: Curves.easeIn,
              duration: const Duration(milliseconds: 300),
              crossFadeState: logs.isEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              firstChild: Text(localizations.translate('noRegisterFound')),
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
        actions: <Widget>[
          TextButton(
            child: Text(localizations.translate('clean')),
            onPressed: () {
              Chamber.clear();
              setState(() {
                logs = [];
              });
            },
          ),
          TextButton(
            child: Text(localizations.translate('close')),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ]);
  }
}
