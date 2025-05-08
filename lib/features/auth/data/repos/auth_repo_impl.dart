import 'dart:convert';
import 'dart:developer';
import 'dart:math' show Random;
import 'package:appointify_app/features/auth/domain/entities/user_entity.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:appointify_app/constants.dart';
import 'package:appointify_app/core/errors/exceptions.dart';
import 'package:appointify_app/core/errors/failures.dart';
import 'package:appointify_app/core/services/database_service.dart';
import 'package:appointify_app/core/services/firebase_auth_service.dart';
import 'package:appointify_app/core/services/shared_preferences_singleton.dart';
import 'package:appointify_app/core/utils/backend_endpoint.dart';
import 'package:appointify_app/features/auth/data/models/user_model.dart';
import 'package:appointify_app/features/auth/domain/repos/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  final Map<String, String> otpStore = {};
  final DatabaseService databaseService;


  AuthRepoImpl(
      {required this.databaseService, required this.firebaseAuthService});

  @override
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    User? user;
    try {
      user = await firebaseAuthService.createUserWithEmailAndPassword(
          email: email, password: password);
      var userEntity = UserEntity(
        name: name,
        email: email,
        uId: user.uid,
      );
      await addUserData(user: userEntity);
      return right(userEntity);
    } on CustomException catch (e) {
      await deleteUser(user);
      return left(ServerFailure(e.messageKey));
    } catch (e) {
      await deleteUser(user);
      log(
        'Exception in AuthRepoImpl.createUserWithEmailAndPassword: ${e.toString()}',
      );
      return left(
          ServerFailure(
            'An error occurred. Please try again later.',
          ),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      var user = await firebaseAuthService.signInWithEmailAndPassword(
          email: email, password: password);
      var userEntity = await getUserData(uid: user.uid);
      await saveUserData(user: userEntity);
      return right(
        userEntity,
      );
    } on CustomException catch (e) {
      return left(ServerFailure(e.messageKey));
    } catch (e) {
      log(
        'Exception in AuthRepoImpl.signInWithEmailAndPassword: ${e.toString()}',
      );
      return left(
        ServerFailure(
          'An error occurred. Please try again later.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    User? user;
    try {
      user = await firebaseAuthService.signInWithGoogle();
      return await _handleSocialSignIn(user);
    } catch (e) {
      await deleteUser(user);
      log('Exception in AuthRepoImpl.signInWithGoogle: ${e.toString()}');
      return left(ServerFailure('An error occurred. Please try again later.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithFacebook() async {
    User? user;
    try {
      user = await firebaseAuthService.signInWithFacebook();
      return await _handleSocialSignIn(user);
    } catch (e) {
      await deleteUser(user);
      log('Exception in AuthRepoImpl.signInWithFacebook: ${e.toString()}');
      return left(ServerFailure('An error occurred. Please try again later.'));
    }
  }
  @override
  Future<Either<Failure, UserEntity>> signInWithApple() async {
    User? user;
    try {
      user = await firebaseAuthService.signInWithApple();
      return await _handleSocialSignIn(user);
    } catch (e) {
      await deleteUser(user);
      log('Exception in AuthRepoImpl.signInWithApple: ${e.toString()}');
      return left(ServerFailure('An error occurred. Please try again later.'));
    }
  }

  @override
  Future addUserData({required UserEntity user}) async {
    await databaseService.addData(
      path: BackendEndpoint.addUserData,
      data: UserModel.fromEntity(user).toMap(),
      documentId: user.uId,
    );
  }

  @override
  Future<UserEntity> getUserData({required String uid}) async {
    var userData = await databaseService.getData(
        path: BackendEndpoint.getUsersData, documentId: uid);
    return UserModel.fromJson(userData);
  }

  @override
  Future saveUserData({required UserEntity user}) async {
    var jsonData = jsonEncode(UserModel.fromEntity(user).toMap());
    await Prefs.setString(kUserData, jsonData);
  }

  /// Deletes the current user account if it exists
  Future<void> deleteUser(User? user) async {
    if (user != null) {
      await firebaseAuthService.deleteUser();
    }
  }
  
  /// Helper method to handle social sign-in flow consistently
  Future<Either<Failure, UserEntity>> _handleSocialSignIn(User user) async {
    try {
      var userEntity = UserModel.fromFirebaseUser(user);
      
      // Check if user exists in our database
      var isUserExist = await databaseService.checkIfDataExists(
          path: BackendEndpoint.isUserExists, documentId: user.uid);
          
      if (isUserExist) {
        // If user exists, get their data
        final userData = await getUserData(uid: user.uid);
        userEntity = UserModel.fromEntity(userData);
      } else {
        // If user doesn't exist, add them to our database
        await addUserData(user: userEntity);
      }
      
      // Save user data to local storage
      await saveUserData(user: userEntity);
      
      return right(userEntity);
    } catch (e) {
      log('Exception in _handleSocialSignIn: ${e.toString()}');
      return left(ServerFailure('Failed to complete sign-in. Please try again.'));
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Sign out from Firebase Auth and other providers
      await firebaseAuthService.signOut();
      
      // Clear user data from SharedPreferences
      await Prefs.remove(kUserData);
      
      print('Successfully cleared user data from SharedPreferences');
    } catch (e) {
      print('Error during sign out: $e');
      throw Exception('Error signing out: ${e.toString()}');
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuthService.sendPasswordResetEmail(email);
      return right(null);
    } on FirebaseAuthException catch (e) {
      log('Firebase auth exception in sendPasswordResetEmail: ${e.code} - ${e.message}');
      String errorMessage;
      
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email address.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        default:
          errorMessage = 'Failed to send password reset email. Please try again later.';
      }
      
      return left(ServerFailure(errorMessage));
    } catch (e) {
      log('Exception in sendPasswordResetEmail: ${e.toString()}');
      return left(ServerFailure('An error occurred. Please try again later.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserProfile({required UserEntity user}) async {
    try {
      // Check if the current user is authenticated
      final currentUser = firebaseAuthService.getCurrentUser();
      if (currentUser == null) {
        return left(ServerFailure('User not authenticated'));
      }
      
      // Update user display name if changed
      if (currentUser.displayName != user.name) {
        await currentUser.updateDisplayName(user.name);
      }
      
      // Update user data in Firestore
      await databaseService.updateData(
        path: BackendEndpoint.getUsersData,
        documentId: user.uId,
        data: {
          'name': user.name,
          // Email is not updated here as it requires email verification
          // Add any new profile fields here
        },
      );
      
      // Save updated user data to local storage
      await saveUserData(user: user);
      
      return right(user);
    } on FirebaseAuthException catch (e) {
      log('Firebase auth exception in updateUserProfile: ${e.code} - ${e.message}');
      return left(ServerFailure('Failed to update profile: ${e.message}'));
    } catch (e) {
      log('Exception in updateUserProfile: ${e.toString()}');
      return left(ServerFailure('An error occurred while updating your profile.'));
    }
  }
}