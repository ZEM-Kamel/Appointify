import 'dart:convert';
import 'dart:async';
import 'package:appointify_app/features/appointments/domain/entities/appointment_entity.dart';
import 'package:appointify_app/features/appointments/domain/entities/time_slot_entity.dart';
import 'package:appointify_app/features/appointments/domain/repos/appointment_repo.dart';
import 'package:appointify_app/features/search/presentation/views/widgets/filter_options.dart';
import 'package:appointify_app/features/specialists/domain/entities/specialist_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appointify_app/features/appointments/data/models/appointment_model.dart';
import 'package:appointify_app/core/services/notification_service.dart';
import 'package:appointify_app/core/helper_functions/get_user.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  // Constants for pending booking reservation
  static const int _pendingBookingExpirationMinutes = 5; // Reservation expires after 5 minutes
  final FirebaseFirestore _firestore;
  final NotificationService _notificationService;

  AppointmentRepositoryImpl({
    FirebaseFirestore? firestore,
    NotificationService? notificationService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _notificationService = notificationService ?? NotificationService();

  String get _userId {
    try {
      final userId = getUser()?.uId;
      if (userId!.isEmpty) {
        print('Warning: User ID is empty, user might not be properly authenticated');
        throw Exception('User not authenticated');
      }
      return userId;
    } catch (e) {
      print('Error getting user ID: $e');
      throw Exception('Failed to get user ID: $e');
    }
  }

  @override
  Future<List<AppointmentEntity>> getAppointments() async {
    try {
      final userId = _userId;
      print('Fetching appointments for user: $userId');

      final snapshot = await _firestore
          .collection('appointments')
          .where('userId', isEqualTo: userId)
          .orderBy('dateTime', descending: true)
          .get();

      print('Found ${snapshot.docs.length} appointments');

      final appointments = <AppointmentEntity>[];
      final errors = <String>[];
      
      for (var doc in snapshot.docs) {
        try {
          print('Processing appointment document: ${doc.id}');
          final data = doc.data();
          if (data == null) {
            print('Warning: Document ${doc.id} has no data');
            continue;
          }
          
          final appointment = AppointmentModel.fromFirestore(doc).toEntity();
          appointments.add(appointment);
          print('Successfully processed appointment: ${doc.id}');
        } catch (e) {
          final error = 'Error processing appointment ${doc.id}: $e';
          print(error);
          errors.add(error);
          continue;
        }
      }

      if (errors.isNotEmpty) {
        print('Encountered ${errors.length} errors while processing appointments:');
        for (var error in errors) {
          print(error);
        }
      }

      if (appointments.isEmpty && errors.isNotEmpty) {
        throw Exception('Failed to process any appointments: ${errors.join(", ")}');
      }

      return appointments;
    } catch (e) {
      print('Failed to fetch appointments: $e');
      if (e is FirebaseException) {
        throw Exception('Failed to fetch appointments: ${e.message}');
      }
      throw Exception('Failed to fetch appointments: $e');
    }
  }

  @override
  Future<List<AppointmentEntity>> getAppointmentsByStatus(String status) async {
    try {
      final snapshot = await _firestore
          .collection('appointments')
          .where('userId', isEqualTo: _userId)
          .where('status', isEqualTo: status)
          .orderBy('dateTime', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => AppointmentModel.fromFirestore(doc).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch appointments by status: $e');
    }
  }

  @override
  Future<List<AppointmentEntity>> getAppointmentsBySpecialist(
    SpecialistEntity specialist,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('appointments')
          .where('userId', isEqualTo: _userId)
          .where('specialistId', isEqualTo: specialist.id)
          .orderBy('dateTime', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => AppointmentModel.fromFirestore(doc).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch appointments by specialist: $e');
    }
  }

  @override
  Future<List<AppointmentEntity>> getAppointmentsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('appointments')
          .where('userId', isEqualTo: _userId)
          .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('dateTime', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('dateTime', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => AppointmentModel.fromFirestore(doc).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch appointments by date range: $e');
    }
  }

  // Create a temporary reservation for a time slot
  Future<void> _createTemporaryReservation({
    required String specialistId,
    required DateTime dateTime,
  }) async {
    try {
      final userId = _userId;
      final expirationTime = DateTime.now().add(Duration(minutes: _pendingBookingExpirationMinutes));
      
      await _firestore.collection('pending_bookings').add({
        'userId': userId,
        'specialistId': specialistId,
        'dateTime': Timestamp.fromDate(dateTime),
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'expiresAt': Timestamp.fromDate(expirationTime),
      });
      
      // Schedule cleanup of expired reservations
      _schedulePendingBookingCleanup(expirationTime);
      
    } catch (e) {
      print('Error creating temporary reservation: $e');
      // Don't throw - this is a best-effort mechanism
    }
  }

  // Remove a temporary reservation when booking completes or is abandoned
  Future<void> _removeTemporaryReservation({
    required String specialistId,
    required DateTime dateTime,
  }) async {
    try {
      final userId = _userId;
      
      final query = await _firestore.collection('pending_bookings')
          .where('userId', isEqualTo: userId)
          .where('specialistId', isEqualTo: specialistId)
          .where('dateTime', isEqualTo: Timestamp.fromDate(dateTime))
          .get();
      
      for (var doc in query.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error removing temporary reservation: $e');
      // Don't throw - this is a best-effort mechanism
    }
  }

  // Automatically remove expired pending bookings
  void _schedulePendingBookingCleanup(DateTime expirationTime) {
    Timer(Duration(minutes: _pendingBookingExpirationMinutes + 1), () {
      _cleanupExpiredPendingBookings();
    });
  }

  Future<void> _cleanupExpiredPendingBookings() async {
    try {
      final now = DateTime.now();
      final query = await _firestore.collection('pending_bookings')
          .where('expiresAt', isLessThan: Timestamp.fromDate(now))
          .get();
      
      final batch = _firestore.batch();
      for (var doc in query.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
    } catch (e) {
      print('Error cleaning up expired pending bookings: $e');
    }
  }

  int _timeOfDayToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  @override
  Future<AppointmentEntity> bookAppointment({
    required SpecialistEntity specialist,
    required DateTime dateTime,
    String? notes,
  }) async {
    try {
      // First check if the time slot is actually available (both confirmed and pending bookings)
      final isAvailable = await isTimeSlotAvailable(
        specialist: specialist,
        dateTime: dateTime,
      );
      
      if (!isAvailable) {
        throw Exception('This time slot is no longer available. Please select another time.');
      }
      
      // Check if the appointment is being booked at least 24 hours in advance
      final now = DateTime.now();
      final difference = dateTime.difference(now);
      if (difference.inHours < 24) {
        throw Exception('Appointments must be scheduled at least 24 hours in advance.');
      }
      
      // Create a temporary reservation to prevent double bookings
      await _createTemporaryReservation(
        specialistId: specialist.id,
        dateTime: dateTime,
      );

      final appointment = AppointmentEntity(
        id: '', // Will be set by Firestore
        specialist: specialist,
        dateTime: dateTime,
        status: 'scheduled',
        notes: notes,
        createdAt: DateTime.now(),
        updatedAt: null,
        cancellationReason: null,
        cancelledAt: null,
      );

      final model = AppointmentModel.fromEntity(appointment, _userId);
      final docRef = await _firestore.collection('appointments').add(model.toFirestore());
      
      // Remove the temporary reservation since booking is complete
      await _removeTemporaryReservation(
        specialistId: specialist.id,
        dateTime: dateTime,
      );
      
      // Schedule reminder notifications
      await _scheduleReminders(docRef.id, appointment.copyWith(id: docRef.id));

      return appointment.copyWith(id: docRef.id);
    } catch (e) {
      // If booking fails, also remove the temporary reservation
      try {
        await _removeTemporaryReservation(
          specialistId: specialist.id,
          dateTime: dateTime,
        );
      } catch (_) {}
      
      throw Exception('Failed to book appointment: $e');
    }
  }

  Future<void> _scheduleReminders(String appointmentId, AppointmentEntity appointment) async {
    // Schedule reminder 1 day before
    await _notificationService.scheduleAppointmentReminder(
      id: appointmentId,
      title: 'Appointment Tomorrow',
      body: 'You have an appointment with ${appointment.specialist.name} tomorrow at ${DateFormat('hh:mm a').format(appointment.dateTime)}',
      scheduledTime: appointment.dateTime,
      minutesBefore: 24 * 60, // 24 hours before
    );

    // Schedule reminder 6 hours before
    await _notificationService.scheduleAppointmentReminder(
      id: '${appointmentId}_1',
      title: 'Appointment in 6 Hours',
      body: 'You have an appointment with ${appointment.specialist.name} in 6 hours at ${DateFormat('hh:mm a').format(appointment.dateTime)}',
      scheduledTime: appointment.dateTime,
      minutesBefore: 6 * 60, // 6 hours before
    );

    // Schedule reminder 1 hour before
    await _notificationService.scheduleAppointmentReminder(
      id: '${appointmentId}_2',
      title: 'Appointment in 1 Hour',
      body: 'You have an appointment with ${appointment.specialist.name} in 1 hour at ${DateFormat('hh:mm a').format(appointment.dateTime)}',
      scheduledTime: appointment.dateTime,
      minutesBefore: 60, // 1 hour before
    );

    // Schedule reminder 15 minutes before
    await _notificationService.scheduleAppointmentReminder(
      id: '${appointmentId}_3',
      title: 'Appointment in 15 Minutes',
      body: 'You have an appointment with ${appointment.specialist.name} in 15 minutes at ${DateFormat('hh:mm a').format(appointment.dateTime)}',
      scheduledTime: appointment.dateTime,
      minutesBefore: 15, // 15 minutes before
    );
  }

  @override
  Future<bool> canCancelAppointment(String appointmentId) async {
    try {
      final docRef = _firestore.collection('appointments').doc(appointmentId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw Exception('Appointment not found');
      }

      final model = AppointmentModel.fromFirestore(doc);
      
      // Check if appointment is already cancelled or completed
      if (model.status == 'cancelled' || model.status == 'completed') {
        return false;
      }

      // Check if appointment is within cancellation window (24 hours)
      final now = DateTime.now();
      final difference = model.dateTime.difference(now);
      
      // Can cancel if more than 24 hours before appointment
      return difference.inHours >= 24;
    } catch (e) {
      throw Exception('Failed to check cancellation eligibility: $e');
    }
  }

  @override
  Future<AppointmentEntity> cancelAppointment({
    required String appointmentId,
    required String reason,
  }) async {
    try {
      // Cancel all reminders for this appointment
      await _notificationService.cancelReminder(appointmentId);
      await _notificationService.cancelReminder('${appointmentId}_1');
      await _notificationService.cancelReminder('${appointmentId}_2');
      await _notificationService.cancelReminder('${appointmentId}_3');

      final docRef = _firestore.collection('appointments').doc(appointmentId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw Exception('Appointment not found');
      }

      final model = AppointmentModel.fromFirestore(doc);

      // Check if appointment can be cancelled
      final canCancel = await canCancelAppointment(appointmentId);
      if (!canCancel) {
        throw Exception('Appointments can only be cancelled at least 24 hours before the scheduled time.');
      }

      final updatedModel = AppointmentModel(
        id: model.id,
        userId: model.userId,
        specialistId: model.specialistId,
        specialist: model.specialist,
        dateTime: model.dateTime,
        status: 'cancelled',
        notes: model.notes,
        cancellationReason: reason,
        createdAt: model.createdAt,
        updatedAt: DateTime.now(),
        statusHistory: [
          ...model.statusHistory,
          {
            'status': 'cancelled',
            'date': DateTime.now().toIso8601String(),
            'reason': reason,
          }
        ],
      );

      await docRef.update(updatedModel.toFirestore());
      return updatedModel.toEntity();
    } catch (e) {
      throw Exception('Failed to cancel appointment: $e');
    }
  }

  @override
  Future<AppointmentEntity> rescheduleAppointment({
    required String appointmentId,
    required DateTime newDateTime,
    String? notes,
  }) async {
    try {
      // Cancel existing reminders
      await _notificationService.cancelReminder(appointmentId);
      await _notificationService.cancelReminder('${appointmentId}_1');
      await _notificationService.cancelReminder('${appointmentId}_2');
      await _notificationService.cancelReminder('${appointmentId}_3');

      final docRef = _firestore.collection('appointments').doc(appointmentId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw Exception('Appointment not found');
      }

      final model = AppointmentModel.fromFirestore(doc);

      // First create a temporary reservation for the new time slot
      await _createTemporaryReservation(
        specialistId: model.specialistId,
        dateTime: newDateTime,
      );
      
      try {
        // First check if we're rescheduling to the exact same time (updating notes only)
        final isSameDateTime = model.dateTime.year == newDateTime.year &&
                               model.dateTime.month == newDateTime.month &&
                               model.dateTime.day == newDateTime.day &&
                               model.dateTime.hour == newDateTime.hour &&
                               model.dateTime.minute == newDateTime.minute;
      
        // If we're not just updating notes (same date/time), check if the new slot is available
        if (!isSameDateTime) {
          // Check for any booked appointments at this time (excluding the one being rescheduled)
          final bookedSlotsSnapshot = await _firestore
              .collection('appointments')
              .where('specialistId', isEqualTo: model.specialistId)
              .where('dateTime', isEqualTo: Timestamp.fromDate(newDateTime))
              .where('status', isEqualTo: 'scheduled')
              .get();
        
          // Check if any of the booked slots belong to other users
          bool slotAvailable = true;
          for (var doc in bookedSlotsSnapshot.docs) {
            // Skip if this is the appointment we're currently rescheduling
            if (doc.id == appointmentId) continue;
          
            // If we find another appointment, the slot is not available
            slotAvailable = false;
            break;
          }
        
          if (!slotAvailable) {
            // Remove the temporary reservation since we won't use this slot
            await _removeTemporaryReservation(
              specialistId: model.specialistId,
              dateTime: newDateTime,
            );
            throw Exception('This time slot is already booked. Please choose another time.');
          }
        }

        // Check if the new date is within the specialist's working days
        final dayName = DateFormat('EEEE').format(newDateTime).toLowerCase();
        final isWorkingDay = model.specialist.workingDays.any(
          (day) => day.day.toLowerCase() == dayName,
        );

        if (!isWorkingDay) {
          // Remove the temporary reservation since we won't use this slot
          await _removeTemporaryReservation(
            specialistId: model.specialistId,
            dateTime: newDateTime,
          );
          throw Exception('The specialist is not available on this day.');
        }

        // Check if the new date is at least 24 hours in the future
        final now = DateTime.now();
        final difference = newDateTime.difference(now);
        if (difference.inHours < 24) {
          // Remove the temporary reservation since we won't use this slot
          await _removeTemporaryReservation(
            specialistId: model.specialistId,
            dateTime: newDateTime,
          );
          throw Exception('Appointments must be scheduled at least 24 hours in advance.');
        }

        final updatedModel = AppointmentModel(
          id: model.id,
          userId: model.userId,
          specialistId: model.specialistId,
          specialist: model.specialist,
          dateTime: newDateTime,
          status: 'scheduled',
          notes: notes ?? model.notes,
          cancellationReason: model.cancellationReason,
          createdAt: model.createdAt,
          updatedAt: DateTime.now(),
          statusHistory: [
            ...model.statusHistory,
            {
              'status': 'scheduled',
              'date': DateTime.now().toIso8601String(),
              'reason': 'Appointment rescheduled to ${DateFormat('MMM dd, yyyy hh:mm a').format(newDateTime)}',
            }
          ],
        );

        await docRef.update(updatedModel.toFirestore());

        // Remove the temporary reservation since the real booking is complete
        await _removeTemporaryReservation(
          specialistId: model.specialistId,
          dateTime: newDateTime,
        );
        
        // Schedule new reminders
        await _scheduleReminders(appointmentId, updatedModel.toEntity());

        return updatedModel.toEntity();
      } catch (e) {
        // Remove the temporary reservation if anything fails
        await _removeTemporaryReservation(
          specialistId: model.specialistId,
          dateTime: newDateTime,
        );
        throw e; // Re-throw the error
      }
    } catch (e) {
      throw Exception('Failed to reschedule appointment: $e');
    }
  }

  @override
  Future<List<TimeSlotEntity>> getTimeSlots({
    required SpecialistEntity specialist,
    required DateTime date,
  }) async {
    try {
      // First, clean up any expired pending bookings
      await _cleanupExpiredPendingBookings();
      
      // Get working day data for the requested date
      String dayOfWeek = DateFormat('EEEE').format(date).toLowerCase();
      print('Checking time slots for $dayOfWeek');
      
      // Check if specialist works on this day
      WorkingDayEntity? workingDay;
      try {
        workingDay = specialist.workingDays.firstWhere(
          (day) => day.day.toLowerCase() == dayOfWeek,
          orElse: () => throw Exception('The specialist does not work on ${dayOfWeek.capitalize()}'),
        );
      } catch (e) {
        print('Specialist does not work on this day: $e');
        return [];
      }
      
      print('Working hours: ${workingDay.startTime} - ${workingDay.endTime}');
      
      // Parse working hours
      final startTimeParts = workingDay.startTime.split(':');
      final endTimeParts = workingDay.endTime.split(':');
      
      final startTime = TimeOfDay(
        hour: int.parse(startTimeParts[0]),
        minute: int.parse(startTimeParts[1]),
      );
      
      final endTime = TimeOfDay(
        hour: int.parse(endTimeParts[0]),
        minute: int.parse(endTimeParts[1]),
      );
      
      // Get all booked slots for this specialist on this date
      final dateStart = DateTime(date.year, date.month, date.day, 0, 0, 0);
      final dateEnd = DateTime(date.year, date.month, date.day, 23, 59, 59);
      
      // Get confirmed bookings
      final bookedSlotsSnapshot = await _firestore
          .collection('appointments')
          .where('specialistId', isEqualTo: specialist.id)
          .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(dateStart))
          .where('dateTime', isLessThanOrEqualTo: Timestamp.fromDate(dateEnd))
          .where('status', isEqualTo: 'scheduled')
          .get();
      
      print('Found ${bookedSlotsSnapshot.docs.length} confirmed booked slots');
      
      // Get pending bookings (time slots that are in the process of being booked)
      final pendingBookingsSnapshot = await _firestore
          .collection('pending_bookings')
          .where('specialistId', isEqualTo: specialist.id)
          .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(dateStart))
          .where('dateTime', isLessThanOrEqualTo: Timestamp.fromDate(dateEnd))
          .where('expiresAt', isGreaterThan: Timestamp.fromDate(DateTime.now()))
          .get();
      
      print('Found ${pendingBookingsSnapshot.docs.length} pending booked slots');
      
      // Map for quick lookup of booked and pending slots
      final bookedSlots = <String, DateTime>{};
      for (var doc in bookedSlotsSnapshot.docs) {
        final timestamp = doc.data()['dateTime'] as Timestamp;
        final dateTime = timestamp.toDate();
        final key = '${dateTime.hour}:${dateTime.minute}';
        bookedSlots[key] = dateTime;
      }
      
      final pendingSlots = <String, DateTime>{};
      for (var doc in pendingBookingsSnapshot.docs) {
        final timestamp = doc.data()['dateTime'] as Timestamp;
        final dateTime = timestamp.toDate();
        final key = '${dateTime.hour}:${dateTime.minute}';
        pendingSlots[key] = dateTime;
      }
      
      // Create list of all time slots with their availability status
      final allTimeSlots = <TimeSlotEntity>[];
      var currentTime = startTime;
      final now = DateTime.now();
      final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
      
      while (_timeOfDayToMinutes(currentTime) <= _timeOfDayToMinutes(endTime) - 30) {
        final timeKey = '${currentTime.hour}:${currentTime.minute}';
        final slotDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          currentTime.hour,
          currentTime.minute,
        );
        
        TimeSlotStatus status;
        String? statusNote;
        
        // Check if the time has already passed (if today)
        if (isToday && slotDateTime.isBefore(now)) {
          status = TimeSlotStatus.passed;
          statusNote = 'This time has already passed';
        }
        // Check if the slot is already booked
        else if (bookedSlots.containsKey(timeKey)) {
          status = TimeSlotStatus.booked;
          statusNote = 'This slot is already booked';
        }
        // Check if the slot is currently being booked by someone
        else if (pendingSlots.containsKey(timeKey)) {
          status = TimeSlotStatus.pending;
          statusNote = 'This slot is being booked by someone else';
        }
        // Otherwise, the slot is available
        else {
          status = TimeSlotStatus.available;
        }
        
        allTimeSlots.add(TimeSlotEntity(
          time: currentTime,
          status: status,
          statusNote: statusNote,
        ));
        
        // Move to next 30-minute slot
        currentTime = TimeOfDay(
          hour: currentTime.hour + (currentTime.minute + 30) ~/ 60,
          minute: (currentTime.minute + 30) % 60,
        );
      }

      return allTimeSlots;
    } catch (e) {
      print('Error getting time slots: $e');
      throw Exception('Failed to get time slots: $e');
    }
  }

  @override
  @Deprecated('Use getTimeSlots instead')
  Future<List<TimeOfDay>> getAvailableTimeSlots({
    required SpecialistEntity specialist,
    required DateTime date,
  }) async {
    try {
      // First, clean up any expired pending bookings
      await _cleanupExpiredPendingBookings();
      
      // Get working day data for the requested date
      String dayOfWeek = DateFormat('EEEE').format(date).toLowerCase();
      print('Checking available slots for $dayOfWeek');
      
      final workingDay = specialist.workingDays.firstWhere(
        (day) => day.day.toLowerCase() == dayOfWeek,
        orElse: () => throw Exception('The specialist does not work on ${dayOfWeek.capitalize()}'),
      );
      
      print('Working hours: ${workingDay.startTime} - ${workingDay.endTime}');
      
      // Parse working hours
      final startTimeParts = workingDay.startTime.split(':');
      final endTimeParts = workingDay.endTime.split(':');
      
      final startTime = TimeOfDay(
        hour: int.parse(startTimeParts[0]),
        minute: int.parse(startTimeParts[1]),
      );
      
      final endTime = TimeOfDay(
        hour: int.parse(endTimeParts[0]),
        minute: int.parse(endTimeParts[1]),
      );
      
      print('Start time: ${startTime.hour}:${startTime.minute}');
      print('End time: ${endTime.hour}:${endTime.minute}');
      
      // Get all booked slots for this specialist on this date
      final dateStart = DateTime(date.year, date.month, date.day, 0, 0, 0);
      final dateEnd = DateTime(date.year, date.month, date.day, 23, 59, 59);
      
      // Get confirmed bookings
      final bookedSlotsSnapshot = await _firestore
          .collection('appointments')
          .where('specialistId', isEqualTo: specialist.id)
          .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(dateStart))
          .where('dateTime', isLessThanOrEqualTo: Timestamp.fromDate(dateEnd))
          .where('status', isEqualTo: 'scheduled')
          .get();
      
      print('Found ${bookedSlotsSnapshot.docs.length} confirmed booked slots');
      
      // Get pending bookings (time slots that are in the process of being booked)
      final pendingBookingsSnapshot = await _firestore
          .collection('pending_bookings')
          .where('specialistId', isEqualTo: specialist.id)
          .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(dateStart))
          .where('dateTime', isLessThanOrEqualTo: Timestamp.fromDate(dateEnd))
          .where('expiresAt', isGreaterThan: Timestamp.fromDate(DateTime.now())) // Only consider non-expired pending bookings
          .get();
      
      print('Found ${pendingBookingsSnapshot.docs.length} pending booked slots');
      
      // Extract all unavailable times (both confirmed and pending)
      final unavailableSlots = <DateTime>[];
      
      // Add confirmed bookings
      unavailableSlots.addAll(bookedSlotsSnapshot.docs.map((doc) {
        final timestamp = doc.data()['dateTime'] as Timestamp;
        return timestamp.toDate();
      }));
      
      // Add pending bookings
      unavailableSlots.addAll(pendingBookingsSnapshot.docs.map((doc) {
        final timestamp = doc.data()['dateTime'] as Timestamp;
        return timestamp.toDate();
      }));
      
      // Create list of available time slots at 30-minute intervals
      final availableSlots = <TimeOfDay>[];
      var currentTime = startTime;
      
      while (_timeOfDayToMinutes(currentTime) <= _timeOfDayToMinutes(endTime) - 30) {
        print('Checking slot: ${currentTime.hour}:${currentTime.minute.toString().padLeft(2, '0')}');
        
        // Create a DateTime for the current slot for comparison
        final slotDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          currentTime.hour,
          currentTime.minute,
        );
        
        // Check if this slot is unavailable (either booked or pending)
        final isUnavailable = unavailableSlots.any((unavailable) =>
          unavailable.year == slotDateTime.year &&
          unavailable.month == slotDateTime.month &&
          unavailable.day == slotDateTime.day &&
          unavailable.hour == slotDateTime.hour &&
          unavailable.minute == slotDateTime.minute
        );
        
        if (!isUnavailable) {
          availableSlots.add(currentTime);
          print('Available slot: ${currentTime.hour}:${currentTime.minute.toString().padLeft(2, '0')}');
        } else {
          print('Slot ${currentTime.hour}:${currentTime.minute.toString().padLeft(2, '0')} is unavailable');
        }

        // Move to next 30-minute slot
        currentTime = TimeOfDay(
          hour: currentTime.hour + (currentTime.minute + 30) ~/ 60,
          minute: (currentTime.minute + 30) % 60,
        );
      }

      return availableSlots;
    } catch (e) {
      print('Error getting available time slots: $e');
      throw Exception('Failed to get available time slots: $e');
    }
  }

  @override
  Future<bool> isTimeSlotAvailable({
    required SpecialistEntity specialist,
    required DateTime dateTime,
  }) async {
    try {
      // First, clean up any expired pending bookings
      await _cleanupExpiredPendingBookings();
      
      // Check for any booked appointments at this time
      final bookedSlotsSnapshot = await _firestore
          .collection('appointments')
          .where('specialistId', isEqualTo: specialist.id)
          .where('dateTime', isEqualTo: Timestamp.fromDate(dateTime))
          .where('status', isEqualTo: 'scheduled')
          .get();

      // If there's a confirmed booking, the slot is not available
      if (bookedSlotsSnapshot.docs.isNotEmpty) {
        return false;
      }
      
      // Also check for any pending bookings at this time to prevent double bookings
      final pendingBookingsSnapshot = await _firestore
          .collection('pending_bookings')
          .where('specialistId', isEqualTo: specialist.id)
          .where('dateTime', isEqualTo: Timestamp.fromDate(dateTime))
          .where('expiresAt', isGreaterThan: Timestamp.fromDate(DateTime.now())) // Only consider non-expired pending bookings
          .get();

      // Time slot is available if no confirmed appointments or pending bookings are found
      return pendingBookingsSnapshot.docs.isEmpty;
    } catch (e) {
      print('Error checking time slot availability: $e');
      throw Exception('Failed to check time slot availability: $e');
    }
  }

  @override
  Future<AppointmentEntity> completeAppointment(String appointmentId) async {
    try {
      final docRef = _firestore.collection('appointments').doc(appointmentId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw Exception('Appointment not found');
      }

      final model = AppointmentModel.fromFirestore(doc);
      final updatedModel = AppointmentModel(
        id: model.id,
        userId: model.userId,
        specialistId: model.specialistId,
        specialist: model.specialist,
        dateTime: model.dateTime,
        status: 'completed',
        notes: model.notes,
        cancellationReason: model.cancellationReason,
        createdAt: model.createdAt,
        updatedAt: DateTime.now(),
        statusHistory: [
          ...model.statusHistory,
          {
            'status': 'completed',
            'date': DateTime.now().toIso8601String(),
            'reason': 'Appointment completed',
          }
        ],
      );

      await docRef.update(updatedModel.toFirestore());
      return updatedModel.toEntity();
    } catch (e) {
      throw Exception('Failed to complete appointment: $e');
    }
  }

  @override
  Future<AppointmentEntity> updateAppointmentNotes({
    required String appointmentId,
    String? notes,
  }) async {
    try {
      final docRef = _firestore.collection('appointments').doc(appointmentId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw Exception('Appointment not found');
      }

      final model = AppointmentModel.fromFirestore(doc);

      final updatedModel = AppointmentModel(
        id: model.id,
        userId: model.userId,
        specialistId: model.specialistId,
        specialist: model.specialist,
        dateTime: model.dateTime,
        status: model.status,
        notes: notes,
        cancellationReason: model.cancellationReason,
        createdAt: model.createdAt,
        updatedAt: DateTime.now(),
        statusHistory: [
          ...model.statusHistory,
          {
            'status': model.status,
            'date': DateTime.now().toIso8601String(),
            'reason': 'Appointment notes updated',
          }
        ],
      );

      await docRef.update(updatedModel.toFirestore());
      return updatedModel.toEntity();
    } catch (e) {
      throw Exception('Failed to update appointment notes: $e');
    }
  }
} 