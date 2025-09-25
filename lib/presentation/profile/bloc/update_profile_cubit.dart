import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zavona_flutter_app/core/locator.dart';
import 'package:zavona_flutter_app/core/presentation/blocs/e_states.dart';
import 'package:zavona_flutter_app/core/presentation/utils/message_utils.dart';
import 'package:zavona_flutter_app/domain/models/auth/kyc_status_enum.dart';
import 'package:zavona_flutter_app/domain/models/auth/my_profile_response.dart';
import 'package:zavona_flutter_app/domain/repositories/profile_repository.dart';
import 'package:zavona_flutter_app/presentation/profile/bloc/update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  final ProfileRepository _profileRepository = locator<ProfileRepository>();

  // Text editing controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  UpdateProfileCubit() : super(UpdateProfileState());

  /// Initialize the form with user data
  void initializeForm(User user) {
    nameController.text = user.name ?? '';
    emailController.text = user.email ?? '';
    mobileController.text = user.mobile ?? '';

    emit(
      state.copyWith(
        user: user,
        userRole: user.userRole,
        formState: EFormState.initial,
        fieldErrors: {},
        errorMessage: null,
        profileImageKey: user.profileImage,
        kycDocsKey: (user.kycDocs?.isEmpty ?? true)
            ? <String>["", ""]
            : user.kycDocs!,
        successMessage: null,
      ),
    );
  }

  /// Update profile image key
  void updateProfileImageKey(String? imageKey) {
    emit(state.copyWith(profileImageKey: imageKey));
  }

  /// Update user role based on seller toggle
  void updateUserRole(bool isSeller) {
    final newRole = isSeller ? 'seller' : (state.user?.userRole ?? 'user');
    emit(state.copyWith(userRole: newRole));
  }

  /// Validate individual field
  void validateField(String fieldName, String value) {
    final currentErrors = Map<String, String?>.from(state.fieldErrors);

    switch (fieldName) {
      case 'name':
        currentErrors['name'] = _validateName(value);
        break;
      case 'email':
        currentErrors['email'] = _validateEmail(value);
        break;
      case 'mobile':
        currentErrors['mobile'] = _validateMobile(value);
        break;
    }

    emit(state.copyWith(fieldErrors: currentErrors));
  }

  /// Validate all fields
  void validateAllFields() {
    final errors = <String, String?>{
      'name': _validateName(nameController.text),
      'email': _validateEmail(emailController.text),
      'mobile': _validateMobile(mobileController.text),
    };

    emit(state.copyWith(fieldErrors: errors));
  }

  updateKycDocKey(String docKey, int index) {
    final updatedDocs = List<String>.from(state.kycDocsKey);
    if (index >= 0 && index < updatedDocs.length) {
      updatedDocs[index] = docKey;
      emit(state.copyWith(kycDocsKey: updatedDocs));
    }
  }

  /// Submit the form to update profile
  Future<void> updateProfile() async {
    if (state.user == null) {
      MessageUtils.showErrorMessage('User data not available');
      return;
    }

    // Validate all fields first
    // validateAllFields();

    if (!state.isFormValid) {
      MessageUtils.showErrorMessage('Please fix all validation errors');
      return;
    }

    emit(
      state.copyWith(
        formState: EFormState.submittingForm,
        errorMessage: null,
        successMessage: null,
      ),
    );

    try {
      // Determine profile image to use
      final profileImageToUse =
          state.profileImageKey ?? state.user!.profileImage?.toString() ?? '';

      await _profileRepository.updateProfile(
        user: state.user!,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        mobile: mobileController.text.trim(),
        role: state.userRole ?? state.user!.userRole ?? '',
        profileImage: profileImageToUse,
      );

      // Update the user object with new data
      final updatedUser = state.user!.copyWith(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        mobile: mobileController.text.trim(),
        userRole: state.userRole,
        profileImage: profileImageToUse.isNotEmpty ? profileImageToUse : null,
      );

      emit(
        state.copyWith(
          formState: EFormState.submittingSuccess,
          user: updatedUser,
          successMessage: 'Profile updated successfully',
        ),
      );

      MessageUtils.showSuccessMessage('Profile updated successfully');
    } catch (e) {
      emit(
        state.copyWith(
          formState: EFormState.submittingFailed,
          errorMessage: e.toString(),
        ),
      );

      MessageUtils.showErrorMessage(e.toString());
    }
  }

  /// Submit the form to update profile
  Future<void> updateKycDocs() async {
    if (state.user == null) {
      MessageUtils.showErrorMessage('User data not available');
      return;
    }
    if (!KycStatus.fromCode(
      state.user?.kycStatus ?? 'pending',
    ).requiresAction) {
      MessageUtils.showErrorMessage('No action required for KYC status');
      return;
    }

    if (state.kycDocsKey.any((doc) => doc.isEmpty)) {
      MessageUtils.showErrorMessage('Please upload all KYC documents');
      return;
    } else if (state.kycDocsKey.length < 2) {
      MessageUtils.showErrorMessage('Please upload all KYC documents');
      return;
    } else if (state.kycDocsKey.first.isEmpty) {
      MessageUtils.showErrorMessage(
        'Please upload front image of KYC document',
      );
      return;
    } else if (state.kycDocsKey.last.isEmpty) {
      MessageUtils.showErrorMessage('Please upload back image of KYC document');
      return;
    }

    emit(
      state.copyWith(
        formState: EFormState.submittingForm,
        errorMessage: null,
        successMessage: null,
      ),
    );

    try {
      // Determine profile image to use
      final profileImageToUse =
          state.profileImageKey ?? state.user!.profileImage?.toString() ?? '';

      await _profileRepository.updateProfile(
        user: state.user!,
        name: state.user!.name ?? '',
        email: state.user!.email ?? '',
        mobile: state.user!.mobile ?? '',
        role: state.user!.userRole ?? '',
        profileImage: state.user?.profileImage?.toString() ?? '',
        kycStatus: KycStatus.pendingApproval.code,
        kycDocs: state.kycDocsKey,
      );

      // Update the user object with new data
      final updatedUser = state.user!.copyWith(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        mobile: mobileController.text.trim(),
        userRole: state.userRole,
        profileImage: profileImageToUse.isNotEmpty ? profileImageToUse : null,
        kycStatus: KycStatus.pendingApproval.code,
        kycDocs: state.kycDocsKey,
      );

      emit(
        state.copyWith(
          formState: EFormState.submittingSuccess,
          user: updatedUser,
          successMessage: 'Kyc details updated successfully',
        ),
      );

      MessageUtils.showSuccessMessage('Kyc details updated successfully');
    } catch (e) {
      emit(
        state.copyWith(
          formState: EFormState.submittingFailed,
          errorMessage: e.toString(),
        ),
      );

      MessageUtils.showErrorMessage(e.toString());
    }
  }

  /// Reset form state
  void resetForm() {
    emit(
      state.copyWith(
        formState: EFormState.initial,
        errorMessage: null,
        successMessage: null,
        fieldErrors: {},
      ),
    );
  }

  /// Clear all error messages
  void clearErrors() {
    emit(state.copyWith(errorMessage: null, fieldErrors: {}));
  }

  /// Private validation methods

  String? _validateName(String value) {
    value = value.trim();

    if (value.isEmpty) {
      return 'Name is required';
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }

    if (value.length > 50) {
      return 'Name must not exceed 50 characters';
    }

    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(value)) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }

    return null;
  }

  String? _validateEmail(String value) {
    value = value.trim();

    if (value.isEmpty) {
      return 'Email is required';
    }

    // Email regex pattern
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    if (value.length > 254) {
      return 'Email address is too long';
    }

    return null;
  }

  String? _validateMobile(String value) {
    value = value.trim();

    if (value.isEmpty) {
      return 'Mobile number is required';
    }

    // Remove any non-digit characters for validation
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 10) {
      return 'Mobile number must be at least 10 digits';
    }

    if (digitsOnly.length > 15) {
      return 'Mobile number must not exceed 15 digits';
    }

    // Check for valid mobile number pattern (allowing +, -, spaces, parentheses)
    if (!RegExp(r'^[\+]?[\d\s\-\(\)]+$').hasMatch(value)) {
      return 'Please enter a valid mobile number';
    }

    return null;
  }

  /// Check if there are any changes from original user data
  bool get hasChanges {
    if (state.user == null) return false;

    final originalName = state.user!.name ?? '';
    final originalEmail = state.user!.email ?? '';
    final originalMobile = state.user!.mobile ?? '';

    return nameController.text.trim() != originalName ||
        emailController.text.trim() != originalEmail ||
        mobileController.text.trim() != originalMobile ||
        state.profileImageKey != null;
  }

  /// Get current profile image URL/key
  String? get currentProfileImage {
    return state.profileImageKey ?? state.user?.profileImage?.toString();
  }

  get isSeller => state.userRole == 'seller';

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    return super.close();
  }
}
