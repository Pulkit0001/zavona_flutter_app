import 'dart:developer';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:zavona_flutter_app/third_party_services/secure_storage_service.dart';

abstract class CrashlyticsService {
  static Future<void> initialize() async {
    try {
      // Enable or disable Crashlytics collection based on build mode
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        !kDebugMode,
      );

      // Setup global error handlers
      if (!kDebugMode) {
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

        PlatformDispatcher.instance.onError = (error, stack) {
          FirebaseCrashlytics.instance.recordError(error, stack);
          return true;
        };
      } else {
        FlutterError.onError = (FlutterErrorDetails details) {
          FlutterError.dumpErrorToConsole(details);
        };

        PlatformDispatcher.instance.onError = (error, stack) {
          log("Unhandled platform error: $error\n$stack");
          return true;
        };
      }

      final userId = (await LocalStorage.getUserId()) ?? 'guest_user';
      await FirebaseCrashlytics.instance.setUserIdentifier(userId);
    } catch (e, stack) {
      if (kDebugMode) {
        log("Crashlytics initialization error: $e\n$stack");
      }
    }
  }

  static void recordError(
    dynamic error,
    StackTrace stackTrace, {
    bool isFatal = false,
  }) {
    if (!kDebugMode) {
      try {
        FirebaseCrashlytics.instance.recordError(
          error,
          stackTrace,
          fatal: isFatal,
        );
      } catch (e) {
        log("Error sending to Crashlytics: $e");
      }
    } else {
      log("Debug error: $error\n$stackTrace");
    }
  }
}
