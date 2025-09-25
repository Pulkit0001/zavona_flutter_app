import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zavona_flutter_app/core/locator.dart';
import 'package:zavona_flutter_app/core/presentation/blocs/e_states.dart';
import 'package:zavona_flutter_app/core/presentation/utils/message_utils.dart';
import 'package:zavona_flutter_app/domain/repositories/parkings_repository.dart';
import 'package:zavona_flutter_app/presentation/parking/bloc/parking_form/parking_form_state.dart';
import 'package:zavona_flutter_app/presentation/parking/widgets/parking_form/parking_size_selection_widget.dart';
import 'package:zavona_flutter_app/third_party_services/location_service.dart';

class ParkingFormCubit extends Cubit<ParkingFormState> {
  ParkingFormCubit({this.parkingSpaceId = ''}) : super(ParkingFormState());

  final String parkingSpaceId;

  final TextEditingController parkingNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController societyNameController = TextEditingController();

  final TextEditingController dailyRentController = TextEditingController();
  final TextEditingController hourlyRentController = TextEditingController();

  final TextEditingController sellingPriceController = TextEditingController();

  final FocusNode parkingNumberFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();
  final FocusNode societyNameFocusNode = FocusNode();

  final FocusNode dailyRentFocusNode = FocusNode();
  final FocusNode hourlyRentFocusNode = FocusNode();

  final FocusNode sellingPriceFocusNode = FocusNode();

  final ParkingsRepository _parkingsRepository = locator<ParkingsRepository>();

  void initializeForm() async {
    if (parkingSpaceId.isNotEmpty) {
      var res = await _parkingsRepository.getParkingById(parkingSpaceId);
      if (res.data != null) {
        parkingNumberController.text = res.data!.parkingSpace?.name ?? '';
        addressController.text = res.data!.parkingSpace?.address ?? '';
        societyNameController.text =
            res.data!.parkingSpace?.areaSocietyName ?? '';

        dailyRentController.text =
            res.data!.parkingSpot?.firstOrNull?.rentPricePerDay?.toString() ??
            '';
        hourlyRentController.text =
            res.data!.parkingSpot?.firstOrNull?.rentPricePerHour?.toString() ??
            '';
        sellingPriceController.text =
            res.data!.parkingSpot?.firstOrNull?.sellingPrice?.toString() ?? '';
        emit(
          state.copyWith(
            selectedSizes:
                res.data!.parkingSpot?.firstOrNull?.parkingSize
                    ?.map(
                      (size) =>
                          ParkingSize.values.firstWhere((e) => e.name == size),
                    )
                    .toList() ??
                [],
            parkingThumbnailKey: res.data!.parkingSpace?.thumbnailUrl ?? '',
            parkingDocKeys: res.data!.parkingSpace?.images ?? [],
            optToRent:
                res.data!.parkingSpot?.firstOrNull?.availableToRent ?? false,
            optToSell:
                res.data!.parkingSpot?.firstOrNull?.availableToSell ?? false,
            locationDTO: LocationDTO(
              res.data!.parkingSpace?.coordinates?.latitude?.toDouble() ?? 0.0,
              res.data!.parkingSpace?.coordinates?.longitude?.toDouble() ?? 0.0,
              res.data!.parkingSpace?.address ?? '',
            ),
          ),
        );
      }
    }
  }

  void toggleSizeSelection(ParkingSize size) {
    final currentSizes = List<ParkingSize>.from(state.selectedSizes);
    if (currentSizes.contains(size)) {
      currentSizes.remove(size);
    } else {
      currentSizes.add(size);
    }
    emit(state.copyWith(selectedSizes: currentSizes));
  }

  void toggleRenOptIn(bool value) {
    emit(state.copyWith(optToRent: value));
  }

  void toggleSellOptIn(bool value) {
    emit(state.copyWith(optToSell: value));
  }

  void updateThumbnailImageKey(String imageKey) {
    emit(state.copyWith(parkingThumbnailKey: imageKey));
  }

  void addParkingDocKey(String imageKey) {
    final currentDocs = List<String>.from(state.parkingDocKeys);
    if (!currentDocs.contains(imageKey)) {
      currentDocs.add(imageKey);
      emit(state.copyWith(parkingDocKeys: currentDocs));
    }
  }

  void updateLocationDTO(LocationDTO locationDTO) {
    emit(state.copyWith(locationDTO: locationDTO));
  }

  /// Clear all error messages
  void clearErrors() {
    emit(state.copyWith(errorMessage: null, fieldErrors: {}));
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

  /// Validate individual field
  void validateField(String fieldName, String value) {
    final currentErrors = Map<String, String?>.from(state.fieldErrors);

    switch (fieldName) {
      case 'parkingNumber':
        currentErrors['parkingNumber'] = _validateParkingNumber(value);
        break;
      case 'societyName':
        currentErrors['societyName'] = _validateSocietyName(value);
        break;
      case 'address':
        currentErrors['address'] = _validateAddress(value);
        break;
    }

    emit(state.copyWith(fieldErrors: currentErrors));
  }

  /// Validate address section
  void validateAddressSection() {
    final errors = Map<String, String?>.from(state.fieldErrors);

    errors['parkingNumber'] = _validateParkingNumber(
      parkingNumberController.text,
    );
    errors['societyName'] = _validateSocietyName(societyNameController.text);
    errors['address'] = _validateAddress(addressController.text);
    errors['location'] = _validateLocation();

    emit(state.copyWith(fieldErrors: errors));
  }

  /// Validate parking size section
  void validateParkingSizeSection() {
    final errors = Map<String, String?>.from(state.fieldErrors);
    errors['parkingSize'] = _validateParkingSize();
    emit(state.copyWith(fieldErrors: errors));
  }

  /// Validate docs section
  void validateDocsSection() {
    final errors = Map<String, String?>.from(state.fieldErrors);
    errors['thumbnail'] = _validateThumbnail();
    errors['documents'] = _validateDocuments();
    emit(state.copyWith(fieldErrors: errors));
  }

  /// Validate pricing section
  void validatePricingSection() {
    final errors = Map<String, String?>.from(state.fieldErrors);
    errors['pricing'] = _validatePricing();
    emit(state.copyWith(fieldErrors: errors));
  }

  /// Validate all sections
  void validateAllSections() {
    validateAddressSection();
    validateParkingSizeSection();
    validateDocsSection();
    validatePricingSection();
  }

  /// Private validation methods

  String? _validateParkingNumber(String value) {
    value = value.trim();

    if (value.isEmpty) {
      return 'Parking number is required';
    }

    if (value.length < 1) {
      return 'Parking number must be at least 1 character long';
    }

    if (value.length > 20) {
      return 'Parking number must not exceed 20 characters';
    }

    // Check for valid characters (alphanumeric, hyphens, spaces)
    if (!RegExp(r'^[a-zA-Z0-9\s\-]+$').hasMatch(value)) {
      return 'Parking number can only contain letters, numbers, spaces, and hyphens';
    }

    return null;
  }

  String? _validateSocietyName(String value) {
    value = value.trim();

    if (value.isEmpty) {
      return 'Society name is required';
    }

    if (value.length < 2) {
      return 'Society name must be at least 2 characters long';
    }

    if (value.length > 100) {
      return 'Society name must not exceed 100 characters';
    }

    return null;
  }

  String? _validateAddress(String value) {
    value = value.trim();

    if (value.isEmpty) {
      return 'Address is required';
    }

    if (value.length < 10) {
      return 'Address must be at least 10 characters long';
    }

    if (value.length > 255) {
      return 'Address must not exceed 255 characters';
    }

    return null;
  }

  String? _validateLocation() {
    if (state.locationDTO == null) {
      return 'Location is required';
    }

    if (state.locationDTO!.latitude == 0.0 ||
        state.locationDTO!.longitude == 0.0) {
      return 'Please select a valid location';
    }

    return null;
  }

  String? _validateParkingSize() {
    if (state.selectedSizes.isEmpty) {
      return 'Please select at least one parking size';
    }

    return null;
  }

  String? _validateThumbnail() {
    if (state.parkingThumbnailKey == null ||
        state.parkingThumbnailKey!.isEmpty) {
      return 'Thumbnail image is required';
    }

    return null;
  }

  String? _validateDocuments() {
    if (state.parkingDocKeys.isEmpty) {
      return 'At least one parking document image is required';
    }

    if (state.parkingDocKeys.length > 10) {
      return 'Maximum 10 document images are allowed';
    }

    return null;
  }

  String? _validatePricing() {
    // Check if at least one option is selected
    if (!state.optToRent && !state.optToSell) {
      return 'Please select at least one option: rent or sell';
    }

    // Validate rent pricing if opt to rent is selected
    if (state.optToRent) {
      final hourlyRent = hourlyRentController.text.trim();
      final dailyRent = dailyRentController.text.trim();

      if (hourlyRent.isEmpty && dailyRent.isEmpty) {
        return 'Please enter rent price per hour or per day';
      }

      if (hourlyRent.isNotEmpty) {
        final hourlyPrice = double.tryParse(hourlyRent);
        if (hourlyPrice == null || hourlyPrice <= 0) {
          return 'Please enter a valid hourly rent price';
        }
        if (hourlyPrice > 10000) {
          return 'Hourly rent price cannot exceed ₹10,000';
        }
      }

      if (dailyRent.isNotEmpty) {
        final dailyPrice = double.tryParse(dailyRent);
        if (dailyPrice == null || dailyPrice <= 0) {
          return 'Please enter a valid daily rent price';
        }
        if (dailyPrice > 100000) {
          return 'Daily rent price cannot exceed ₹1,00,000';
        }
      }
    }

    // Validate selling price if opt to sell is selected
    if (state.optToSell) {
      final sellingPrice = sellingPriceController.text.trim();

      if (sellingPrice.isEmpty) {
        return 'Please enter selling price';
      }

      final price = double.tryParse(sellingPrice);
      if (price == null || price <= 0) {
        return 'Please enter a valid selling price';
      }

      if (price > 100000000) {
        return 'Selling price cannot exceed ₹10,00,00,000';
      }
    }

    return null;
  }

  Future<void> createParkingSpace(String ownerId) async {
    // Validate all sections first
    validateAllSections();

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
      await _parkingsRepository.createParking(
        parkingNumber: parkingNumberController.text.trim(),
        societyName: societyNameController.text.trim(),
        address: addressController.text.trim(),
        latitude: state.locationDTO!.latitude,
        longitude: state.locationDTO!.longitude,
        docs: state.parkingDocKeys,
        thumbnail: state.parkingThumbnailKey ?? '',
        availableVehicleSizes: state.selectedSizes.map((e) => e.name).toList(),
        ownerId: ownerId,
        isAvailableToRent: state.optToRent,
        isAvailableToSell: state.optToSell,
        rentPricePerHour: double.tryParse(hourlyRentController.text.trim()),
        rentPricePerDay: double.tryParse(dailyRentController.text.trim()),
        sellingPrice: double.tryParse(sellingPriceController.text.trim()),
      );

      emit(
        state.copyWith(
          formState: EFormState.submittingSuccess,
          successMessage: 'Parking space created successfully',
        ),
      );

      MessageUtils.showSuccessMessage('Parking space created successfully');
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

  Future<void> updateParkingSpace(String ownerId) async {
    if (parkingSpaceId.isEmpty) {
      MessageUtils.showErrorMessage(
        'Parking space ID is required for updating',
      );
      return;
    }

    // Validate all sections first
    validateAllSections();

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
      await _parkingsRepository.updateParking(
        parkingSpaceId: parkingSpaceId,
        parkingNumber: parkingNumberController.text.trim(),
        societyName: societyNameController.text.trim(),
        address: addressController.text.trim(),
        latitude: state.locationDTO!.latitude,
        longitude: state.locationDTO!.longitude,
        docs: state.parkingDocKeys,
        thumbnail: state.parkingThumbnailKey ?? '',
        availableVehicleSizes: state.selectedSizes.map((e) => e.name).toList(),
        ownerId: ownerId,
        isAvailableToRent: state.optToRent,
        isAvailableToSell: state.optToSell,
        rentPricePerHour: double.tryParse(hourlyRentController.text.trim()),
        rentPricePerDay: double.tryParse(dailyRentController.text.trim()),
        sellingPrice: double.tryParse(sellingPriceController.text.trim()),
        isVerified: false, // Default to false for updates
      );

      emit(
        state.copyWith(
          formState: EFormState.submittingSuccess,
          successMessage: 'Parking space updated successfully',
        ),
      );

      MessageUtils.showSuccessMessage('Parking space updated successfully');
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

  /// Check if there are any changes from original data (for edit mode)
  bool get hasChanges {
    if (parkingSpaceId.isEmpty) return true; // New parking, always has changes

    // Here you could compare current form values with original values loaded in initializeForm
    // For now, we'll return true if any field has content
    return parkingNumberController.text.isNotEmpty ||
        addressController.text.isNotEmpty ||
        societyNameController.text.isNotEmpty ||
        state.selectedSizes.isNotEmpty ||
        state.parkingDocKeys.isNotEmpty ||
        state.parkingThumbnailKey != null;
  }

  @override
  Future<void> close() {
    parkingNumberController.dispose();
    addressController.dispose();
    societyNameController.dispose();
    dailyRentController.dispose();
    hourlyRentController.dispose();
    sellingPriceController.dispose();

    parkingNumberFocusNode.dispose();
    addressFocusNode.dispose();
    societyNameFocusNode.dispose();
    dailyRentFocusNode.dispose();
    hourlyRentFocusNode.dispose();
    sellingPriceFocusNode.dispose();

    return super.close();
  }

  setLocationDTO(LocationDTO locationDTO) {
    addressController.text = locationDTO.address;
    emit(state.copyWith(locationDTO: locationDTO));
  }
}
