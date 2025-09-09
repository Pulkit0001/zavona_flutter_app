import 'package:zavona_flutter_app/core/presentation/blocs/e_states.dart';
import 'package:zavona_flutter_app/domain/models/auth/my_profile_response.dart';

class AppState {
  final User? user;
  final String? errorMessage;
  final EViewState eViewState;
  final bool isAuthenticated;

  AppState({
    this.user,
    this.errorMessage,
    this.eViewState = EViewState.loaded,
    this.isAuthenticated = false,
  });

  AppState copyWith({
    User? user,
    String? errorMessage,
    EViewState? eViewState,
    bool? isAuthenticated,
  }) {
    return AppState(
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      eViewState: eViewState ?? this.eViewState,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}
