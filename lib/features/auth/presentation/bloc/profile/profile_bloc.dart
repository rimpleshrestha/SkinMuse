import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_muse/features/auth/data/data_source/remote_datasource/auth_remote_data_source.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRemoteDataSource authRemoteDataSource;

  ProfileBloc({required this.authRemoteDataSource}) : super(ProfileInitial()) {
    on<UpdateName>(_onUpdateName);
    on<ChangePassword>(_onChangePassword);
    // Removed LoadProfile since backend endpoint is missing
  }

  Future<void> _onUpdateName(
    UpdateName event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final message = await authRemoteDataSource.updateName(event.name);
    if (message != null) {
      emit(ProfileSuccess(message));
    } else {
      emit(ProfileFailure("Failed to update name"));
    }
  }

  Future<void> _onChangePassword(
    ChangePassword event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final message = await authRemoteDataSource.changePassword(
      event.email,
      event.newPassword,
      event.confirmPassword,
    );
    if (message != null) {
      emit(ProfileSuccess(message));
    } else {
      emit(ProfileFailure("Failed to change password"));
    }
  }
}
