import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zavona_flutter_app/core/presentation/utils/message_utils.dart';
import 'package:zavona_flutter_app/res/values/app_strings.dart';
import 'package:zavona_flutter_app/third_party_services/permission_handler_service.dart';

abstract class LocationService {
  static Future<LatLng?> getCurrentLocation(BuildContext context) async {
    try {
      var hasPermission = await PermissionHandlerService.requestPermissions([
        Permission.location,
        Permission.locationAlways,
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
        return LatLng(position.latitude, position.longitude);
      }
      return null;
    } catch (e) {
      MessageUtils.showErrorMessage(AppStrings.kLocationNotFoundMessage);
      return null;
    }
  }
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);
}
