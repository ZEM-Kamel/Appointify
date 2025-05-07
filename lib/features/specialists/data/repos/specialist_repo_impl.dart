import 'package:appointify_app/features/categories/domain/entities/specialist_categories_entity.dart';
import 'package:appointify_app/features/specialists/domain/repos/specialist_repo.dart';
import 'package:appointify_app/features/specialists/data/datasources/specialist_remote_data_source.dart';

class SpecialistRepositoryImpl implements SpecialistRepository {
  final SpecialistRemoteDataSource remoteDataSource;

  SpecialistRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Specialist>> getAllSpecialists() async {
    final specialistsData = await remoteDataSource.getAllSpecialists();
    return specialistsData.map((data) => Specialist.fromJson(data)).toList();
  }

  @override
  Future<List<Specialist>> getSpecialistsByCategory(String category) async {
    final specialistsData = await remoteDataSource.getSpecialistsByCategory(category);
    return specialistsData.map((data) => Specialist.fromJson(data)).toList();
  }

  @override
  Future<List<Specialist>> searchSpecialists(String query) async {
    final specialistsData = await remoteDataSource.searchSpecialists(query);
    return specialistsData.map((data) => Specialist.fromJson(data)).toList();
  }

  @override
  Future<List<Specialist>> getPopularSpecialists({int limit = 5}) async {
    final specialistsData = await remoteDataSource.getPopularSpecialists(limit: limit);
    return specialistsData.map((data) => Specialist.fromJson(data)).toList();
  }
} 