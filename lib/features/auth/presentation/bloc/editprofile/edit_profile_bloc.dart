import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_muse/features/auth/data/data_source/remote_datasource/auth_remote_data_source.dart';
import 'package:skin_muse/features/auth/data/model/user_hive_model.dart';
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
      // Save updated username locally in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', event.name);

      // Update Hive cache if user exists
      final box = await Hive.openBox<UserHiveModel>('users');
      if (box.isNotEmpty) {
        final cachedUser = box.getAt(0);
        if (cachedUser != null) {
          final updatedUser = cachedUser.copyWith(
            name: event.name,
            firstName: event.name.split(' ').first,
            lastName:
                event.name.split(' ').length > 1
                    ? event.name.split(' ').sublist(1).join(' ')
                    : '',
          );
          await box.putAt(0, updatedUser);
        }
      }

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
      event.email,
      event.newPassword,
      event.confirmPassword,
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
