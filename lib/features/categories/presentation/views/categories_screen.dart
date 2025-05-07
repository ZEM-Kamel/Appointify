import 'package:appointify_app/core/theme/theme_constants.dart';
import 'package:appointify_app/features/specialists/presentation/views/specialists_list_screen.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  static const String routeName = '/categories';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCard(context, category);
      },
    );
  }

  Widget _buildCategoryCard(BuildContext context, String category) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          SpecialistsListScreen.routeName,
          arguments: category,
        );
      },
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getCategoryIcon(category),
              size: 40,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              category,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Medical':
        return Icons.medical_services;
      case 'Fitness':
        return Icons.fitness_center;
      case 'Consulting':
        return Icons.business;
      case 'Education':
        return Icons.school;
      case 'Therapy':
        return Icons.psychology;
      case 'Legal':
        return Icons.gavel;
      default:
        return Icons.category;
    }
  }

  static const List<String> categories = [
    'Medical',
    'Fitness',
    'Consulting',
    'Education',
    'Therapy',
    'Legal',
  ];
} 