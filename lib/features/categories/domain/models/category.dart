import 'package:flutter/material.dart';

enum CategoryType {
  medical,
  fitness,
  consulting,
  education,
  therapy,
  legal
}

class Category {
  final String id;
  final String name;
  final CategoryType type;
  final List<String> specializations;

  Category({
    required this.id,
    required this.name,
    required this.type,
    required this.specializations,
  });

  IconData get icon {
    switch (type) {
      case CategoryType.medical:
        return Icons.medical_services;
      case CategoryType.fitness:
        return Icons.fitness_center;
      case CategoryType.consulting:
        return Icons.business;
      case CategoryType.education:
        return Icons.school;
      case CategoryType.therapy:
        return Icons.psychology;
      case CategoryType.legal:
        return Icons.gavel;
      default:
        return Icons.category;
    }
  }
}

// Sample categories data
final List<Category> categories = [
  Category(
    id: '1',
    name: 'Medical',
    type: CategoryType.medical,
    specializations: [
      'Cardiologist',
      'Dentist',
      'Dermatologist',
      'General Physician',
      'Pediatrician',
    ],
  ),
  Category(
    id: '2',
    name: 'Fitness',
    type: CategoryType.fitness,
    specializations: [
      'Personal Trainer',
      'Yoga Instructor',
      'Nutritionist',
      'Sports Coach',
    ],
  ),
  Category(
    id: '3',
    name: 'Consulting',
    type: CategoryType.consulting,
    specializations: [
      'Business Consultant',
      'Career Coach',
      'Financial Advisor',
      'Marketing Consultant',
    ],
  ),
  Category(
    id: '4',
    name: 'Education',
    type: CategoryType.education,
    specializations: [
      'Academic Tutor',
      'Language Teacher',
      'Music Teacher',
      'Test Prep Coach',
    ],
  ),
  Category(
    id: '5',
    name: 'Therapy & Legal',
    type: CategoryType.therapy,
    specializations: [
      'Psychologist',
      'Lawyer',
      'Family Therapist',
      'Life Coach',
    ],
  ),
]; 