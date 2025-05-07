import 'package:appointify_app/core/services/firebase_service.dart';
import 'package:appointify_app/features/specialists/data/datasources/specialist_remote_data_source.dart';

class SpecialistRemoteDataSourceImpl implements SpecialistRemoteDataSource {
  @override
  Future<List<Map<String, dynamic>>> getAllSpecialists() async {
    try {
      final snapshot = await FirebaseService.specialistsCollection.get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error getting all specialists: $e');
      return [];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getSpecialistsByCategory(String category) async {
    try {
      final snapshot = await FirebaseService.specialistsCollection
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error getting specialists by category: $e');
      return [];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> searchSpecialists(String query) async {
    return FirebaseService.searchSpecialists(query);
  }

  @override
  Future<List<Map<String, dynamic>>> getPopularSpecialists({int limit = 5}) async {
    try {
      final snapshot = await FirebaseService.specialistsCollection
          .orderBy('rating', descending: true)
          .limit(limit)
          .get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error getting popular specialists: $e');
      return [];
    }
  }
} 