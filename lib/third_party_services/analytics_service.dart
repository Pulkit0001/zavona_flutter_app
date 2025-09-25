import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:zavona_flutter_app/core/domain/session_manager.dart';
import 'package:zavona_flutter_app/domain/models/auth/my_profile_response.dart';

abstract class AnalyticsService {
  static FirebaseAnalytics? _analytics;

  static bool _isInitialized = false;
  static bool _isInitializing = false;

  static bool get isInitialized => _isInitialized;

  /// Initialize Firebase Analytics
  static Future<void> initialize() async {
    try {
      if (_isInitialized || _isInitializing) {
        return;
      }
      _isInitializing = true;
      _analytics = FirebaseAnalytics.instance;

      // Enable analytics collection based on build mode
      await _analytics?.setAnalyticsCollectionEnabled(true);
      // Set user properties from stored user data
      if (!_isInitialized) {
        await _setUserProperties();
      }

      _isInitialized = true;
      _isInitializing = false;

      if (kDebugMode) {
        log('Firebase Analytics initialized successfully');
      }
    } catch (e, stack) {
      if (kDebugMode) {
        log('Error initializing Firebase Analytics: $e\n$stack');
      }
    }
  }

  /// Sets user properties in Firebase Analytics
  static Future<void> _setUserProperties() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      final userData = SessionManager.instance.userData;

      if (userData != null && userData.isNotEmpty) {
        final user = User.fromJson(userData);

        // Set user ID
        if (user.id != null) {
          await _analytics?.setUserId(id: user.id.toString());
        }

        // Set user properties
        if (user.name != null) {
          await _analytics?.setUserProperty(
            name: 'user_name',
            value: user.name,
          );
        }

        if (user.email != null) {
          await _analytics?.setUserProperty(
            name: 'user_email',
            value: user.email,
          );
        }

        if (user.mobile != null) {
          await _analytics?.setUserProperty(
            name: 'user_mobile',
            value: user.mobile,
          );
        }
      }
    } catch (e, stack) {
      if (kDebugMode) {
        log('Error setting user properties: $e\n$stack');
      }
    }
  }

  /// Update user properties when user data changes
  static Future<void> updateUserProperties(User user) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      if (user.id != null) {
        await _analytics?.setUserId(id: user.id.toString());
      }

      if (user.name != null) {
        await _analytics?.setUserProperty(name: 'user_name', value: user.name);
      }

      if (user.email != null) {
        await _analytics?.setUserProperty(
          name: 'user_email',
          value: user.email,
        );
      }

      if (user.mobile != null) {
        await _analytics?.setUserProperty(
          name: 'user_mobile',
          value: user.mobile,
        );
      }
    } catch (e, stack) {
      if (kDebugMode) {
        log('Error updating user properties: $e\n$stack');
      }
    }
  }
}
