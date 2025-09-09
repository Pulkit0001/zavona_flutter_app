
import 'package:zavona_flutter_app/core/presentation/blocs/e_states.dart';
import 'package:zavona_flutter_app/third_party_services/location_service.dart';

class SelectLocationState {
  final String? errorMessage;
  final EViewState eViewState;
  final LocationDTO? selectedLocation;
  final List<LocationDTO> suggestions;


  SelectLocationState({
    this.errorMessage,
    this.eViewState = EViewState.initial,
    this.selectedLocation,
    this.suggestions = const [],
  });

  SelectLocationState copyWith({
    String? errorMessage,
    EViewState? eViewState,
    LocationDTO? selectedLocation,
    List<LocationDTO>? suggestions,
  }) {
    return SelectLocationState(
      errorMessage: errorMessage ?? this.errorMessage,
      eViewState: eViewState ?? this.eViewState,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      suggestions: suggestions ?? this.suggestions,
    );
  }
}