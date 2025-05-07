import 'package:intl/intl.dart';

class SpecialistEntity {
  final String id;
  final String name;
  final String specialization;
  final String category;
  final String bio;
  final List<WorkingDayEntity> workingDays;
  final String imageUrl;
  final double rating;
  final int reviewsCount;
  final bool isAvailable;

  SpecialistEntity({
    required this.id,
    required this.name,
    required this.specialization,
    required this.category,
    required this.bio,
    required this.workingDays,
    required this.imageUrl,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.isAvailable = true,
  });

  SpecialistEntity copyWith({
    String? id,
    String? name,
    String? specialization,
    String? category,
    String? bio,
    List<WorkingDayEntity>? workingDays,
    String? imageUrl,
    double? rating,
    int? reviewsCount,
    bool? isAvailable,
    double? pricePerHour,
    String? location,
    double? latitude,
    double? longitude,
  }) {
    return SpecialistEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      specialization: specialization ?? this.specialization,
      category: category ?? this.category,
      bio: bio ?? this.bio,
      workingDays: workingDays ?? this.workingDays,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'category': category,
      'bio': bio,
      'workingDays': workingDays.map((day) => day.toJson()).toList(),
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'isAvailable': isAvailable,
    };
  }

  factory SpecialistEntity.fromJson(Map<String, dynamic> json) {
    return SpecialistEntity(
      id: json['id'],
      name: json['name'],
      specialization: json['specialization'],
      category: json['category'],
      bio: json['bio'],
      workingDays: (json['workingDays'] as List)
          .map((day) => WorkingDayEntity.fromJson(day))
          .toList(),
      imageUrl: json['imageUrl'],
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewsCount: json['reviewsCount'] ?? 0,
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  bool isAvailableOn(DateTime date) {
    if (!isAvailable) return false;

    final dayOfWeek = date.weekday;
    final time = DateFormat('HH:mm').format(date);

    return workingDays.any((workingDay) {
      final dayIndex = _getDayIndex(workingDay.day);
      return dayIndex == dayOfWeek &&
          time.compareTo(workingDay.startTime) >= 0 &&
          time.compareTo(workingDay.endTime) <= 0;
    });
  }

  int _getDayIndex(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return 1;
      case 'tuesday':
        return 2;
      case 'wednesday':
        return 3;
      case 'thursday':
        return 4;
      case 'friday':
        return 5;
      case 'saturday':
        return 6;
      case 'sunday':
        return 7;
      default:
        return 0;
    }
  }
}

class WorkingDayEntity {
  final String day;
  final String startTime;
  final String endTime;

  WorkingDayEntity({
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  factory WorkingDayEntity.fromJson(Map<String, dynamic> json) {
    return WorkingDayEntity(
      day: json['day'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }
} 