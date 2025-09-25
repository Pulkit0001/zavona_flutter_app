import 'package:zavona_flutter_app/core/presentation/blocs/e_states.dart';
import 'package:zavona_flutter_app/domain/models/auth/my_profile_response.dart';

class UpdateProfileState {
  /// Form state to track current state of the form
  final EFormState formState;

  /// Error message to display if any error occurs
  final String? errorMessage;

  /// Current user data
  final User? user;

  /// Profile image key after upload (if any)
  final String? profileImageKey;

  /// KYC document keys
  final List<String> kycDocsKey;

  /// Form validation errors
  final Map<String, String?> fieldErrors;

  /// Success message after profile update
  final String? successMessage;

  /// User role - 'seller' if user wants to sell/rent parking, otherwise keeps original role
  final String? userRole;

  UpdateProfileState({
    this.formState = EFormState.initial,
    this.errorMessage,
    this.user,
    this.profileImageKey,
    this.fieldErrors = const {},
    this.successMessage,
    this.kycDocsKey = const ["", ""],
    this.userRole,
  });

  UpdateProfileState copyWith({
    EFormState? formState,
    String? errorMessage,
    User? user,
    String? profileImageKey,
    Map<String, String?>? fieldErrors,
    String? successMessage,
    List<String>? kycDocsKey,
    String? userRole,
  }) {
    return UpdateProfileState(
      formState: formState ?? this.formState,
      errorMessage: errorMessage,
      user: user ?? this.user,
      profileImageKey: profileImageKey ?? this.profileImageKey,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      successMessage: successMessage,
      userRole: userRole ?? this.userRole,
      kycDocsKey: kycDocsKey ?? this.kycDocsKey,
    );
  }

  /// Check if the form is valid
  bool get isFormValid {
    return fieldErrors.values.every((error) => error == null) &&
        _isNameValid &&
        _isEmailValid &&
        _isMobileValid;
  }

  /// Check if name is valid
  bool get _isNameValid {
    return fieldErrors['name'] == null;
  }

  /// Check if email is valid
  bool get _isEmailValid {
    return fieldErrors['email'] == null;
  }

  /// Check if mobile is valid
  bool get _isMobileValid {
    return fieldErrors['mobile'] == null;
  }

  /// Check if form is loading
  bool get isLoading {
    return formState == EFormState.loadingForm ||
        formState == EFormState.submittingForm;
  }

  /// Check if form submission was successful
  bool get isSuccess {
    return formState == EFormState.submittingSuccess ||
        formState == EFormState.success;
  }

  /// Check if form has error
  bool get hasError {
    return formState == EFormState.submittingFailed ||
        formState == EFormState.failure;
  }
}
