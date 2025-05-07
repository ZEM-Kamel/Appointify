import 'package:appointify_app/features/specialists/domain/entities/working_day.dart';

class Specialist {
  final String id;
  final String name;
  final String specialization;
  final String category;
  final String bio;
  final List<WorkingDay> workingDays;
  final String imageUrl;
  final double rating;
  final int reviewsCount;
  final bool isAvailable;

  Specialist({
    required this.id,
    required this.name,
    required this.specialization,
    required this.category,
    required this.bio,
    required this.workingDays,
    required this.imageUrl,
    required this.rating,
    required this.reviewsCount,
    required this.isAvailable,
  });

  factory Specialist.fromJson(Map<String, dynamic> json) {
    return Specialist(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      category: json['category'] ?? '',
      bio: json['bio'] ?? '',
      workingDays: (json['workingDays'] as List?)
          ?.map((day) => WorkingDay.fromJson(day))
          .toList() ?? [],
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviewsCount'] ?? 0,
      isAvailable: json['isAvailable'] ?? false,
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

  Specialist copyWith({
    String? id,
    String? name,
    String? specialization,
    String? category,
    String? bio,
    List<WorkingDay>? workingDays,
    String? imageUrl,
    double? rating,
    int? reviewsCount,
    bool? isAvailable,
  }) {
    return Specialist(
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
} 