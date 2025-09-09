import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zavona_flutter_app/presentation/auth/pages/otp_verification_screen.dart';
import 'package:zavona_flutter_app/presentation/auth/pages/splash_screen.dart';
import 'package:zavona_flutter_app/third_party_services/secure_storage_service.dart';
import '../../presentation/auth/pages/mobile_email_page.dart';
import '../../presentation/booking/pages/booking_page.dart';
import '../../presentation/booking/pages/booking_details_page.dart';
import '../../presentation/booking/pages/booking_requests_page.dart';
import '../../presentation/booking/pages/my_bookings_page.dart';
import '../../presentation/common/pages/select_location_page.dart';
import '../../presentation/dashboard/pages/dashboard_page.dart';
import '../../presentation/home/pages/home_page.dart';
import '../../presentation/profile/pages/profile_page.dart';
import '../../presentation/parking/pages/parking_create_page.dart';
import '../../presentation/parking/pages/my_parking_spots_page.dart';
import '../../presentation/parking/pages/update_parking_space_page.dart';
import '../../presentation/parking/pages/edit_profile_page.dart';
import '../../presentation/profile/pages/update_profile_page.dart';
import 'route_names.dart';

class AppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RouteNames.splash,
    routes: [
      // Splash route
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth routes
      GoRoute(
        path: RouteNames.mobileEmail,
        name: RouteNames.mobileEmail,
        builder: (context, state) => const MobileEmailPage(),
      ),
      GoRoute(
        path: RouteNames.otpVerify,
        name: RouteNames.otpVerify,
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>?;
          final identifier = extras?['identifier'] as String?;
          final identifierType = extras?['identifierType'] as String?;
          return OtpVerificationScreen(
            identifierType: identifierType ?? '',
            identifier: identifier ?? '',
          );
        },
      ),

      // Dashboard with nested routes
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) => DashboardPage(child: child),
        routes: [
          GoRoute(
            path: RouteNames.dashboard,
            name: RouteNames.home,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: RouteNames.profile,
            name: RouteNames.profile,
            builder: (context, state) => const ProfilePage(),
            redirect: _authGuard,
          ),
        ],
      ),

      // Common routes
      GoRoute(
        path: RouteNames.selectLocation,
        name: RouteNames.selectLocation,
        builder: (context, state) => const SelectLocationPage(),
      ),

      // Protected routes (require authentication)
      GoRoute(
        path: RouteNames.parkingCreate,
        name: RouteNames.parkingCreate,
        builder: (context, state) => const ParkingCreatePage(),
        redirect: _authGuard,
      ),
      GoRoute(
        path: RouteNames.booking,
        name: RouteNames.booking,
        builder: (context, state) {
          final parkingSpotId = state.extra as String?;
          return BookingPage(parkingSpotId: parkingSpotId);
        },
        redirect: _authGuard,
      ),
      GoRoute(
        path: RouteNames.bookingRequests,
        name: RouteNames.bookingRequests,
        builder: (context, state) => const BookingRequestsPage(),
        redirect: _authGuard,
      ),
      GoRoute(
        path: RouteNames.myBookings,
        name: RouteNames.myBookings,
        builder: (context, state) => const MyBookingsPage(),
        redirect: _authGuard,
      ),
      GoRoute(
        path: RouteNames.myParkingSpots,
        name: RouteNames.myParkingSpots,
        builder: (context, state) => const MyParkingSpotsPage(),
        redirect: _authGuard,
      ),
      GoRoute(
        path: RouteNames.editProfile,
        name: RouteNames.editProfile,
        builder: (context, state) => const EditProfilePage(),
        redirect: _authGuard,
      ),
      GoRoute(
        path: RouteNames.bookingDetails,
        name: RouteNames.bookingDetails,
        builder: (context, state) {
          final bookingId = state.pathParameters['bookingId']!;
          return BookingDetailsPage(bookingId: bookingId);
        },
        redirect: _authGuard,
      ),
      GoRoute(
        path: RouteNames.updateParkingSpace,
        name: RouteNames.updateParkingSpace,
        builder: (context, state) {
          final parkingSpaceId = state.pathParameters['parkingSpaceId']!;
          return UpdateParkingSpacePage(parkingSpaceId: parkingSpaceId);
        },
        redirect: _authGuard,
      ),
      GoRoute(
        path: RouteNames.updateProfile,
        name: RouteNames.updateProfile,
        builder: (context, state) => const UpdateProfilePage(),
        redirect: _authGuard,
      ),
    ],
  );

  // Auth guard to protect routes
  static Future<String?> _authGuard(
    BuildContext context,
    GoRouterState state,
  ) async {
    final isAuthenticated = await _isUserAuthenticated();

    if (!isAuthenticated) {
      return RouteNames.mobileEmail;
    }
    return null;
  }

  static Future<bool> _isUserAuthenticated() async {
    return (await LocalStorage.getAccessToken() ?? "").isNotEmpty;
  }
}
