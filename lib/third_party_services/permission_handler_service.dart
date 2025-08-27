import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zavona_flutter_app/core/presentation/widgets/open_app_settings_dialog.dart';

abstract class PermissionHandlerService {
  static Future<bool> requestPermissions(List<Permission> permissions) async {
    final status = await permissions.request();
    return !status.values.any((element) => !element.isGranted);
  }

  static Future<bool> isPermissionGranted(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  static Future<void> _openAppSettings() async {
    await openAppSettings();
  }

  static Future<void> showOpenSettingsDialog(BuildContext context, String message) async {
    try {
      showDialog(context: context, builder: (context) {
        return OpenAppSettingsDialog(onConfirm: _openAppSettings, message: message);
      });
    } catch (e) {
      // Handle any errors that occur while showing the dialog
    }
  }
}
