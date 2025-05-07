import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appointify_app/features/appointments/domain/entities/appointment_entity.dart';
import 'package:appointify_app/features/specialists/domain/entities/specialist_entity.dart';

class AppointmentModel {
  final String id;
  final String userId;
  final String specialistId;
  final SpecialistEntity specialist;
  final DateTime dateTime;
  final String status;
  final String? notes;
  final String? cancellationReason;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<Map<String, dynamic>> statusHistory;

  AppointmentModel({
    required this.id,
    required this.userId,
    required this.specialistId,
    required this.specialist,
    required this.dateTime,
    required this.status,
    this.notes,
    this.cancellationReason,
    required this.createdAt,
    this.updatedAt,
    List<Map<String, dynamic>>? statusHistory,
  }) : statusHistory = statusHistory ?? [
          {
            'status': status,
            'date': createdAt.toIso8601String(),
            'reason': 'Appointment created',
          }
        ];

  factory AppointmentModel.fromFirestore(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>?;
      
      if (data == null) {
        print('Error: Document ${doc.id} has no data');
        throw Exception('Appointment document ${doc.id} has no data');
      }
      
      // Validate required fields
      if (data['userId'] == null) {
        print('Error: Document ${doc.id} is missing userId field');
        throw Exception('Appointment document ${doc.id} is missing userId field');
      }
      if (data['specialistId'] == null) {
        print('Error: Document ${doc.id} is missing specialistId field');
        throw Exception('Appointment document ${doc.id} is missing specialistId field');
      }
      if (data['dateTime'] == null) {
        print('Error: Document ${doc.id} is missing dateTime field');
        throw Exception('Appointment document ${doc.id} is missing dateTime field');
      }
      if (data['status'] == null) {
        print('Error: Document ${doc.id} is missing status field');
        throw Exception('Appointment document ${doc.id} is missing status field');
      }
      if (data['createdAt'] == null) {
        print('Error: Document ${doc.id} is missing createdAt field');
        throw Exception('Appointment document ${doc.id} is missing createdAt field');
      }

      // Handle specialist data
      SpecialistEntity specialist;
      try {
        if (data['specialist'] == null) {
          print('Error: Document ${doc.id} is missing specialist data');
          throw Exception('Appointment document ${doc.id} is missing specialist data');
        }
        
        final specialistData = data['specialist'];
        if (specialistData is! Map<String, dynamic>) {
          print('Error: Invalid specialist data format in document ${doc.id}');
          throw Exception('Invalid specialist data format in appointment ${doc.id}');
        }
        
        // Validate required specialist fields
        if (specialistData['id'] == null) {
          print('Error: Specialist data is missing id field');
          throw Exception('Specialist data is missing id field');
        }
        if (specialistData['name'] == null) {
          print('Error: Specialist data is missing name field');
          throw Exception('Specialist data is missing name field');
        }
        
        specialist = SpecialistEntity.fromJson(specialistData);
      } catch (e) {
        print('Error parsing specialist data for appointment ${doc.id}: $e');
        throw Exception('Failed to parse specialist data for appointment ${doc.id}: $e');
      }

      return AppointmentModel(
        id: doc.id,
        userId: data['userId'] as String,
        specialistId: data['specialistId'] as String,
        specialist: specialist,
        dateTime: (data['dateTime'] as Timestamp).toDate(),
        status: data['status'] as String,
        notes: data['notes'] as String?,
        cancellationReason: data['cancellationReason'] as String?,
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        updatedAt: data['updatedAt'] != null 
            ? (data['updatedAt'] as Timestamp).toDate()
            : null,
        statusHistory: List<Map<String, dynamic>>.from(data['statusHistory'] ?? []),
      );
    } catch (e) {
      print('Error creating AppointmentModel from Firestore document ${doc.id}: $e');
      throw Exception('Failed to create appointment model: $e');
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'specialistId': specialistId,
      'specialist': specialist.toJson(),
      'dateTime': Timestamp.fromDate(dateTime),
      'status': status,
      'notes': notes,
      'cancellationReason': cancellationReason,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'statusHistory': statusHistory,
    };
  }

  AppointmentEntity toEntity() {
    return AppointmentEntity(
      id: id,
      specialist: specialist,
      dateTime: dateTime,
      status: status,
      notes: notes,
      createdAt: createdAt,
      cancelledAt: status == 'cancelled' ? updatedAt : null,
      cancellationReason: cancellationReason,
      updatedAt: updatedAt,
    );
  }

  static AppointmentModel fromEntity(AppointmentEntity entity, String userId) {
    return AppointmentModel(
      id: entity.id,
      userId: userId,
      specialistId: entity.specialist.id,
      specialist: entity.specialist,
      dateTime: entity.dateTime,
      status: entity.status,
      notes: entity.notes,
      cancellationReason: entity.cancellationReason,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
} 