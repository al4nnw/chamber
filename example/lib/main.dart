import 'package:flutter/material.dart';
import 'package:log_chamber/log_chamber.dart';

void main() {
  // Initialize Chamber
  Chamber.config = ChamberConfig(
    maxLogSize: 100,
    formatTime: (time) => "${time.hour}:${time.minute}:${time.second}.${time.millisecond}",
    isUserAuthorized: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
        title: const Text('Chamber Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Chamber.log('Button pressed with success!!');
              },
              child: const Text('Add Log'),
            ),
            ElevatedButton(
              onPressed: () {
                Chamber.display(context);
              },
              child: const Text('Show Logs'),
            ),
          ],
        ),
      ),
    );
  }
}
