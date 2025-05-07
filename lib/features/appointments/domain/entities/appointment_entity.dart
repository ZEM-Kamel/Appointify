import 'package:appointify_app/features/specialists/domain/entities/specialist_entity.dart';

class AppointmentEntity {
  final String id;
  final SpecialistEntity specialist;
  final DateTime dateTime;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime? cancelledAt;
  final DateTime? rescheduledAt;
  final String? cancellationReason;
  final DateTime? originalDateTime;
  final DateTime? updatedAt;

  const AppointmentEntity({
    required this.id,
    required this.specialist,
    required this.dateTime,
    this.status = 'scheduled',
    this.notes,
    required this.createdAt,
    this.cancelledAt,
    this.rescheduledAt,
    this.cancellationReason,
    this.originalDateTime,
    this.updatedAt,
  });

  bool get canBeCancelled {
    if (status != 'scheduled') return false;
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    return difference.inHours >= 24;
  }

  bool get canBeRescheduled {
    if (status != 'scheduled') return false;
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    return difference.inHours >= 24;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'specialist': specialist.toJson(),
      'dateTime': dateTime.toIso8601String(),
      'status': status,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
      'rescheduledAt': rescheduledAt?.toIso8601String(),
      'cancellationReason': cancellationReason,
      'originalDateTime': originalDateTime?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory AppointmentEntity.fromJson(Map<String, dynamic> json) {
    return AppointmentEntity(
      id: json['id'] as String,
      specialist: SpecialistEntity.fromJson(json['specialist'] as Map<String, dynamic>),
      dateTime: DateTime.parse(json['dateTime'] as String),
      status: json['status'] as String,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.parse(json['cancelledAt'] as String)
          : null,
      rescheduledAt: json['rescheduledAt'] != null
          ? DateTime.parse(json['rescheduledAt'] as String)
          : null,
      cancellationReason: json['cancellationReason'] as String?,
      originalDateTime: json['originalDateTime'] != null
          ? DateTime.parse(json['originalDateTime'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  AppointmentEntity copyWith({
    String? id,
    SpecialistEntity? specialist,
    DateTime? dateTime,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? cancelledAt,
    DateTime? rescheduledAt,
    String? cancellationReason,
    DateTime? originalDateTime,
    DateTime? updatedAt,
  }) {
    return AppointmentEntity(
      id: id ?? this.id,
      specialist: specialist ?? this.specialist,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      rescheduledAt: rescheduledAt ?? this.rescheduledAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      originalDateTime: originalDateTime ?? this.originalDateTime,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 