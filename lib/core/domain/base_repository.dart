import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:zavona_flutter_app/core/presentation/utils/message_utils.dart';

import 'ui_exception.dart';

abstract class BaseRepository {
  T handleApiResponse<T>(
    Either<String, Map<String, dynamic>?> response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      return response.fold(
        (left) => throw UIException(
          left.split(":").firstOrNull?.trim() == "API Error"
              ? left.split(":").lastOrNull?.trim() ??
                    MessageUtils.defaultErrorMessage
              : MessageUtils.defaultErrorMessage,
        ),
        (right) => right != null
            ? fromJson(right)
            : throw UIException(MessageUtils.defaultErrorMessage),
      );
    } catch (e, str) {
      log("==================== Error in parsing ====================");
      log(e.toString());
      log(str.toString());
      log("=========================================================");
      throw UIException(MessageUtils.defaultErrorMessage);
    }
  }

  UIException handleException(Object e, StackTrace str) {
    log("==================== Exception Caught ====================");
    log(e.toString());
    log(str.toString());
    log("=========================================================");
    if (e is UIException) {
      return e;
    } else {
      return UIException(MessageUtils.defaultErrorMessage);
    }
  }
}
