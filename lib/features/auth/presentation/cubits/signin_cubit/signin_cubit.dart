import 'package:appointify_app/core/services/navigation_service.dart';
import 'package:appointify_app/features/auth/domain/entities/user_entity.dart';
import 'package:appointify_app/features/auth/domain/repos/auth_repo.dart';
import 'package:appointify_app/features/auth/presentation/views/signin_view.dart';
import 'package:appointify_app/features/home/presentation/views/main_layout.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'signin_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this.authRepo) : super(SignInInitial());
  final AuthRepo authRepo;

  Future<void> signIn(String email, String password) async {
    emit(SignInLoading());
    var result = await authRepo.signInWithEmailAndPassword(
      email,
      password,
    );
    result.fold(
          (failure) => emit(SignInFailure(message: failure.message)),
      (userEntity) {
        emit(SignInSuccess(userEntity: userEntity));
        // Navigate to main layout after successful login
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamedAndRemoveUntil(
            NavigationService.context!,
            MainLayout.routeName,
            (route) => false,
          );
        });
      },
    );
  }

  Future<void> signInWithGoogle() async {
    emit(SignInLoading());
    var result = await authRepo.signInWithGoogle();
    result.fold(
          (failure) => emit(SignInFailure(message: failure.message)),
      (userEntity) {
        emit(SignInSuccess(userEntity: userEntity));
        // Navigate to main layout after successful login
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamedAndRemoveUntil(
            NavigationService.context!,
            MainLayout.routeName,
            (route) => false,
          );
        });
      },
    );
  }

  Future<void> signInWithFacebook() async {
    emit(SignInLoading());
    var result = await authRepo.signInWithFacebook();
    result.fold(
          (failure) => emit(SignInFailure(message: failure.message)),
      (userEntity) {
        emit(SignInSuccess(userEntity: userEntity));
        // Navigate to main layout after successful login
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamedAndRemoveUntil(
            NavigationService.context!,
            MainLayout.routeName,
            (route) => false,
          );
        });
      },
    );
  }

  Future<void> signInWithApple() async {
    emit(SignInLoading());
    var result = await authRepo.signInWithApple();
    result.fold(
          (failure) => emit(SignInFailure(message: failure.message)),
      (userEntity) {
        emit(SignInSuccess(userEntity: userEntity));
        // Navigate to main layout after successful login
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamedAndRemoveUntil(
            NavigationService.context!,
            MainLayout.routeName,
            (route) => false,
          );
        });
      },
    );
  }

  Future<void> signOut() async {
    emit(SignOutLoading());
    try {
      await authRepo.signOut();
      emit(SignOutSuccess());
      
      // Navigate to sign in view after successful logout
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (NavigationService.context != null) {
          Navigator.pushNamedAndRemoveUntil(
            NavigationService.context!,
            SignInView.routeName,
            (route) => false,
          );
        }
      });
    } catch (e) {
      print('Error during sign out: $e');
      emit(SignOutFailure(message: e.toString()));
    }
  }
}