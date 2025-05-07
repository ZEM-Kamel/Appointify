import 'package:appointify_app/features/appointments/domain/entities/appointment_entity.dart';
import 'package:appointify_app/features/appointments/domain/entities/time_slot_entity.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object?> get props => [];
}

class AppointmentInitial extends AppointmentState {
  const AppointmentInitial();
}

class AppointmentLoading extends AppointmentState {
  const AppointmentLoading();
}

class AppointmentError extends AppointmentState {
  final String message;

  const AppointmentError(this.message);

  @override
  List<Object?> get props => [message];
}

class AppointmentsLoaded extends AppointmentState {
  final List<AppointmentEntity> appointments;

  const AppointmentsLoaded(this.appointments);

  @override
  List<Object?> get props => [appointments];
}

class AppointmentBooked extends AppointmentState {
  final AppointmentEntity appointment;

  const AppointmentBooked(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

class AppointmentCancelled extends AppointmentState {
  final AppointmentEntity appointment;

  const AppointmentCancelled(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

class AppointmentRescheduled extends AppointmentState {
  final AppointmentEntity appointment;

  const AppointmentRescheduled(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

class AppointmentUpdated extends AppointmentState {
  final AppointmentEntity appointment;

  const AppointmentUpdated(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

class AppointmentCompleted extends AppointmentState {
  final AppointmentEntity appointment;

  const AppointmentCompleted(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

class TimeSlotChecked extends AppointmentState {
  final bool isAvailable;

  const TimeSlotChecked(this.isAvailable);

  @override
  List<Object?> get props => [isAvailable];
}

class TimeSlotsLoaded extends AppointmentState {
  final List<TimeSlotEntity> slots;

  const TimeSlotsLoaded(this.slots);

  @override
  List<Object?> get props => [slots];
}

class CanCancelAppointmentChecked extends AppointmentState {
  final bool canCancel;

  const CanCancelAppointmentChecked(this.canCancel);

  @override
  List<Object?> get props => [canCancel];
} 