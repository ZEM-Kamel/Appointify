import 'package:appointify_app/features/auth/domain/entities/user_entity.dart';
import 'package:flutter/cupertino.dart';

@immutable
sealed class SignupState {}

final class SignupInitial extends SignupState {}

final class SignupLoading extends SignupState {}

final class SignupSuccess extends SignupState {
  final UserEntity userEntity;

  SignupSuccess({required this.userEntity});
}

final class SignupFailure extends SignupState {
  final String message;
  SignupFailure({required this.message});
}
