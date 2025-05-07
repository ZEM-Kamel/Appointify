import 'package:dartz/dartz.dart';
import '../../../specialists/domain/entities/specialist_entity.dart';

abstract class CategoriesRepo {
  Future<Either<Failure, List<SpecialistEntity>>> getSpecialistsByCategory(String category);
  Future<Either<Failure, SpecialistEntity>> getSpecialistById(String id);
}

class Failure {
  final String message;
  Failure(this.message);
} 