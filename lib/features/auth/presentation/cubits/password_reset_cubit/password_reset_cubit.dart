import 'package:appointify_app/features/auth/domain/repos/auth_repo.dart';
import 'package:appointify_app/features/auth/presentation/cubits/password_reset_cubit/password_reset_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appointify_app/core/errors/failures.dart';

class PasswordResetCubit extends Cubit<PasswordResetState> {
  PasswordResetCubit(this.authRepo) : super(PasswordResetInitial());
  final AuthRepo authRepo;
  String? email; // Store email

  Future<void> sendOtpEmail(String email) async {
    this.email = email;
    emit(PasswordResetLoading());
    try {
      await authRepo.sendOtpEmail(email);
      emit(PasswordResetOtpSent());
    } catch (e) {
      emit(PasswordResetFailure(message: "Failed to send OTP: ${e.toString()}"));
      print("Failed to send OTP: ${e.toString()}"); // Detailed logging
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    emit(PasswordResetLoading());
    try {
      await authRepo.verifyOtp(email, otp);
      emit(PasswordResetSuccess());
    } catch (e) {
      emit(PasswordResetFailure(message: "Failed to verify OTP: ${e.toString()}"));
      print("Failed to verify OTP: ${e.toString()}"); // Detailed logging
    }
  }

  Future<void> resendOtp(String email) async {
    emit(PasswordResetLoading());
    try {
      await authRepo.resendOtp(email);
      emit(PasswordResetOtpSent());
    } catch (e) {
      emit(PasswordResetFailure(message: "Failed to resend OTP: ${e.toString()}"));
      print("Failed to resend OTP: ${e.toString()}"); // Detailed logging
    }
  }

  Future<void> updatePassword(String email, String newPassword) async {
    emit(PasswordResetLoading());
    try {
      await authRepo.updatePasswordWithEmail(email, newPassword);
      emit(PasswordResetSuccess());
    } catch (e) {
      emit(PasswordResetFailure(message: "Failed to update password: ${e.toString()}"));
      print("Failed to update password: ${e.toString()}"); // Detailed logging
    }
  }

  // New method using Firebase's native password reset
  Future<void> sendPasswordResetEmail(String email) async {
    emit(PasswordResetLoading());
    final result = await authRepo.sendPasswordResetEmail(email);
    
    result.fold(
      (failure) {
        String errorMessage = (failure as ServerFailure).message;
        emit(PasswordResetFailure(message: errorMessage));
        print("Failed to send reset email: $errorMessage");
      },
      (_) {
        emit(PasswordResetEmailSent());
        print("Password reset email sent successfully to $email");
      }
    );
  }
}