import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class LocalStorage {
  static const String _kAccessTokenKey = 'access-token';
  static const String _kUserIdKey = 'user-id';
  static const String _kUserDataKey = 'user-data';

  static final _storage = FlutterSecureStorage(
    aOptions: _getAndroidOptions(),
    iOptions: _getIOSOptions(),
  );

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _kAccessTokenKey);
  }

  static Future<void> setAccessToken(String token) async {
    await _storage.write(key: _kAccessTokenKey, value: token);
  }

  static Future<String?> getUserId() async {
    return await _storage.read(key: _kUserIdKey);
  }

  static Future<void> setUserId(String? userId) async {
    if (userId != null) {
      await _storage.write(key: _kUserIdKey, value: userId);
    }
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    var dataString = await _storage.read(key: _kUserDataKey);
    if (dataString != null) {
      return json.decode(dataString);
    }
    return null;
  }

  static Future<void> setUserData(Map<String, dynamic>? userData) async {
    if (userData != null) {
      await _storage.write(key: _kUserDataKey, value: json.encode(userData));
    }
  }

  static Future<void> clearData() async {
    await _storage.deleteAll();
  }

  static AndroidOptions _getAndroidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);

  static IOSOptions _getIOSOptions() =>
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);
}
