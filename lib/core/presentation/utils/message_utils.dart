import 'package:fluttertoast/fluttertoast.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';

abstract class MessageUtils {

  static const String defaultErrorMessage = "Something went wrong. Please try again later.";

  static void showSuccessMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: AppColors.success,
      textColor: AppColors.onSuccess,
      fontSize: 16.0,
    );
  }

  static void showErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: AppColors.error,
      textColor: AppColors.onError,
      fontSize: 16.0,
    );
  }

  static void showWarningMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColors.warning,
      textColor: AppColors.onWarning,
      fontSize: 16.0,
    );
  }

  static void showInfoMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColors.info,
      textColor: AppColors.onInfo,
      fontSize: 16.0,
    );
  }
}
