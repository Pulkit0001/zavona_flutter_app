import 'package:image_picker/image_picker.dart';
import 'package:zavona_flutter_app/core/presentation/blocs/e_states.dart';
import 'package:zavona_flutter_app/presentation/parking/widgets/parking_form/parking_size_selection_widget.dart';

class ParkingFormState {
  final List<ParkingSize> selectedSizes;
  final XFile? parkingThumbnail;
  final List<XFile> parkingDocs;
  final bool optToSell;
  final bool optToRent;
  final EFormState formState;
  final String? errorMessage;

  ParkingFormState({
    this.selectedSizes = const [],
    this.parkingThumbnail,
    this.parkingDocs = const [],
    this.optToSell = false,
    this.optToRent = true,
    this.formState = EFormState.initial,
    this.errorMessage,
  });

  ParkingFormState copyWith({
    List<ParkingSize>? selectedSizes,
    XFile? parkingThumbnail,
    List<XFile>? parkingDocs,
    bool? optToSell,
    bool? optToRent,
    EFormState? formState,
    String? errorMessage,
  }) {
    return ParkingFormState(
      selectedSizes: selectedSizes ?? this.selectedSizes,
      parkingThumbnail: parkingThumbnail ?? this.parkingThumbnail,
      parkingDocs: parkingDocs ?? this.parkingDocs,
      optToSell: optToSell ?? this.optToSell,
      optToRent: optToRent ?? this.optToRent,
      formState: formState ?? this.formState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
