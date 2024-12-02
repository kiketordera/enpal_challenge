class MonitoringData {
  final DateTime timestamp;
  final int value;

  MonitoringData({required this.timestamp, required this.value});

  factory MonitoringData.fromJson(Map<String, dynamic> json) {
    return MonitoringData(
      timestamp: DateTime.parse(json['timestamp']),
      value: json['value'],
    );
  }
}
