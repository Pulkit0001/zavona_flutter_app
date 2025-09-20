import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zavona_flutter_app/core/presentation/utils/message_utils.dart';
import 'package:zavona_flutter_app/core/presentation/widgets/image_source_selector.dart';
import 'package:zavona_flutter_app/res/values/app_strings.dart';
import 'package:zavona_flutter_app/third_party_services/permission_handler_service.dart';

abstract class FilePickerService {
  static Future<XFile?> pickSingleImage(BuildContext context) async {
    try {
      var res = await showModalBottomSheet<ImageSource?>(
        context: context,
        isScrollControlled: true,
        builder: ImageSourceSelector.builder,
      );
      if (res == null) return null;
      final hasPermission = await PermissionHandlerService.requestPermissions([
        res == ImageSource.camera ? Permission.camera : Permission.photos,
      ]);
      if (!hasPermission) {
        PermissionHandlerService.showOpenSettingsDialog(
          context,
          res == ImageSource.camera
              ? AppStrings.kCameraPermissionDeniedMessage
              : AppStrings.kGalleryPermissionDeniedMessage,
        );
        return null;
      }

      final picker = ImagePicker();
      return picker.pickImage(source: res);
    } catch (e) {
      MessageUtils.showErrorMessage(AppStrings.kGeneralErrorMessage);
      return null;
    }
  }

  static Future<List<XFile>?> pickMultipleImages(BuildContext context) async {
    try {
      final hasPermission = await PermissionHandlerService.requestPermissions([
        Permission.photos,
      ]);
      if (!hasPermission) {
        PermissionHandlerService.showOpenSettingsDialog(
          context,
          AppStrings.kPermissionDeniedMessage,
        );
        return null;
      }
      final picker = ImagePicker();
      return picker.pickMultiImage();
    } catch (e) {
      MessageUtils.showErrorMessage(AppStrings.kGeneralErrorMessage);
      return null;
    }
  }
}
