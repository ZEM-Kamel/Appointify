import 'package:appointify_app/features/appointments/domain/entities/time_slot_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appointify_app/features/appointments/domain/repos/appointment_repo.dart';
import 'package:appointify_app/features/appointments/presentation/cubits/appointments_cubit/appointments_event.dart';
import 'package:appointify_app/features/appointments/presentation/cubits/appointments_cubit/appointments_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentRepository _repository;

  AppointmentBloc(this._repository) : super(const AppointmentInitial()) {
    on<LoadAppointments>(_onLoadAppointments);
    on<LoadAppointmentsByStatus>(_onLoadAppointmentsByStatus);
    on<LoadAppointmentsBySpecialist>(_onLoadAppointmentsBySpecialist);
    on<LoadAppointmentsByDateRange>(_onLoadAppointmentsByDateRange);
    on<BookAppointment>(_onBookAppointment);
    on<CancelAppointment>(_onCancelAppointment);
    on<RescheduleAppointment>(_onRescheduleAppointment);
    on<UpdateAppointmentNotes>(_onUpdateAppointmentNotes);
    on<CompleteAppointment>(_onCompleteAppointment);
    on<CheckTimeSlotAvailability>(_onCheckTimeSlotAvailability);
    on<GetAvailableTimeSlots>(_onGetAvailableTimeSlots);
    on<TimeSlots>(_onGetTimeSlots);
    on<CanCancelAppointment>(_onCanCancelAppointment);
  }

  Future<void> _onLoadAppointments(
    LoadAppointments event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(const AppointmentLoading());
      final appointments = await _repository.getAppointments();
      emit(AppointmentsLoaded(appointments));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onLoadAppointmentsByStatus(
    LoadAppointmentsByStatus event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(const AppointmentLoading());
      final appointments = await _repository.getAppointmentsByStatus(event.status);
      emit(AppointmentsLoaded(appointments));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onLoadAppointmentsBySpecialist(
    LoadAppointmentsBySpecialist event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(const AppointmentLoading());
      final appointments = await _repository.getAppointmentsBySpecialist(event.specialist);
      emit(AppointmentsLoaded(appointments));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onLoadAppointmentsByDateRange(
    LoadAppointmentsByDateRange event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(const AppointmentLoading());
      final appointments = await _repository.getAppointmentsByDateRange(
        event.startDate,
        event.endDate,
      );
      emit(AppointmentsLoaded(appointments));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onBookAppointment(
    BookAppointment event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(const AppointmentLoading());
      final appointment = await _repository.bookAppointment(
        specialist: event.specialist,
        dateTime: event.dateTime,
        notes: event.notes,
      );
      emit(AppointmentBooked(appointment));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onCancelAppointment(
    CancelAppointment event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(const AppointmentLoading());
      final appointment = await _repository.cancelAppointment(
        appointmentId: event.appointmentId,
        reason: event.reason,
      );
      emit(AppointmentCancelled(appointment));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onRescheduleAppointment(
    RescheduleAppointment event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(const AppointmentLoading());
      final appointment = await _repository.rescheduleAppointment(
        appointmentId: event.appointmentId,
        newDateTime: event.newDateTime,
      );
      emit(AppointmentRescheduled(appointment));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onUpdateAppointmentNotes(
    UpdateAppointmentNotes event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(const AppointmentLoading());
      final appointment = await _repository.updateAppointmentNotes(
        appointmentId: event.appointmentId,
        notes: event.notes,
      );
      emit(AppointmentUpdated(appointment));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onCompleteAppointment(
    CompleteAppointment event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(const AppointmentLoading());
      final appointment = await _repository.completeAppointment(event.appointmentId);
      emit(AppointmentCompleted(appointment));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onCheckTimeSlotAvailability(
    CheckTimeSlotAvailability event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(const AppointmentLoading());
      final isAvailable = await _repository.isTimeSlotAvailable(
        specialist: event.specialist,
        dateTime: event.dateTime,
      );
      emit(TimeSlotChecked(isAvailable));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onGetAvailableTimeSlots(
    GetAvailableTimeSlots event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(const AppointmentLoading());
      final slots = await _repository.getAvailableTimeSlots(
        specialist: event.specialist,
        date: event.date,
      );
      // Convert TimeOfDay objects to TimeSlotEntity objects with available status
      final timeSlotEntities = slots.map((timeOfDay) => 
        TimeSlotEntity(
          time: timeOfDay,
          status: TimeSlotStatus.available,
        )
      ).toList();
      emit(TimeSlotsLoaded(timeSlotEntities));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onGetTimeSlots(
    TimeSlots event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(const AppointmentLoading());
      final slots = await _repository.getTimeSlots(
        specialist: event.specialist,
        date: event.date,
      );
      emit(TimeSlotsLoaded(slots));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onCanCancelAppointment(
    CanCancelAppointment event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      final canCancel = await _repository.canCancelAppointment(event.appointmentId);
      emit(CanCancelAppointmentChecked(canCancel));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<bool> canCancelAppointment(String appointmentId) async {
    try {
      return await _repository.canCancelAppointment(appointmentId);
    } catch (e) {
      throw Exception('Failed to check cancellation eligibility: $e');
    }
  }
} 