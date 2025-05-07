import 'package:flutter/material.dart';

enum TimeSlotStatus {
  available,  // Available for booking
  booked,     // Already booked by someone else
  passed,     // Time has already passed
  pending     // Currently being booked by someone else
}

class TimeSlotEntity {
  final TimeOfDay time;
  final TimeSlotStatus status;
  final String? statusNote;

  const TimeSlotEntity({
    required this.time,
    required this.status,
    this.statusNote,
  });

  bool get isAvailable => status == TimeSlotStatus.available;

  String get displayText {
    final hour = time.hour == 0 ? "12" : (time.hour > 12 ? (time.hour - 12).toString() : time.hour.toString());
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? "PM" : "AM";
    return "$hour:$minute $period";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeSlotEntity &&
          runtimeType == other.runtimeType &&
          time.hour == other.time.hour &&
          time.minute == other.time.minute;

  @override
  int get hashCode => time.hour.hashCode ^ time.minute.hashCode;
}
