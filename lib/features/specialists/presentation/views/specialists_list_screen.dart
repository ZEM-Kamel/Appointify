import 'package:appointify_app/features/specialists/data/mock_data/mock_specialists.dart';
import 'package:flutter/material.dart';
import 'package:appointify_app/features/specialists/domain/entities/specialist_entity.dart';
import 'package:appointify_app/features/specialists/presentation/views/specialist_details_screen.dart';
import 'package:appointify_app/core/theme/theme_constants.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/widgets/custom_app_bar.dart';

class SpecialistsListScreen extends StatelessWidget {
  const SpecialistsListScreen({
    super.key,
    required this.category,
  });

  final String category;
  static const String routeName = '/specialists-list';

  List<SpecialistEntity> _getSpecialistsForCategory() {
    switch (category) {
      case 'Medical':
        return MockSpecialists.getMedicalSpecialists();
      case 'Fitness':
        return MockSpecialists.getFitnessSpecialists();
      case 'Consulting':
        return MockSpecialists.getConsultingSpecialists();
      case 'Education':
        return MockSpecialists.getEducationSpecialists();
      case 'Therapy':
        return MockSpecialists.getTherapySpecialists();
      case 'Legal':
        return MockSpecialists.getLegalSpecialists();
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final specialists = _getSpecialistsForCategory();

    return Scaffold(
      appBar: buildAppBar(context, title: category, showSettingsButton: false),
      body: specialists.isEmpty
          ? Center(
              child: Text(
                'No Specialists Found In This Category',
                style: theme.textTheme.bodyLarge,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: specialists.length,
              itemBuilder: (context, index) {
                final specialist = specialists[index];
                return _buildSpecialistCard(context, specialist).animate().fadeIn(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 200),
                );
              },
            ),
    );
  }

  Widget _buildSpecialistCard(BuildContext context, SpecialistEntity specialist) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          SpecialistDetailsScreen.routeName,
          arguments: specialist,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(ThemeConstants.borderRadius),
              ),
              child: Image.network(
                specialist.imageUrl,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120,
                    height: 120,
                    color: theme.colorScheme.surfaceVariant,
                    child: Icon(
                      Icons.person,
                      size: 100,
                      color: theme.colorScheme.primary,
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      specialist.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      specialist.specialization,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      specialist.bio,
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 10),
                        Wrap(
                          spacing: 8,
                          children: specialist.workingDays.map((day) {
                            return Chip(
                              label: Text(
                                day.day.substring(0, 3).toUpperCase(),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                              padding: EdgeInsets.zero,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 