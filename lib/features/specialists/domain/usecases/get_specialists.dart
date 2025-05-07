import 'package:appointify_app/features/categories/domain/entities/specialist_categories_entity.dart';
import 'package:appointify_app/features/specialists/domain/repos/specialist_repo.dart';

class GetSpecialists {
  final SpecialistRepository repository;

  GetSpecialists(this.repository);

  Future<List<Specialist>> call() async {
    return await repository.getAllSpecialists();
  }
}

class GetSpecialistsByCategory {
  final SpecialistRepository repository;

  GetSpecialistsByCategory(this.repository);

  Future<List<Specialist>> call(String category) async {
    return await repository.getSpecialistsByCategory(category);
  }
}

class GetPopularSpecialists {
  final SpecialistRepository repository;

  GetPopularSpecialists(this.repository);

  Future<List<Specialist>> call({int limit = 5}) async {
    return await repository.getPopularSpecialists(limit: limit);
  }
} 