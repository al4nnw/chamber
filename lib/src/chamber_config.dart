/// `ChamberConfig` is a configuration class for managing settings related to the Chamber log system.
/// It allows customization of log behavior, including log size limits, user authorization, and time formatting.
class ChamberConfig {
  /// Maximum number of log entries allowed in the log chamber.
  /// When the number of logs exceeds this value, the oldest log entries are removed.
  int maxLogSize;

  /// Flag to determine if the current user is authorized to perform log operations.
  /// If set to `false`, log operations like adding or clearing logs will not be executed.
  bool isUserAuthorized;

  /// Optional custom function to format the DateTime object in log entries.
  /// If not provided, a default format is used.
  String Function(DateTime time)? formatTime;

  /// Constructs a `ChamberConfig` object with optional parameters.
  ///
  /// [maxLogSize] sets the limit for the maximum number of log entries. Defaults to 1000.
  /// [isUserAuthorized] determines if the user is authorized to modify logs. Defaults to `true`.
  /// [formatTime] is an optional function for custom time formatting in log entries.
  ChamberConfig({
    this.maxLogSize = 1000,
    this.isUserAuthorized = true,
    this.formatTime,
  });
}
