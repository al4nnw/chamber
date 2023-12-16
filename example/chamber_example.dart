import 'package:flutter/material.dart';
import 'package:log_chamber/log_chamber.dart';
import 'package:log_chamber/src/chamber_config.dart';

void main() {
  // Initialize Chamber
  Chamber.config = ChamberConfig(
    maxLogSize: 100,
    formatTime: (time) => "${time.hour}:${time.minute}:${time.second}.${time.millisecond}",
    isUserAuthorized: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale('en', 'US'),
      home: ExampleApp(),
    );
  }
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chamber Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Chamber.log('Button pressed with success!!');
              },
              child: Text('Add Log'),
            ),
            ElevatedButton(
              onPressed: () {
                Chamber.display(context);
              },
              child: Text('Show Logs'),
            ),
          ],
        ),
      ),
    );
  }
}
