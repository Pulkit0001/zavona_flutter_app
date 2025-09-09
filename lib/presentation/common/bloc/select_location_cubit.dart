import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zavona_flutter_app/core/config/api_config.dart';
import 'package:zavona_flutter_app/core/presentation/utils/message_utils.dart';
import 'package:zavona_flutter_app/presentation/common/bloc/select_location_state.dart';
import 'package:zavona_flutter_app/third_party_services/location_service.dart';

class SelectLocationCubit extends Cubit<SelectLocationState> {
  SelectLocationCubit() : super(SelectLocationState());
  final Dio _dio = Dio();

  static const String _googlePlacesApiKey = ApiConfig.googlePlacesApiKey;

  Future<void> setSelectedLocation(LocationDTO location) async {
    emit(state.copyWith(selectedLocation: location));
  }

  Future<void> searchPlaces(String query) async {
    if (query.isEmpty) {
      emit(state.copyWith(suggestions: []));
      return;
    }
    try {
      List<LocationDTO> suggestions = [];
      suggestions.add(
        LocationDTO(0.0, 0.0, "My Location", isCurrentLocation: true),
      );
      if (_googlePlacesApiKey != 'YOUR_GOOGLE_PLACES_API_KEY_HERE') {
        final placeSuggestions = await fetchGooglePlacesSuggestions(query);
        suggestions.addAll(placeSuggestions);
      }
      emit(state.copyWith(suggestions: suggestions));
    } catch (e) {
      MessageUtils.showErrorMessage(
        "Not able to fetch suggestions. Please try again.",
      );
    }
  }

  Future<List<LocationDTO>> fetchGooglePlacesSuggestions(String query) async {
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json',
        queryParameters: {
          'input': query,
          'key': _googlePlacesApiKey,
          'components': ApiConfig.countryComponent,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'OK') {
          final predictions = data['predictions'] as List;

          List<LocationDTO> suggestions = [];
          for (var prediction in predictions) {
            final placeId = prediction['place_id'];
            final coordinates = await _getPlaceDetails(placeId);

            if (coordinates != null) {
              suggestions.add(coordinates);
            }
          }
          return suggestions;
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  Future<LocationDTO?> _getPlaceDetails(String placeId) async {
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/details/json',
        queryParameters: {
          'place_id': placeId,
          'fields': ['formatted_address', 'geometry'].join(","),
          'key': _googlePlacesApiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'OK') {
          final location = data['result']['geometry']['location'];
          return LocationDTO(
            location['lat'],
            location['lng'],
            data['result']['formatted_address'],
          );
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
