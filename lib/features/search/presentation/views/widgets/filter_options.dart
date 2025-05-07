import 'package:appointify_app/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:appointify_app/core/theme/theme_constants.dart';
import 'package:appointify_app/core/utils/app_colors.dart';

class FilterOptions extends StatefulWidget {
  final Function(String category, double rating, bool availableOnly) onApplyFilters;
  final String selectedCategory;
  final double selectedRating;
  final bool showAvailableOnly;

  const FilterOptions({
    super.key,
    required this.onApplyFilters,
    this.selectedCategory = 'All',
    this.selectedRating = 0.0,
    this.showAvailableOnly = false,
  });

  @override
  State<FilterOptions> createState() => _FilterOptionsState();
}

class _FilterOptionsState extends State<FilterOptions> {
  late String _selectedCategory;
  late double _selectedRating;
  late bool _showAvailableOnly;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
    _selectedRating = widget.selectedRating;
    _showAvailableOnly = widget.showAvailableOnly;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filter Results', style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              )),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedCategory = 'All';
                    _selectedRating = 0.0;
                    _showAvailableOnly = false;
                  });
                },
                child: Text('Reset', style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                )),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Category', style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          )),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'All',
              'Medical',
              'Fitness',
              'Consulting',
              'Education',
              'Therapy',
              'Legal',
            ].map((category) {
              final isSelected = _selectedCategory == category;
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                checkmarkColor: isDark 
                    ? theme.colorScheme.onPrimary 
                    : AppColors.primaryColor,
                backgroundColor: theme.colorScheme.surfaceVariant,
                selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                labelStyle: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected 
                      ? theme.colorScheme.primary 
                      : theme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
                  side: BorderSide(
                    color: isSelected 
                        ? theme.colorScheme.primary 
                        : theme.colorScheme.outline.withOpacity(0.2),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text('Minimum Rating', style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          )),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _selectedRating,
                  min: 0,
                  max: 5,
                  divisions: 5,
                  label: _selectedRating.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      _selectedRating = value;
                    });
                  },
                ),
              ),
              Text(
                _selectedRating.toStringAsFixed(1),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text('Available Only', style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            )),
            value: _showAvailableOnly,
            onChanged: (value) {
              setState(() {
                _showAvailableOnly = value;
              });
            },
            activeColor: theme.colorScheme.primary,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
                onPressed: () {
                  widget.onApplyFilters(
                    _selectedCategory,
                    _selectedRating,
                    _showAvailableOnly,
                  );
                  Navigator.pop(context);
                },
              text: 'Apply Filters',
            ),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
} 