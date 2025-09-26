import 'package:zavona_flutter_app/core/presentation/blocs/e_states.dart';
import 'package:zavona_flutter_app/presentation/parking/widgets/parking_filters_widget.dart';
import 'package:zavona_flutter_app/presentation/parking/widgets/parking_form/parking_size_selection_widget.dart';
import 'package:zavona_flutter_app/third_party_services/location_service.dart';

class ParkingFormState {
  final List<ParkingSize> selectedSizes;
  final String? parkingThumbnailKey;
  final List<String> parkingDocKeys;
  final bool optToSell;
  final LocationDTO? locationDTO;
  final bool optToRent;
  final EFormState formState;
  final String? errorMessage;
  final String? successMessage;
  final Map<String, String?> fieldErrors;

  List<ParkingAmenities> selectedAmenities;

  ParkingFormState({
    this.selectedSizes = const [],
    this.parkingThumbnailKey,
    this.parkingDocKeys = const [],
    this.optToSell = false,
    this.optToRent = true,
    this.formState = EFormState.initial,
    this.errorMessage,
    this.successMessage,
    this.fieldErrors = const {},
    this.locationDTO,
    this.selectedAmenities = const [],
  });

  ParkingFormState copyWith({
    List<ParkingSize>? selectedSizes,
    String? parkingThumbnailKey,
    List<String>? parkingDocKeys,
    bool? optToSell,
    LocationDTO? locationDTO,
    bool? optToRent,
    EFormState? formState,
    String? errorMessage,
    String? successMessage,
    List<ParkingAmenities>? selectedAmenities,
    Map<String, String?>? fieldErrors,
  }) {
    return ParkingFormState(
      selectedSizes: selectedSizes ?? this.selectedSizes,
      parkingThumbnailKey: parkingThumbnailKey ?? this.parkingThumbnailKey,
      parkingDocKeys: parkingDocKeys ?? this.parkingDocKeys,
      optToSell: optToSell ?? this.optToSell,
      optToRent: optToRent ?? this.optToRent,
      locationDTO: locationDTO ?? this.locationDTO,
      formState: formState ?? this.formState,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      selectedAmenities: selectedAmenities ?? this.selectedAmenities,
    );
  }

  /// Check if form has any validation errors
  bool get hasErrors => fieldErrors.values.any((error) => error != null);

  /// Check if the address section is valid
  bool get isAddressSectionValid {
    final addressErrors = [
      'parkingNumber',
      'societyName',
      'address',
      'location',
    ];
    return !addressErrors.any((field) => fieldErrors[field] != null);
  }

  /// Check if the parking size section is valid
  bool get isParkingSizeSectionValid => fieldErrors['parkingSize'] == null;

  /// Check if the docs section is valid
  bool get isDocsSectionValid {
    final docsErrors = ['thumbnail', 'documents'];
    return !docsErrors.any((field) => fieldErrors[field] != null);
  }

  /// Check if the pricing section is valid
  bool get isPricingSectionValid {
    final pricingErrors = ['pricing'];
    return !pricingErrors.any((field) => fieldErrors[field] != null);
  }

  /// Check if entire form is valid
  bool get isFormValid => !hasErrors;
}
