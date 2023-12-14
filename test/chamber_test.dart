import 'package:log_chamber/chamber.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Chamber Logging Tests', () {
    setUpAll(() {
      // Perform any necessary initial setup here.
      // Example: Initialize a mock server if your logging interacts with a network.
      // For now, there's nothing specific needed for Chamber tests.
      print('Starting Chamber tests.');
    });

    setUp(() {
      // This is called before each test.
      // Perform any setup specific to each test here.
    });

    test('Logs are correctly stored and retrieved by key', () {
      final testKey = 'test';
      Chamber.log('Test message 1', testKey);
      Chamber.log('Test message 2', testKey);

      var logs = Chamber.get(testKey);
      expect(logs.length, 2);
      expect(logs[0].contains('Test message 1'), isTrue);
      expect(logs[1].contains('Test message 2'), isTrue);
    });

    test('Clearing logs with a specific key only clears relevant logs', () {
      Chamber.log('General message');
      Chamber.log('Test message', 'test');
      Chamber.clear('test');

      expect(Chamber.get(null).length, 1);
      expect(Chamber.get('test').isEmpty, isTrue);
    });

    test('Clearing all logs works correctly', () {
      Chamber.log('Test message', 'test');
      Chamber.clear();

      var logs = Chamber.get(null);
      expect(logs.isEmpty, isTrue);
    });

    test('Retrieving logs without a key returns all logs', () {
      Chamber.log('General message 1');
      Chamber.log('Test message', 'test');

      var logs = Chamber.get(null);
      expect(logs.length, 2);
    });

    test('Logs with different keys are stored and retrieved separately', () {
      Chamber.log('General message');
      Chamber.log('Test message', 'test');

      expect(Chamber.get('general').length, 1);
      expect(Chamber.get('test').length, 1);
      expect(Chamber.get('general')[0].contains('General message'), isTrue);
      expect(Chamber.get('test')[0].contains('Test message'), isTrue);
    });

    tearDown(() {
      // This is called after each test.
      // Perform any necessary cleanup here.
      Chamber.clear();
    });

    tearDownAll(() {
      // This is called once after all tests are completed.
      // Perform any final cleanup or shutdown activities here.
    });
  });
}
