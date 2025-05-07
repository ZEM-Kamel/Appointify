import 'package:appointify_app/features/appointments/domain/entities/appointment_entity.dart';
import 'package:appointify_app/features/appointments/domain/entities/time_slot_entity.dart';
import 'package:appointify_app/features/specialists/domain/entities/specialist_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object?> get props => [];
}

class LoadAppointments extends AppointmentEvent {
  const LoadAppointments();
}

class LoadAppointmentsByStatus extends AppointmentEvent {
  final String status;

  const LoadAppointmentsByStatus(this.status);

  @override
  List<Object?> get props => [status];
}

class LoadAppointmentsBySpecialist extends AppointmentEvent {
  final SpecialistEntity specialist;

  const LoadAppointmentsBySpecialist(this.specialist);

  @override
  List<Object?> get props => [specialist];
}

class LoadAppointmentsByDateRange extends AppointmentEvent {
  final DateTime startDate;
  final DateTime endDate;

  const LoadAppointmentsByDateRange({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

class BookAppointment extends AppointmentEvent {
  final SpecialistEntity specialist;
  final DateTime dateTime;
  final String? notes;

  const BookAppointment({
    required this.specialist,
    required this.dateTime,
    this.notes,
  });

  @override
  List<Object?> get props => [specialist, dateTime, notes];
}

class CancelAppointment extends AppointmentEvent {
  final String appointmentId;
  final String reason;

  const CancelAppointment({
    required this.appointmentId,
    required this.reason,
  });

  @override
  List<Object?> get props => [appointmentId, reason];
}

class RescheduleAppointment extends AppointmentEvent {
  final String appointmentId;
  final DateTime newDateTime;
  final String? notes;

  const RescheduleAppointment({
    required this.appointmentId,
    required this.newDateTime,
    this.notes,
  });

  @override
  List<Object?> get props => [appointmentId, newDateTime, notes];
}

class UpdateAppointmentNotes extends AppointmentEvent {
  final String appointmentId;
  final String? notes;

  const UpdateAppointmentNotes({
    required this.appointmentId,
    this.notes,
  });

  @override
  List<Object?> get props => [appointmentId, notes];
}

class CompleteAppointment extends AppointmentEvent {
  final String appointmentId;

  const CompleteAppointment(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

class CheckTimeSlotAvailability extends AppointmentEvent {
  final SpecialistEntity specialist;
  final DateTime dateTime;

  const CheckTimeSlotAvailability({
    required this.specialist,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [specialist, dateTime];
}

class GetAvailableTimeSlots extends AppointmentEvent {
  final SpecialistEntity specialist;
  final DateTime date;

  const GetAvailableTimeSlots({
    required this.specialist,
    required this.date,
  });

  @override
  List<Object?> get props => [specialist, date];
}

class CanCancelAppointment extends AppointmentEvent {
  final String appointmentId;

  const CanCancelAppointment(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

class TimeSlots extends AppointmentEvent {
  final SpecialistEntity specialist;
  final DateTime date;

  const TimeSlots({
    required this.specialist,
    required this.date,
  });

  @override
  List<Object?> get props => [specialist, date];
} 