import 'dart:developer';

import 'package:appointify_app/features/auth/domain/entities/user_entity.dart';
import 'package:appointify_app/features/auth/domain/repos/auth_repo.dart';
import 'package:appointify_app/features/profile/presentation/cubits/profile_edit_cubit/profile_edit_state.dart';
import 'package:bloc/bloc.dart';

class ProfileEditCubit extends Cubit<ProfileEditState> {
  final AuthRepo authRepo;

  ProfileEditCubit({required this.authRepo}) : super(ProfileEditInitial());

  Future<void> updateUserProfile(UserEntity user) async {
    emit(ProfileEditLoading());
    
    try {
      final result = await authRepo.updateUserProfile(user: user);
      
      result.fold(
        (failure) {
          emit(ProfileEditFailure(message: failure.message));
          log('Failed to update profile: ${failure.message}');
        },
        (updatedUser) {
          emit(ProfileEditSuccess(user: updatedUser));
          log('Profile updated successfully');
        },
      );
    } catch (e) {
      emit(ProfileEditFailure(message: 'An unexpected error occurred.'));
      log('Error in updateUserProfile: ${e.toString()}');
    }
  }
}
