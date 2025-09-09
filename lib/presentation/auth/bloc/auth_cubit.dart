import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zavona_flutter_app/core/domain/session_manager.dart';
import 'package:zavona_flutter_app/core/presentation/blocs/e_states.dart';
import 'package:zavona_flutter_app/domain/repositories/auth_repository.dart';
import 'package:zavona_flutter_app/presentation/auth/bloc/auth_state.dart';
import 'package:zavona_flutter_app/third_party_services/secure_storage_service.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  final AuthRepository _authRepository = AuthRepository();
  final TextEditingController inputController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  void toggleIdentifier() {
    emit(state.copyWith(isPhoneAuth: !state.isPhoneAuth));
  }

  Future<void> requestOTP() async {
    try {
      emit(state.copyWith(eFormState: EFormState.submittingForm));
      await _authRepository.requestOtp(
        identifier: inputController.text.trim(),
        identifierType: !state.isPhoneAuth ? "email" : "mobile",
        purpose: 'login',
      );
      emit(state.copyWith(eFormState: EFormState.submittingSuccess));
    } catch (e) {
      emit(
        state.copyWith(
          eFormState: EFormState.submittingFailed,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> verifyOtp(String identifier) async {
    try {
      emit(state.copyWith(eFormState: EFormState.submittingForm));
      var res = await _authRepository.verifyOtp(
        identifier: identifier,
        otpcode: otpController.text.trim(),
        purpose: 'login',
      );
      if ((res.data?.token ?? "").isNotEmpty) {
        SessionManager.instance.updateAccessToken(res.data?.token ?? "");
        emit(
          state.copyWith(
            eFormState: EFormState.submittingSuccess,
            isNewUser: res.data!.isNewUser ?? false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            eFormState: EFormState.submittingFailed,
            errorMessage: "Invalid OTP",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          eFormState: EFormState.submittingFailed,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> socialLogin({
    required String provider,
    required String accessToken,
    required String idToken,
    required String socialDataEmail,
    required String socialDataName,
    required String socialDataPicture,
  }) async {
    try {
      emit(state.copyWith(eFormState: EFormState.submittingForm));
      var res = await _authRepository.socialLogin(
        provider: provider,
        accessToken: accessToken,
        idToken: idToken,
        socialDataEmail: socialDataEmail,
        socialDataName: socialDataName,
        socialDataPicture: socialDataPicture,
      );
      if ((res.data?.token ?? "").isNotEmpty) {
        LocalStorage.setAccessToken(res.data?.token ?? "");
        emit(
          state.copyWith(
            eFormState: EFormState.submittingSuccess,
            isNewUser: res.data!.isNewUser ?? false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            eFormState: EFormState.submittingFailed,
            errorMessage: "Social login failed",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          eFormState: EFormState.submittingFailed,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
