import 'package:appointify_app/features/categories/domain/entities/specialist_categories_entity.dart';

abstract class SpecialistRemoteDataSource {
  Future<List<Map<String, dynamic>>> getAllSpecialists();
  Future<List<Map<String, dynamic>>> getSpecialistsByCategory(String category);
  Future<List<Map<String, dynamic>>> searchSpecialists(String query);
  Future<List<Map<String, dynamic>>> getPopularSpecialists({int limit = 5});
} 