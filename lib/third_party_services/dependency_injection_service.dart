import 'package:zavona_flutter_app/core/locator.dart';
import 'package:zavona_flutter_app/data/services/zavona_parking_app_service.dart';
import 'package:zavona_flutter_app/res/values/network_constants.dart';

Future<void> setUpLocator() async {
  locator.registerSingleton<ZavonaParkingAppService>(
    ZavonaParkingAppService(baseUrl: NetworkConstants.baseUrl),
  );
}
