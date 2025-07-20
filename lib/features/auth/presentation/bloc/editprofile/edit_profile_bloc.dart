import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_muse/features/auth/data/data_source/remote_datasource/auth_remote_data_source.dart';
import 'edit_profile_event.dart';
import 'edit_profile_state.dart';


class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final AuthRemoteDataSource dataSource;

  EditProfileBloc(this.dataSource) : super(EditProfileInitial()) {
    on<UpdateNamePressed>(_onUpdateName);
    on<ChangePasswordPressed>(_onChangePassword);
    on<UpdateProfilePhotoPressed>(_onUpdateProfilePhoto);
  }

  Future<void> _onUpdateName(
    UpdateNamePressed event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(EditProfileLoading());
    final result = await dataSource.updateName(event.name);
    if (result != null) {
      emit(EditProfileSuccess(result));
    } else {
      emit(EditProfileFailure('Failed to update name'));
    }
  }

  Future<void> _onChangePassword(
    ChangePasswordPressed event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(EditProfileLoading());
    final result = await dataSource.changePassword(
      event.currentPassword,
      event.newPassword,
    );
    if (result != null) {
      emit(EditProfileSuccess(result));
    } else {
      emit(EditProfileFailure('Failed to change password'));
    }
  }

  Future<void> _onUpdateProfilePhoto(
    UpdateProfilePhotoPressed event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(EditProfileLoading());
    final result = await dataSource.uploadProfilePhoto(File(event.imagePath));
    if (result != null) {
      emit(EditProfileSuccess(result));
    } else {
      emit(EditProfileFailure('Failed to update photo'));
    }
  }
}
