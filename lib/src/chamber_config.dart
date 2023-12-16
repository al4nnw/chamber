class ChamberConfig {
  int maxLogSize;
  bool isUserAuthorized;

  String Function(DateTime time)? formatTime;

  ChamberConfig({
    this.maxLogSize = 1000,
    this.isUserAuthorized = true,
    this.formatTime,
  });
}
