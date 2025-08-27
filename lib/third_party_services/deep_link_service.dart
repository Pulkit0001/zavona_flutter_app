import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:zavona_flutter_app/third_party_services/crashlytics_service.dart';
import 'package:zavona_flutter_app/third_party_services/navigation_service.dart';

class DeepLinkService {
  static late AppLinks _appLinks;
  static StreamSubscription<Uri>? _linkSubscription;

  // Store navigation context for notification handling
  static GlobalKey<NavigatorState>? _navigatorKey;

  static initialize({GlobalKey<NavigatorState>? navigatorKey}) async {
    try {
      _navigatorKey = navigatorKey;
      _appLinks = AppLinks();
      _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
        debugPrint('onAppLink: $uri');
        var params = {...uri.queryParameters}
          ..putIfAbsent('route', () => uri.pathSegments.last);
        _handleDeeplinkNavigation(params);
      });
    } catch (error, stackTrace) {
      CrashlyticsService.recordError(error, stackTrace);
    }
  }

  /// Handles notification click and delegates to navigation handler
  static void _handleDeeplinkNavigation(Map<String, dynamic> data) {
    if (_navigatorKey?.currentContext != null) {
      NavigationService.handleDeepLink(data, _navigatorKey!.currentContext!);
    } else {
      log('Navigator context not available for notification navigation');
    }
  }

  /// Disposes the deep link service
  static void dispose() {
    _linkSubscription?.cancel();
  }
}
