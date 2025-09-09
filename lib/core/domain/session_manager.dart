import 'dart:async';
import 'dart:developer';

import 'package:zavona_flutter_app/third_party_services/secure_storage_service.dart';

/// Singleton SessionManager class that manages user session data
/// and provides stream-based state management for multiple cubits
class SessionManager {
  // Private constructor for singleton pattern
  SessionManager._internal();

  // Static instance
  static SessionManager? _instance;

  // Stream controllers for reactive state management
  final StreamController<SessionState> _sessionStreamController =
      StreamController<SessionState>.broadcast();

  // Current session state
  SessionState _currentState = const SessionState.initial();

  // Flag to check if session is initialized
  bool _isInitialized = false;

  /// Get the singleton instance
  static SessionManager get instance {
    _instance ??= SessionManager._internal();
    return _instance!;
  }

  /// Stream to listen for session state changes
  Stream<SessionState> get sessionStream => _sessionStreamController.stream;

  /// Current session state
  SessionState get currentState => _currentState;

  /// Check if user is authenticated
  bool get isAuthenticated => _currentState.isAuthenticated;

  /// Get current user data
  Map<String, dynamic>? get userData => _currentState.userData;

  /// Get current access token
  String? get accessToken => _currentState.accessToken;

  /// Get current user ID
  String? get userId => _currentState.userId;

  /// Check if session manager is initialized
  bool get isInitialized => _isInitialized;

  /// Static method to initialize the session manager
  /// This should be called during app startup
  static Future<SessionManager> initialize() async {
    final sessionManager = SessionManager.instance;
    await sessionManager._loadFromStorage();
    return sessionManager;
  }

  /// Load session data from local storage
  Future<void> _loadFromStorage() async {
    try {
      log('SessionManager: Loading session data from storage');

      final accessToken = await LocalStorage.getAccessToken();
      final userId = await LocalStorage.getUserId();
      final userData = await LocalStorage.getUserData();

      if (accessToken != null && accessToken.isNotEmpty) {
        _updateState(
          SessionState.authenticated(
            accessToken: accessToken,
            userId: userId,
            userData: userData,
          ),
        );
        log('SessionManager: User session loaded - authenticated');
      } else {
        _updateState(const SessionState.unauthenticated());
        log('SessionManager: No valid session found - unauthenticated');
      }

      _isInitialized = true;
      log('SessionManager: Initialization completed');
    } catch (e, stackTrace) {
      log(
        'SessionManager: Error loading session data: $e',
        error: e,
        stackTrace: stackTrace,
      );
      _updateState(const SessionState.unauthenticated());
      _isInitialized = true;
    }
  }

  /// Update session state and notify listeners
  void _updateState(SessionState newState) {
    _currentState = newState;
    _sessionStreamController.add(newState);
    log('SessionManager: State updated to ${newState.status}');
  }

  /// Set user authentication data
  Future<void> setAuthentication({
    required String accessToken,
    String? userId,
    Map<String, dynamic>? userData,
  }) async {
    try {
      log('SessionManager: Setting authentication data');

      // Save to secure storage
      await LocalStorage.setAccessToken(accessToken);
      if (userId != null) {
        await LocalStorage.setUserId(userId);
      }
      if (userData != null) {
        await LocalStorage.setUserData(userData);
      }

      // Update state
      _updateState(
        SessionState.authenticated(
          accessToken: accessToken,
          userId: userId,
          userData: userData,
        ),
      );

      log('SessionManager: Authentication data saved successfully');
    } catch (e, stackTrace) {
      log(
        'SessionManager: Error setting authentication data: $e',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Update user data
  Future<void> updateUserData(Map<String, dynamic> userData) async {
    try {
      log('SessionManager: Updating user data');

      await LocalStorage.setUserData(userData);

      if (_currentState.isAuthenticated) {
        _updateState(
          SessionState.authenticated(
            accessToken: _currentState.accessToken!,
            userId: _currentState.userId,
            userData: userData,
          ),
        );
      }

      log('SessionManager: User data updated successfully');
    } catch (e, stackTrace) {
      log(
        'SessionManager: Error updating user data: $e',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Update access token
  Future<void> updateAccessToken(String accessToken) async {
    try {
      log('SessionManager: Updating access token');

      await LocalStorage.setAccessToken(accessToken);

      if (_currentState.isAuthenticated) {
        _updateState(
          SessionState.authenticated(
            accessToken: accessToken,
            userId: _currentState.userId,
            userData: _currentState.userData,
          ),
        );
      }

      log('SessionManager: Access token updated successfully');
    } catch (e, stackTrace) {
      log(
        'SessionManager: Error updating access token: $e',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Clear all session data and logout user
  Future<void> clearSession() async {
    try {
      log('SessionManager: Clearing session data');

      // Clear data from secure storage
      await LocalStorage.clearData();

      // Update state to unauthenticated
      _updateState(const SessionState.unauthenticated());

      log('SessionManager: Session cleared successfully');
    } catch (e, stackTrace) {
      log(
        'SessionManager: Error clearing session: $e',
        error: e,
        stackTrace: stackTrace,
      );
      // Even if storage clearing fails, update state to unauthenticated
      _updateState(const SessionState.unauthenticated());
      rethrow;
    }
  }

  /// Dispose resources
  void dispose() {
    _sessionStreamController.close();
    log('SessionManager: Disposed');
  }

  /// Reset singleton instance (useful for testing)
  static void resetInstance() {
    _instance?.dispose();
    _instance = null;
  }
}

/// Session state enum
enum SessionStatus { initial, authenticated, unauthenticated }

/// Session state class that holds the current session information
class SessionState {
  final SessionStatus status;
  final String? accessToken;
  final String? userId;
  final Map<String, dynamic>? userData;

  const SessionState._({
    required this.status,
    this.accessToken,
    this.userId,
    this.userData,
  });

  /// Initial state
  const SessionState.initial() : this._(status: SessionStatus.initial);

  /// Authenticated state
  const SessionState.authenticated({
    required String accessToken,
    String? userId,
    Map<String, dynamic>? userData,
  }) : this._(
         status: SessionStatus.authenticated,
         accessToken: accessToken,
         userId: userId,
         userData: userData,
       );

  /// Unauthenticated state
  const SessionState.unauthenticated()
    : this._(status: SessionStatus.unauthenticated);

  /// Check if user is authenticated
  bool get isAuthenticated =>
      status == SessionStatus.authenticated && accessToken != null;

  /// Check if state is initial
  bool get isInitial => status == SessionStatus.initial;

  /// Check if user is unauthenticated
  bool get isUnauthenticated => status == SessionStatus.unauthenticated;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SessionState &&
        other.status == status &&
        other.accessToken == accessToken &&
        other.userId == userId &&
        _mapEquals(other.userData, userData);
  }

  @override
  int get hashCode {
    return status.hashCode ^
        accessToken.hashCode ^
        userId.hashCode ^
        userData.hashCode;
  }

  @override
  String toString() {
    return 'SessionState(status: $status, accessToken: ${accessToken != null ? '***' : null}, userId: $userId, userData: ${userData != null ? 'present' : null})';
  }

  /// Helper method to compare maps
  bool _mapEquals(Map<String, dynamic>? a, Map<String, dynamic>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;

    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) {
        return false;
      }
    }
    return true;
  }
}
