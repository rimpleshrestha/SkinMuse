import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:skin_muse/features/auth/data/model/user_hive_model.dart';
import 'package:skin_muse/features/auth/data/data_source/remote_datasource/auth_remote_data_source.dart';
import 'package:skin_muse/features/auth/data/data_source/remote_datasource/rating_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRemoteDataSource authRemoteDataSource;
  final RatingRepository ratingRepository;

  String? _lastToken;

  ProfileBloc({
    required this.authRemoteDataSource,
    required this.ratingRepository,
  }) : super(ProfileInitial()) {
    on<UpdateName>(_onUpdateName);
    on<ChangePassword>(_onChangePassword);
    on<LoadRating>(_onLoadRating);
    on<UpdateRating>(_onUpdateRating);
    on<LoadUserProfile>(_onLoadUserProfile);
  }

  Future<void> _onUpdateName(
    UpdateName event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final message = await authRemoteDataSource.updateName(event.name);
      if (message != null) {
        emit(ProfileSuccess(message));
        // Reload user profile after name update
        add(LoadUserProfile());
      } else {
        emit(ProfileFailure("Failed to update name"));
      }
    } catch (e) {
      emit(ProfileFailure("Error updating name: $e"));
    }
  }

  Future<void> _onChangePassword(
    ChangePassword event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
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
    } catch (e) {
      emit(ProfileFailure("Error changing password: $e"));
    }
  }

  Future<void> _onLoadRating(
    LoadRating event,
    Emitter<ProfileState> emit,
  ) async {
    emit(RatingLoading());
    try {
      final token = await ratingRepository.getToken();
      if (token == null) {
        _lastToken = null;
        emit(RatingLoaded(0.0));
        return;
      }

      if (_lastToken != token) {
        _lastToken = token;
        emit(RatingLoaded(0.0));
      }

      final rating = await ratingRepository.getUserRating();
      emit(RatingLoaded(rating));
    } catch (e) {
      emit(ProfileFailure("Failed to load rating: $e"));
    }
  }

  Future<void> _onUpdateRating(
    UpdateRating event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await ratingRepository.saveUserRating(event.rating);
      emit(RatingLoaded(event.rating));
    } catch (e) {
      emit(ProfileFailure("Failed to update rating: $e"));
    }
  }

  /// Fetch user details & update Hive without unnecessary snackbar errors
  Future<void> _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      // Load cached user first
      final box = Hive.box<UserHiveModel>('users');
      String cachedName = "User";
      if (box.isNotEmpty) {
        final cachedUser = box.getAt(0);
        if (cachedUser?.name != null && cachedUser!.name!.isNotEmpty) {
          cachedName = cachedUser.name!;
        }
      }

      // Fetch latest profile from API
      final user = await authRemoteDataSource.getProfile();
      if (user != null) {
        // Update Hive with fetched name
        if (box.isNotEmpty) {
          final currentUser = box.getAt(0);
          if (currentUser != null) {
            final updated = currentUser.copyWith(
              name: user['name'] ?? currentUser.name,
            );
            await box.putAt(0, updated);
          }
        }
        emit(ProfileLoaded(user['name'] ?? cachedName));
      } else {
        // API failed but we have cached name
        emit(ProfileLoaded(cachedName));
      }
    } catch (e) {
      // On exception, use cached name instead of failure
      final box = Hive.box<UserHiveModel>('users');
      if (box.isNotEmpty) {
        final cachedUser = box.getAt(0);
        emit(ProfileLoaded(cachedUser?.name ?? "User"));
      } else {
        emit(ProfileFailure("Error fetching profile: $e"));
      }
    }
  }
}
