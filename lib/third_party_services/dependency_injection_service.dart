import 'package:zavona_flutter_app/core/locator.dart';
import 'package:zavona_flutter_app/data/services/zavona_parking_app_service.dart';
import 'package:zavona_flutter_app/domain/repositories/auth_repository.dart';
import 'package:zavona_flutter_app/domain/repositories/bookings_repository.dart';
import 'package:zavona_flutter_app/domain/repositories/file_repository.dart';
import 'package:zavona_flutter_app/domain/repositories/parkings_repository.dart';
import 'package:zavona_flutter_app/domain/repositories/profile_repository.dart';
import 'package:zavona_flutter_app/res/values/network_constants.dart';
import 'package:zavona_flutter_app/third_party_services/razorpay_payment_service.dart';

Future<void> setUpLocator() async {
  locator.registerSingleton<ZavonaParkingAppService>(
    ZavonaParkingAppService(baseUrl: NetworkConstants.baseUrl),
  );
  locator.registerSingleton<AuthRepository>(AuthRepository());
  locator.registerSingleton<FileRepository>(FileRepository());
  locator.registerSingleton<ProfileRepository>(ProfileRepository());
  locator.registerSingleton<ParkingsRepository>(ParkingsRepository());
  locator.registerSingleton<BookingsRepository>(BookingsRepository());

  // Initialize RazorPay payment service
  final razorpayService = RazorpayPaymentService();
  razorpayService.initialize();
  locator.registerSingleton<RazorpayPaymentService>(razorpayService);
}
