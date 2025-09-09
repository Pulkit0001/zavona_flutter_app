class RouteNames {
  // Splash route
  static const String splash = '/splash';

  // Auth routes
  static const String mobileEmail = '/mobile-email';
  static const String otpVerify = '/otp-verify';

  // Dashboard routes
  static const String dashboard = '/';
  static const String home = 'home';
  static const String profile = '/profile';

  // Common routes
  static const String selectLocation = '/select-location';

  // Protected routes
  static const String parkingCreate = '/parking-create';
  static const String booking = '/booking';
  static const String bookingRequests = '/booking-requests';
  static const String myBookings = '/my-bookings';
  static const String myParkingSpots = '/my-parking-spots';
  static const String editProfile = '/edit-profile';
  static const String bookingDetails = '/booking-details/:bookingId';
  static const String updateParkingSpace =
      '/update-parking-space/:parkingSpaceId';
  static const String updateProfile = '/update-profile';
}
