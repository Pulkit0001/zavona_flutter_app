import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zavona_flutter_app/core/presentation/blocs/e_states.dart';
import 'package:zavona_flutter_app/domain/models/auth/my_profile_response.dart';
import 'package:zavona_flutter_app/domain/repositories/auth_repository.dart';
import 'package:zavona_flutter_app/presentation/app/bloc/app_state.dart';
import 'package:zavona_flutter_app/third_party_services/location_service.dart';
import 'package:zavona_flutter_app/third_party_services/secure_storage_service.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState()) {
    _checkAuthentication();
  }

  final AuthRepository _authRepository = AuthRepository();

  Future<void> _checkAuthentication() async {
    try {
      emit(state.copyWith(eViewState: EViewState.loading));
      var res = await LocalStorage.getAccessToken();
      var userData = await LocalStorage.getUserData();
      emit(
        state.copyWith(
          isAuthenticated: (res != null && res.isNotEmpty),
          eViewState: EViewState.loaded,
          user: userData != null ? User.fromJson(userData) : null,
        ),
      );
      getProfileData();
    } catch (e) {
      emit(
        state.copyWith(isAuthenticated: false, eViewState: EViewState.error),
      );
    }
  }

  Future<void> getProfileData() async {
    try {
      var res = await _authRepository.getMyProfile();
      if (res.data?.user != null) {
        emit(
          state.copyWith(
            user: res.data!.user!,
            eViewState: EViewState.loaded,
            isAuthenticated: true,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(eViewState: EViewState.error));
    }
  }
}
