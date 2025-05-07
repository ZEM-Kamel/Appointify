import 'package:appointify_app/features/auth/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileEditState extends Equatable {
  const ProfileEditState();

  @override
  List<Object?> get props => [];
}

class ProfileEditInitial extends ProfileEditState {}

class ProfileEditLoading extends ProfileEditState {}

class ProfileEditSuccess extends ProfileEditState {
  final UserEntity user;

  const ProfileEditSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class ProfileEditFailure extends ProfileEditState {
  final String message;

  const ProfileEditFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
