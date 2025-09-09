import 'package:dio/dio.dart';
import 'package:zavona_flutter_app/third_party_services/secure_storage_service.dart';

/// Custom interceptor for ZavonaParkingAppService
class CustomInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Custom-Header'] = 'CustomValue';
    var token = await LocalStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}
