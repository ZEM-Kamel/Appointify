import 'package:appointify_app/core/utils/app_text_styles.dart';
import 'package:appointify_app/features/specialists/data/mock_data/mock_specialists.dart';
import 'package:appointify_app/features/categories/presentation/views/categories_screen.dart';
import 'package:appointify_app/features/specialists/presentation/views/widgets/popular_specialist_card.dart';
import 'package:appointify_app/features/search/presentation/views/search_results_screen.dart';
import 'package:appointify_app/features/search/presentation/views/widgets/filter_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appointify_app/constants.dart';
import 'package:appointify_app/core/widgets/search_text_field.dart';
import 'package:appointify_app/features/home/presentation/views/widgets/custom_home_app_bar.dart';
import 'package:appointify_app/features/specialists/domain/entities/specialist_entity.dart';
import 'package:appointify_app/features/specialists/presentation/views/specialist_details_screen.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({
    super.key,
  });

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  final TextEditingController _searchController = TextEditingController();
  List<SpecialistEntity> _filteredSpecialists = [];
  bool _isSearching = false;
  String _selectedCategory = 'All';
  double _selectedRating = 0.0;
  bool _showAvailableOnly = false;

  @override
  void initState() {
    super.initState();
    _filteredSpecialists = MockSpecialists.getPopularSpecialists();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterSpecialists(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _filteredSpecialists = MockSpecialists.getPopularSpecialists();
      } else {
        _filteredSpecialists = MockSpecialists.getAllSpecialists().where((specialist) {
          final name = specialist.name.toLowerCase();
          final specialization = specialist.specialization.toLowerCase();
          final category = specialist.category.toLowerCase();
          final searchQuery = query.toLowerCase();
          
          // Check if any part of the name matches the search query
          final nameParts = name.split(' ');
          final hasMatchingNamePart = nameParts.any((part) => part.startsWith(searchQuery));
          
          return hasMatchingNamePart || 
                 name.contains(searchQuery) || 
                 specialization.contains(searchQuery) ||
                 category.contains(searchQuery);
        }).toList();
      }
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredSpecialists = MockSpecialists.getAllSpecialists().where((specialist) {
        // Apply search filter first
        bool matchesSearch = true;
        if (_searchController.text.isNotEmpty) {
          final name = specialist.name.toLowerCase();
          final specialization = specialist.specialization.toLowerCase();
          final category = specialist.category.toLowerCase();
          final searchQuery = _searchController.text.toLowerCase();
          
          // Check if any part of the name matches the search query
          final nameParts = name.split(' ');
          final hasMatchingNamePart = nameParts.any((part) => part.startsWith(searchQuery));
          
          matchesSearch = hasMatchingNamePart || 
                         name.contains(searchQuery) || 
                         specialization.contains(searchQuery) ||
                         category.contains(searchQuery);
        }

        // Apply category filter
        final matchesCategory = _selectedCategory == 'All' || 
                              specialist.category.toLowerCase() == _selectedCategory.toLowerCase();

        // Apply rating filter
        final matchesRating = _selectedRating == 0.0 || 
                            specialist.rating >= _selectedRating;

        // Apply availability filter
        final matchesAvailability = !_showAvailableOnly || specialist.isAvailable;
        
        return matchesSearch && matchesCategory && matchesRating && matchesAvailability;
      }).toList();

      // Sort by rating if rating filter is applied
      if (_selectedRating > 0.0) {
        _filteredSpecialists.sort((a, b) => b.rating.compareTo(a.rating));
      }
    });
  }

  void _handleSearchSubmitted() {
    if (_searchController.text.isNotEmpty) {
      if (_filteredSpecialists.isNotEmpty) {
        Navigator.pushNamed(
          context,
          SearchResultsScreen.routeName,
          arguments: {
            'specialists': _filteredSpecialists,
            'searchQuery': _searchController.text,
          },
        ).then((_) {
          // Clear search field after navigation
          _searchController.clear();
          _filterSpecialists('');
        });
      } else {
        // Show no results message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No Specialists Found Matching "${_searchController.text}"',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _handleFilterPressed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: FilterOptions(
          onApplyFilters: (category, rating, availableOnly) {
            setState(() {
              _selectedCategory = category;
              _selectedRating = rating;
              _showAvailableOnly = availableOnly;
            });
            _applyFilters();
          },
          selectedCategory: _selectedCategory,
          selectedRating: _selectedRating,
          showAvailableOnly: _showAvailableOnly,
        ),
      ),
    );
  }

  void _navigateToSpecialistDetails(SpecialistEntity specialist) {
    Navigator.pushNamed(
      context,
      SpecialistDetailsScreen.routeName,
      arguments: specialist,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: kTopPaddding,
                ),
                CustomHomeAppBar().animate().fadeIn(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 200),
                ),
                SizedBox(
                  height: 16,
                ),
                SearchTextField(
                  controller: _searchController,
                  onChanged: _filterSpecialists,
                  onSearchSubmitted: _handleSearchSubmitted,
                  onFilterPressed: _handleFilterPressed,
                ).animate().fadeIn(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 400),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ).animate().fadeIn(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 600),
                ),
                const CategoriesScreen().animate().fadeIn(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 800),
                ),
                // Popular Specialists Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _isSearching ? 'Search Results' : 'Popular Specialists',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ).animate().fadeIn(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 1000),
                ),
                if (_filteredSpecialists.isEmpty && _isSearching)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                          ),
                          const SizedBox(height: 16),
                          Text(
                        'No Specialists Found',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try Different Keywords Or Adjust Filters',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredSpecialists.length,
                      itemBuilder: (context, index) {
                        final specialist = _filteredSpecialists[index];
                        return GestureDetector(
                          onTap: () => _navigateToSpecialistDetails(specialist),
                          child: PopularSpecialistCard(specialist: specialist),
                        );
                      },
                    ),
                  ).animate().fadeIn(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 1200),
                  ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}