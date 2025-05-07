import 'dart:convert';
import 'package:appointify_app/constants.dart';
import 'package:appointify_app/core/services/shared_preferences_singleton.dart';
import 'package:appointify_app/features/auth/data/models/user_model.dart';
import 'package:appointify_app/features/auth/domain/entities/user_entity.dart';

UserEntity? getUser() {
  try {
    final jsonString = Prefs.getString(kUserData);
    
    // Check if the string is empty or null
    if (jsonString.isEmpty) {
      print('User data not found in SharedPreferences');
      return null;
    }
    
    // Try to parse the JSON
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);
    if (jsonData.isEmpty) {
      print('Empty user data in SharedPreferences');
      return null;
    }
    
    return UserModel.fromJson(jsonData);
  } catch (e) {
    print('Error getting user data: $e');
    return null;
  }
}