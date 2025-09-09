import 'package:zavona_flutter_app/core/presentation/blocs/e_states.dart';

class AuthState {
  final bool isPhoneAuth;
  final EFormState eFormState;
  final String? errorMessage;
  final bool isNewUser;

  AuthState({
    this.isPhoneAuth = true,
    this.eFormState = EFormState.initial,
    this.errorMessage,
    this.isNewUser = false,
  });

  AuthState copyWith({
    bool? isPhoneAuth,
    EFormState? eFormState,
    String? errorMessage,
    bool? isNewUser,
  }) {
    return AuthState(
      isPhoneAuth: isPhoneAuth ?? this.isPhoneAuth,
      eFormState: eFormState ?? this.eFormState,
      errorMessage: errorMessage ?? this.errorMessage,
      isNewUser: isNewUser ?? this.isNewUser,
    );
  }
}
