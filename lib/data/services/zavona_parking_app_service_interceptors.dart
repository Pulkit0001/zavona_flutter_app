import 'package:dio/dio.dart';

/// Custom interceptor for ZavonaParkingAppService
class CustomInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Custom-Header'] = 'CustomValue';
    super.onRequest(options, handler);
  }
}
