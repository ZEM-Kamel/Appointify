import 'package:appointify_app/features/appointments/domain/entities/appointment_entity.dart';
import 'package:appointify_app/features/appointments/domain/entities/time_slot_entity.dart';
import 'package:appointify_app/features/specialists/domain/entities/specialist_entity.dart';
import 'package:flutter/material.dart';

abstract class AppointmentRepository {
  /// Get all appointments for the current user
  Future<List<AppointmentEntity>> getAppointments();

  /// Get appointments filtered by status
  Future<List<AppointmentEntity>> getAppointmentsByStatus(String status);

  /// Get appointments for a specific specialist
  Future<List<AppointmentEntity>> getAppointmentsBySpecialist(SpecialistEntity specialist);

  /// Get appointments within a date range
  Future<List<AppointmentEntity>> getAppointmentsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Book a new appointment
  Future<AppointmentEntity> bookAppointment({
    required SpecialistEntity specialist,
    required DateTime dateTime,
    String? notes,
  });

  /// Cancel an existing appointment
  Future<AppointmentEntity> cancelAppointment({
    required String appointmentId,
    required String reason,
  });

  /// Reschedule an existing appointment
  Future<AppointmentEntity> rescheduleAppointment({
    required String appointmentId,
    required DateTime newDateTime,
    String? notes,
  });

  /// Update an existing appointment's notes
  Future<AppointmentEntity> updateAppointmentNotes({
    required String appointmentId,
    String? notes,
  });

  /// Mark an appointment as completed
  Future<AppointmentEntity> completeAppointment(String appointmentId);

  /// Check if a time slot is available for a specialist
  Future<bool> isTimeSlotAvailable({
    required SpecialistEntity specialist,
    required DateTime dateTime,
  });

  /// Get time slots for a specialist on a specific date with availability status
  Future<List<TimeSlotEntity>> getTimeSlots({
    required SpecialistEntity specialist,
    required DateTime date,
  });
  
  /// Get only available time slots for a specialist on a specific date (legacy method)
  @Deprecated('Use getTimeSlots instead')
  Future<List<TimeOfDay>> getAvailableTimeSlots({
    required SpecialistEntity specialist,
    required DateTime date,
  });

  /// Check if an appointment can be canceled
  Future<bool> canCancelAppointment(String appointmentId);
} 