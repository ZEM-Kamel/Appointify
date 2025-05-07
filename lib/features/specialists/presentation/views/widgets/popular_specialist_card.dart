import 'package:flutter/material.dart';
import 'package:appointify_app/core/theme/theme_constants.dart';
import 'package:appointify_app/features/specialists/domain/entities/specialist_entity.dart';
import 'package:appointify_app/features/specialists/presentation/views/specialist_details_screen.dart';

class PopularSpecialistCard extends StatelessWidget {
  const PopularSpecialistCard({
    super.key,
    required this.specialist,
  });

  final SpecialistEntity specialist;

  @override
  Widget build(BuildContext context) {
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
        width: 160,
        margin: const EdgeInsets.only(right: 16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(ThemeConstants.borderRadius)),
              child: Image.network(
                specialist.imageUrl,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 100,
                    color: theme.colorScheme.surfaceVariant,
                    child: Center(
                      child: Icon(
                        Icons.person,
                        size: 100,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    specialist.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    specialist.specialization,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 