import 'package:flutter/material.dart';
import 'package:appointify_app/core/utils/app_text_styles.dart';
import 'package:appointify_app/features/specialists/domain/entities/specialist_entity.dart';
import 'package:appointify_app/features/specialists/presentation/views/widgets/specialist_card.dart';
import 'package:appointify_app/core/widgets/custom_app_bar.dart';
import 'package:appointify_app/features/specialists/presentation/views/specialist_details_screen.dart';

class SearchResultsScreen extends StatelessWidget {
  static const String routeName = '/search-results';
  
  final List<SpecialistEntity> specialists;
  final String searchQuery;

  const SearchResultsScreen({
    super.key,
    required this.specialists,
    required this.searchQuery,
  });

  void _navigateToSpecialistDetails(BuildContext context, SpecialistEntity specialist) {
    Navigator.pushNamed(
      context,
      SpecialistDetailsScreen.routeName,
      arguments: specialist,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context,
        title: 'Search Results',
        showSettingsButton: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Results for "$searchQuery"',
              style: TextStyles.regular16.copyWith(color: Colors.grey),
            ),
          ),
          Expanded(
            child: specialists.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No Specialists Found',
                          style: TextStyles.semiBold16.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try Different Keywords',
                          style: TextStyles.regular13.copyWith(
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: specialists.length,
                    itemBuilder: (context, index) {
                      final specialist = specialists[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: SpecialistCard(
                          specialist: specialist,
                          onTap: () => _navigateToSpecialistDetails(context, specialist),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
} 