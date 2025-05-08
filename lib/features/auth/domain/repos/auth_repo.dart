import 'package:appointify_app/core/errors/failures.dart';
import 'package:appointify_app/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepo {
   Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
       String email, String password, String name);

   Future<Either<Failure, void>> sendPasswordResetEmail(String email);

   Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
       String email, String password);

   Future<Either<Failure, UserEntity>> signInWithGoogle();
   Future<Either<Failure, UserEntity>> signInWithFacebook();
   Future<Either<Failure, UserEntity>> signInWithApple();

   Future<void> signOut();

   Future addUserData({required UserEntity user});
   Future saveUserData({required UserEntity user});
   Future<UserEntity> getUserData({required String uid});
   Future<Either<Failure, UserEntity>> updateUserProfile({required UserEntity user});
}
