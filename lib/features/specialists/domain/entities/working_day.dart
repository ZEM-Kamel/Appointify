class WorkingDay {
  final String day;
  final String startTime;
  final String endTime;

  WorkingDay({
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory WorkingDay.fromJson(Map<String, dynamic> json) {
    return WorkingDay(
      day: json['day'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  WorkingDay copyWith({
    String? day,
    String? startTime,
    String? endTime,
  }) {
    return WorkingDay(
      day: day ?? this.day,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
} 