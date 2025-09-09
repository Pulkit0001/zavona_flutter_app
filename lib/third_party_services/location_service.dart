import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zavona_flutter_app/core/presentation/utils/message_utils.dart';
import 'package:zavona_flutter_app/res/values/app_strings.dart';
import 'package:zavona_flutter_app/third_party_services/permission_handler_service.dart';

abstract class LocationService {
  static Future<LocationDTO?> getCurrentLocation(BuildContext context) async {
    try {
      var hasPermission = await PermissionHandlerService.requestPermissions([
        Permission.location,
        Permission.locationWhenInUse,
      ]);
      if (!hasPermission) {
        await PermissionHandlerService.showOpenSettingsDialog(
          context,
          AppStrings.kLocationPermissionDeniedMessage,
        );
        return null;
      }
      if (!(await Geolocator.isLocationServiceEnabled())) {
        await PermissionHandlerService.showOpenSettingsDialog(
          context,
          AppStrings.kLocationServiceDisabledMessage,
        );
        return null;
      }

      var position = await Geolocator.getLastKnownPosition();
      if (position != null) {
        var placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        String address = "";
        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          final street = placemark.subLocality ?? '';
          final locality = placemark.locality ?? '';
          final country = placemark.country ?? '';

          address =
              '$street${locality.isNotEmpty ? ', $locality' : ''}${country.isNotEmpty ? ', $country' : ''}';
          if (address.trim().startsWith(',')) {
            address = address.trim().substring(1).trim();
          }
        }
        return LocationDTO(position.latitude, position.longitude, address);
      }
      return null;
    } catch (e) {
      MessageUtils.showErrorMessage(AppStrings.kLocationNotFoundMessage);
      return null;
    }
  }
}

class LocationDTO {
  final double latitude;
  final double longitude;
  final String address;
  final bool isCurrentLocation;

  LocationDTO(
    this.latitude,
    this.longitude,
    this.address, {
    this.isCurrentLocation = false,
  });
}
