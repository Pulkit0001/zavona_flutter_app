import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/router/route_names.dart';

class NavigationService {
  static final Map<String, String> _routeMap = {
    'mobileEmail': RouteNames.mobileEmail,
    'otpVerify': RouteNames.otpVerify,
    'dashboard': RouteNames.dashboard,
    'home': RouteNames.home,
    'profile': RouteNames.profile,
    'selectLocation': RouteNames.selectLocation,
    'parkingCreate': RouteNames.parkingCreate,
    'booking': RouteNames.booking,
    'bookingRequests': RouteNames.bookingRequests,
    'myBookings': RouteNames.myBookings,
    'myParkingSpots': RouteNames.myParkingSpots,
    'editProfile': RouteNames.editProfile,
    'bookingDetails': RouteNames.bookingDetails,
    'updateParkingSpace': RouteNames.updateParkingSpace,
    'updateProfile': RouteNames.editProfile,
  };

  /// Handles notification navigation based on payload
  ///
  /// Expected payload format:
  /// {
  ///   "route": "bookingDetails",  // matches the key in _routeMap
  ///   "bookingId": "123",         // parameter for the route
  ///   "parkingSpaceId": "456"     // another parameter if needed
  /// }
  static void handleDeepLink(Map<String, dynamic> data, BuildContext context) {
    try {
      log('Handling notification click with data: $data');

      final String? routeKey = data['route'];
      if (routeKey == null) {
        log('No route key found in notification data');
        return;
      }

      final String? routePath = _routeMap[routeKey];
      if (routePath == null) {
        log('Unknown route key: $routeKey');
        return;
      }

      // Build the final path by replacing parameters
      String finalPath = _buildPathWithParams(routePath, data);

      log('Navigating to: $finalPath');
      GoRouter.of(context).go(finalPath);
    } catch (error) {
      log('Error handling notification navigation: $error');
    }
  }

  /// Builds the final path by replacing route parameters with actual values
  static String _buildPathWithParams(
    String routePath,
    Map<String, dynamic> data,
  ) {
    String path = routePath;

    // Replace path parameters with actual values from notification data
    data.forEach((key, value) {
      if (key != 'route' && value != null) {
        path = path.replaceAll(':$key', value.toString());
      }
    });

    return path;
  }

  /// Helper method to build paths programmatically
  static String buildPath(String routeKey, {Map<String, String>? params}) {
    final String? routePath = _routeMap[routeKey];
    if (routePath == null) {
      throw ArgumentError('Unknown route key: $routeKey');
    }

    if (params == null) return routePath;

    String path = routePath;
    params.forEach((key, value) {
      path = path.replaceAll(':$key', value);
    });

    return path;
  }

  /// Get all available route keys for reference
  static List<String> get availableRoutes => _routeMap.keys.toList();
}
