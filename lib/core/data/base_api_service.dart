import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:zavona_flutter_app/core/domain/session_manager.dart';
import 'base_params.dart';

/// BaseApiService is a mixin that provides HTTP request capabilities
/// for microservices. It cannot be extended but can be mixed into classes.
/// This mixin handles all HTTP operations (GET, POST, PUT, PATCH, DELETE)
/// with generic type support and interceptor management.
mixin BaseApiService {
  static Dio? _dio;

  /// Get the Dio instance with configured interceptors
  Dio get dio {
    _dio ??= _createDioInstance();
    return _dio!;
  }

  /// Creates and configures the Dio instance with interceptors
  Dio _createDioInstance() {
    final dio = Dio();

    // Add pretty logger interceptor for development
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
    }

    // Add default interceptors
    _addDefaultInterceptors(dio);

    // Add custom interceptors from implementing classes
    addCustomInterceptors(dio);

    return dio;
  }

  /// Add default interceptors
  void _addDefaultInterceptors(Dio dio) {
    // Add auth interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add authentication headers if needed
          // options.headers['Authorization'] = 'Bearer $token';
          handler.next(options);
        },
        onResponse: (response, handler) {
          // Handle response globally
          handler.next(response);
        },
        onError: (error, handler) {
          // Handle errors globally
          _handleGlobalError(error);
          handler.next(error);
        },
      ),
    );
  }

  /// Override this method in implementing classes to add custom interceptors
  void addCustomInterceptors(Dio dio) {
    // Default implementation does nothing
    // Override this method in your service classes to add custom interceptors
  }

  /// Handle global errors
  void _handleGlobalError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        log('Connection timeout error: ${error.message}');
        break;
      case DioExceptionType.sendTimeout:
        log('Send timeout error: ${error.message}');
        break;
      case DioExceptionType.receiveTimeout:
        log('Receive timeout error: ${error.message}');
        break;
      case DioExceptionType.badResponse:
        log(
          'Bad response error: ${error.response?.statusCode} - ${error.message}',
        );
        break;
      case DioExceptionType.cancel:
        log('Request cancelled: ${error.message}');
        break;
      case DioExceptionType.connectionError:
        log('Connection error: ${error.message}');
        break;
      case DioExceptionType.badCertificate:
        log('Bad certificate error: ${error.message}');
        break;
      case DioExceptionType.unknown:
        log('Unknown error: ${error.message}');
        break;
    }
  }

  /// Generic GET request method
  /// [T] - Type of query parameters that extends BaseQueryParams
  /// [endpoint] - API endpoint URL
  /// [queryParams] - Query parameters object (optional)
  /// [headers] - Additional headers (optional)
  /// Returns Map<String, dynamic>? - Response data or null if no data
  Future<Map<String, dynamic>?> get<T extends BaseQueryParams>({
    required String endpoint,
    T? queryParams,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final options = Options(headers: headers, method: 'GET');

      final response = await dio.get<Map<String, dynamic>>(
        endpoint,
        queryParameters: queryParams?.toJson(),
        options: options,
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleApiError(e);
    } catch (e) {
      throw _handleGeneralError(e);
    }
  }

  /// Generic POST request method
  /// [T] - Type of request parameters that extends BaseRequestParams
  /// [endpoint] - API endpoint URL
  /// [requestParams] - Request body parameters object (optional)
  /// [headers] - Additional headers (optional)
  /// Returns Map<String, dynamic>? - Response data or null if no data
  Future<Map<String, dynamic>?> post<T extends BaseRequestParams>({
    required String endpoint,
    T? requestParams,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final options = Options(headers: headers, method: 'POST');

      final response = await dio.post<Map<String, dynamic>>(
        endpoint,
        data: requestParams?.toJson(),
        options: options,
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleApiError(e);
    } catch (e) {
      throw _handleGeneralError(e);
    }
  }

  /// Generic PUT request method
  /// [T] - Type of request parameters that extends BaseRequestParams
  /// [endpoint] - API endpoint URL
  /// [requestParams] - Request body parameters object (optional)
  /// [headers] - Additional headers (optional)
  /// Returns Map<String, dynamic>? - Response data or null if no data
  Future<Map<String, dynamic>?> put<T extends BaseRequestParams>({
    required String endpoint,
    T? requestParams,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final options = Options(headers: headers, method: 'PUT');

      final response = await dio.put<Map<String, dynamic>>(
        endpoint,
        data: requestParams?.toJson(),
        options: options,
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleApiError(e);
    } catch (e) {
      throw _handleGeneralError(e);
    }
  }

  /// Generic PATCH request method
  /// [T] - Type of request parameters that extends BaseRequestParams
  /// [endpoint] - API endpoint URL
  /// [requestParams] - Request body parameters object (optional)
  /// [headers] - Additional headers (optional)
  /// Returns Map<String, dynamic>? - Response data or null if no data
  Future<Map<String, dynamic>?> patch<T extends BaseRequestParams>({
    required String endpoint,
    T? requestParams,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final options = Options(headers: headers, method: 'PATCH');

      final response = await dio.patch<Map<String, dynamic>>(
        endpoint,
        data: requestParams?.toJson(),
        options: options,
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleApiError(e);
    } catch (e) {
      throw _handleGeneralError(e);
    }
  }

  /// Generic DELETE request method
  /// [T] - Type of query parameters that extends BaseQueryParams
  /// [endpoint] - API endpoint URL
  /// [queryParams] - Query parameters object (optional)
  /// [headers] - Additional headers (optional)
  /// Returns Map<String, dynamic>? - Response data or null if no data
  Future<Map<String, dynamic>?> delete<T extends BaseQueryParams>({
    required String endpoint,
    T? queryParams,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final options = Options(headers: headers, method: 'DELETE');

      final response = await dio.delete<Map<String, dynamic>>(
        endpoint,
        queryParameters: queryParams?.toJson(),
        options: options,
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleApiError(e);
    } catch (e) {
      throw _handleGeneralError(e);
    }
  }

  /// Handle API errors and convert them to appropriate exceptions
  Exception _handleApiError(DioException error) {
    // Try to extract server message from response
    String errorMessage =
        _extractServerMessage(error) ??
        error.message ??
        'Unknown error occurred';

    switch (error.response?.statusCode) {
      case 400:
        return BadRequestException(errorMessage);
      case 401:
        {
          SessionManager.instance.clearSession();
          return UnauthorizedException(errorMessage);
        }
      case 403:
        return ForbiddenException(errorMessage);
      case 404:
        return NotFoundException(errorMessage);
      case 422:
        return ValidationException(errorMessage);
      case 429:
        return RateLimitException(errorMessage);
      case 500:
        return InternalServerErrorException(errorMessage);
      case 502:
        return BadGatewayException(errorMessage);
      case 503:
        return ServiceUnavailableException(errorMessage);
      case 504:
        return GatewayTimeoutException(errorMessage);
      default:
        return ApiException(errorMessage, error.response?.statusCode);
    }
  }

  /// Extract server message from DioException response
  String? _extractServerMessage(DioException error) {
    try {
      final responseData = error.response?.data;
      if (responseData is Map<String, dynamic>) {
        // Check common message fields
        return responseData['message'] as String? ??
            responseData['error'] as String? ??
            responseData['detail'] as String? ??
            responseData['msg'] as String? ??
            responseData['error_description'] as String?;
      } else if (responseData is String) {
        return responseData;
      }
    } catch (e) {
      log('Error extracting server message: $e');
    }
    return null;
  }

  /// Handle general errors that are not DioException
  Exception _handleGeneralError(dynamic error) {
    if (error is Exception) {
      return GeneralApiException('Request failed: ${error.toString()}');
    } else {
      return GeneralApiException('Unexpected error: ${error.toString()}');
    }
  }
}

/// Custom API Exception classes
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() =>
      'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class BadRequestException extends ApiException {
  BadRequestException(String message) : super(message, 400);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message) : super(message, 401);
}

class ForbiddenException extends ApiException {
  ForbiddenException(String message) : super(message, 403);
}

class NotFoundException extends ApiException {
  NotFoundException(String message) : super(message, 404);
}

class InternalServerErrorException extends ApiException {
  InternalServerErrorException(String message) : super(message, 500);
}

class ValidationException extends ApiException {
  ValidationException(String message) : super(message, 422);
}

class RateLimitException extends ApiException {
  RateLimitException(String message) : super(message, 429);
}

class BadGatewayException extends ApiException {
  BadGatewayException(String message) : super(message, 502);
}

class ServiceUnavailableException extends ApiException {
  ServiceUnavailableException(String message) : super(message, 503);
}

class GatewayTimeoutException extends ApiException {
  GatewayTimeoutException(String message) : super(message, 504);
}

class GeneralApiException extends ApiException {
  GeneralApiException(String message) : super(message);
}
