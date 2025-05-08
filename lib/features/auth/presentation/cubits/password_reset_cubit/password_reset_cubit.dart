import 'package:appointify_app/features/auth/domain/repos/auth_repo.dart';
import 'package:appointify_app/features/auth/presentation/cubits/password_reset_cubit/password_reset_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appointify_app/core/errors/failures.dart';

class PasswordResetCubit extends Cubit<PasswordResetState> {
  PasswordResetCubit(this.authRepo) : super(PasswordResetInitial());
  final AuthRepo authRepo;
  String? email;

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