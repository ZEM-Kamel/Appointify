import 'package:appointify_app/features/categories/domain/entities/specialist_categories_entity.dart';

abstract class SpecialistRepository {
  Future<List<Specialist>> getAllSpecialists();
  Future<List<Specialist>> getSpecialistsByCategory(String category);
  Future<List<Specialist>> searchSpecialists(String query);
  Future<List<Specialist>> getPopularSpecialists({int limit = 5});
}

