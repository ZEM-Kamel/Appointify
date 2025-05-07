import 'package:flutter/material.dart';

@immutable
sealed class PasswordResetState {}

final class PasswordResetInitial extends PasswordResetState {}

final class PasswordResetLoading extends PasswordResetState {}

final class PasswordResetSuccess extends PasswordResetState {}

final class PasswordResetFailure extends PasswordResetState {
  final String message;

  PasswordResetFailure({required this.message});
}

final class PasswordResetOtpSent extends PasswordResetState {}

final class PasswordResetEmailSent extends PasswordResetState {}
