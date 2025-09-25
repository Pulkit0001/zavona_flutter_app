import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zavona_flutter_app/core/domain/session_manager.dart';
import 'package:zavona_flutter_app/core/locator.dart';
import 'package:zavona_flutter_app/core/presentation/blocs/e_states.dart';
import 'package:zavona_flutter_app/domain/models/auth/my_profile_response.dart';
import 'package:zavona_flutter_app/domain/repositories/auth_repository.dart';
import 'package:zavona_flutter_app/presentation/app/bloc/app_state.dart';
import 'package:zavona_flutter_app/third_party_services/analytics_service.dart';
import 'package:zavona_flutter_app/third_party_services/crashlytics_service.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState()) {
    _initializeSessionManager();
  }

  final AuthRepository _authRepository = locator<AuthRepository>();
  final SessionManager _sessionManager = SessionManager.instance;
  StreamSubscription<SessionState>? _sessionSubscription;

  /// Initialize SessionManager and listen to session changes
  Future<void> _initializeSessionManager() async {
    try {
      emit(state.copyWith(eViewState: EViewState.loading));
      // Initialize SessionManager (loads data from storage)
      await SessionManager.initialize().then((_) {
        CrashlyticsService.initialize();
        AnalyticsService.initialize();
      });
      getProfileData();

      // Listen to session state changes
      _sessionSubscription = _sessionManager.sessionStream.listen(
        _onSessionStateChanged,
        onError: (error) {
          emit(
            state.copyWith(
              eViewState: EViewState.error,
              errorMessage: 'Session error: $error',
            ),
          );
        },
      );

      // Set initial state based on current session
      _onSessionStateChanged(_sessionManager.currentState);
    } catch (e) {
      emit(
        state.copyWith(
          isAuthenticated: false,
          eViewState: EViewState.error,
          errorMessage: 'Failed to initialize session: $e',
        ),
      );
    }
  }

  /// Handle session state changes from SessionManager
  void _onSessionStateChanged(SessionState sessionState) {
    switch (sessionState.status) {
      case SessionStatus.initial:
        emit(state.copyWith(eViewState: EViewState.loading));
        break;

      case SessionStatus.authenticated:
        // Convert session userData to User model if available
        User? user;
        if (sessionState.userData != null) {
          try {
            user = User.fromJson(sessionState.userData!);
          } catch (e) {
            debugPrint('Error parsing user data: $e');
          }
        }

        emit(
          state.copyWith(
            isAuthenticated: true,
            eViewState: EViewState.loaded,
            user: user,
            errorMessage: null,
          ),
        );
        break;

      case SessionStatus.unauthenticated:
        emit(
          state.copyWith(
            isAuthenticated: false,
            eViewState: EViewState.loaded,
            user: null,
            errorMessage: null,
          ),
        );
        break;
    }
  }

  Future<void> getProfileData() async {
    if (!_sessionManager.isAuthenticated) return;

    try {
      var res = await _authRepository.getMyProfile();
      if (res.data?.user != null) {
        final userData = res.data!.user!.toJson();

        // Update SessionManager with fresh user data
        await _sessionManager.updateUserData(userData);

        // State will be automatically updated via session stream
        // but we can also emit directly for immediate UI update
        emit(
          state.copyWith(
            user: res.data!.user!,
            eViewState: EViewState.loaded,
            isAuthenticated: true,
            errorMessage: null,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          eViewState: EViewState.error,
          errorMessage: 'Failed to fetch profile: $e',
        ),
      );
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      emit(state.copyWith(eViewState: EViewState.loading));
      await _sessionManager.clearSession();
      emit(
        AppState(
          isAuthenticated: false,
          user: null,
          eViewState: EViewState.loaded,
          errorMessage: null,
        ),
      );
      // State will be automatically updated via session stream
    } catch (e) {
      emit(
        state.copyWith(
          eViewState: EViewState.error,
          errorMessage: 'Failed to logout: $e',
        ),
      );
    }
  }

  /// Check if user is authenticated
  bool get isAuthenticated => _sessionManager.isAuthenticated;

  /// Get current user data
  Map<String, dynamic>? get userData => _sessionManager.userData;

  /// Get current access token
  String? get accessToken => _sessionManager.accessToken;

  /// Update user data in both local state and session manager
  Future<void> updateUser(User user) async {
    try {
      final userData = user.toJson();

      // Update SessionManager with new user data
      await _sessionManager.updateUserData(userData);

      // Also emit the updated state directly for immediate UI update
      emit(
        state.copyWith(
          user: user,
          eViewState: EViewState.loaded,
          isAuthenticated: true,
          errorMessage: null,
        ),
      );
    } catch (e) {
      debugPrint('Error updating user data: $e');
    }
  }

  @override
  Future<void> close() {
    _sessionSubscription?.cancel();
    return super.close();
  }
}
