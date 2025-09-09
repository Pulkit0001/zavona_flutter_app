import 'package:dartz/dartz.dart';
import 'package:zavona_flutter_app/core/core.dart';
import 'package:dio/dio.dart';

/// Generated service class for ZavonaParkingAppService
/// Base URL: https://api.example.com
/// Generated from Postman collection: Zavona - Parking App

import './zavona_parking_app_service_models.dart';
import './zavona_parking_app_service_interceptors.dart';

/// ZavonaParkingAppService with CRUD operations using BaseApiService
class ZavonaParkingAppService with BaseApiService {
  final String _baseUrl;

  ZavonaParkingAppService({
    required String baseUrl,
  }) : _baseUrl = baseUrl;

  @override
  void addCustomInterceptors(Dio dio) {
    dio.interceptors.add(CustomInterceptor());
  }

  /// POST /api/auth/request-otp
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> requestLoginregisterOtp( {
    RequestloginregisterotpRequestParams? requestParams,
  }) async {
    try {
      final response = await post<RequestloginregisterotpRequestParams>(
        endpoint: '$_baseUrl/api/auth/request-otp',
        requestParams: requestParams,
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// POST /api/auth/verify-otp
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> verifyOtp( {
    VerifyotpRequestParams? requestParams,
  }) async {
    try {
      final response = await post<VerifyotpRequestParams>(
        endpoint: '$_baseUrl/api/auth/verify-otp',
        requestParams: requestParams,
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// POST /api/auth/logout
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> logout( {
    LogoutRequestParams? requestParams,
  }) async {
    try {
      final response = await post<LogoutRequestParams>(
        endpoint: '$_baseUrl/api/auth/logout',
        requestParams: requestParams,
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// POST /api/auth/social-login
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> socialLogin( {
    SocialloginRequestParams? requestParams,
  }) async {
    try {
      final response = await post<SocialloginRequestParams>(
        endpoint: '$_baseUrl/api/auth/social-login',
        requestParams: requestParams,
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// GET /api/auth/me
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> myProfile() async {
    try {
      final response = await get(
        endpoint: '$_baseUrl/api/auth/me',
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// PUT /api/auth/update-firebase-token
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> updateFirebaseToken( {
    UpdatefirebasetokenRequestParams? requestParams,
  }) async {
    try {
      final response = await put<UpdatefirebasetokenRequestParams>(
        endpoint: '$_baseUrl/api/auth/update-firebase-token',
        requestParams: requestParams,
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// POST /api/files/upload-url
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> generateUploadUrl( {
    GenerateuploadurlRequestParams? requestParams,
  }) async {
    try {
      final response = await post<GenerateuploadurlRequestParams>(
        endpoint: '$_baseUrl/api/files/upload-url',
        requestParams: requestParams,
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// GET /api/files/:fileKey
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> getFileUrl( {
    required String filekey,
  }) async {
    try {
      final response = await get(
        endpoint: '$_baseUrl/api/files/$filekey',
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// GET /api/users
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> usersListing( {
    UserslistingQueryParams? queryParams,
  }) async {
    try {
      final response = await get<UserslistingQueryParams>(
        endpoint: '$_baseUrl/api/users',
        queryParams: queryParams,
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// PUT /api/users/:userId
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> updateProfile( {
    required String userid,
    UpdateprofileRequestParams? requestParams,
  }) async {
    try {
      final response = await put<UpdateprofileRequestParams>(
        endpoint: '$_baseUrl/api/users/$userid',
        requestParams: requestParams,
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// GET /api/users/:userId
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> getProfileDetails( {
    required String userid,
  }) async {
    try {
      final response = await get(
        endpoint: '$_baseUrl/api/users/$userid',
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// POST /api/parking
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> createResidentialParkingSpace( {
    CreateresidentialparkingspaceRequestParams? requestParams,
  }) async {
    try {
      final response = await post<CreateresidentialparkingspaceRequestParams>(
        endpoint: '$_baseUrl/api/parking',
        requestParams: requestParams,
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// GET /api/parking
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> listParkings( {
    ListparkingsQueryParams? queryParams,
  }) async {
    try {
      final response = await get<ListparkingsQueryParams>(
        endpoint: '$_baseUrl/api/parking',
        queryParams: queryParams,
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// GET /api/parking/:PARKING_SPACE_ID_HERE
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> getParkingSpaceDetails( {
    required String parkingSpaceIdHere,
  }) async {
    try {
      final response = await get(
        endpoint: '$_baseUrl/api/parking/$parkingSpaceIdHere',
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// PUT /api/parking/:PARKING_SPACE_ID_HERE
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> updateResidentialParkingSpace( {
    required String parkingSpaceIdHere,
    UpdateresidentialparkingspaceRequestParams? requestParams,
  }) async {
    try {
      final response = await put<UpdateresidentialparkingspaceRequestParams>(
        endpoint: '$_baseUrl/api/parking/$parkingSpaceIdHere',
        requestParams: requestParams,
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// DELETE /api/parking/:PARKING_SPACE_ID_HERE
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> deleteParkingSpace( {
    required String parkingSpaceIdHere,
  }) async {
    try {
      final response = await delete(
        endpoint: '$_baseUrl/api/parking/$parkingSpaceIdHere',
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// POST /api/property-interests
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> createPropertyInterest( {
    CreatepropertyinterestRequestParams? requestParams,
  }) async {
    try {
      final response = await post<CreatepropertyinterestRequestParams>(
        endpoint: '$_baseUrl/api/property-interests',
        requestParams: requestParams,
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// GET /api/property-interests
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> getAllPropertyInterests( {
    GetallpropertyinterestsQueryParams? queryParams,
  }) async {
    try {
      final response = await get<GetallpropertyinterestsQueryParams>(
        endpoint: '$_baseUrl/api/property-interests',
        queryParams: queryParams,
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// GET /api/property-interests/:INTEREST_ID
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> getParkingInterestDetails( {
    required String interestId,
  }) async {
    try {
      final response = await get(
        endpoint: '$_baseUrl/api/property-interests/$interestId',
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// PUT /api/property-interests/:INTEREST_ID
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> updateParkingInterest( {
    required String interestId,
  }) async {
    try {
      final response = await put(
        endpoint: '$_baseUrl/api/property-interests/$interestId',
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// POST /api/rental-bookings
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> createBooking( {
    CreatebookingRequestParams? requestParams,
  }) async {
    try {
      final response = await post<CreatebookingRequestParams>(
        endpoint: '$_baseUrl/api/rental-bookings',
        requestParams: requestParams,
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// GET /api/rental-bookings
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> getRentalBookings( {
    GetrentalbookingsQueryParams? queryParams,
  }) async {
    try {
      final response = await get<GetrentalbookingsQueryParams>(
        endpoint: '$_baseUrl/api/rental-bookings',
        queryParams: queryParams,
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// GET /api/rental-bookings/:BOOKING_ID
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> getBookingDetails( {
    required String bookingId,
  }) async {
    try {
      final response = await get(
        endpoint: '$_baseUrl/api/rental-bookings/$bookingId',
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// PUT /api/rental-bookings/:BOOKING_ID
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> updateBooking( {
    required String bookingId,
    UpdatebookingRequestParams? requestParams,
  }) async {
    try {
      final response = await put<UpdatebookingRequestParams>(
        endpoint: '$_baseUrl/api/rental-bookings/$bookingId',
        requestParams: requestParams,
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// PATCH /api/rental-bookings/:BOOKING_ID/confirm
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> confirmBookingByOwner( {
    required String bookingId,
  }) async {
    try {
      final response = await patch(
        endpoint: '$_baseUrl/api/rental-bookings/$bookingId/confirm',
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// PATCH /api/rental-bookings/:BOOKING_ID/reject
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> rejectBookingByOwner( {
    required String bookingId,
  }) async {
    try {
      final response = await patch(
        endpoint: '$_baseUrl/api/rental-bookings/$bookingId/reject',
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// PATCH /api/rental-bookings/:BOOKING_ID/cancel
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> cancelBookingByRenter( {
    required String bookingId,
  }) async {
    try {
      final response = await patch(
        endpoint: '$_baseUrl/api/rental-bookings/$bookingId/cancel',
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// PATCH /api/rental-bookings/:BOOKING_ID/payment
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> payForBookingByRenter( {
    required String bookingId,
  }) async {
    try {
      final response = await patch(
        endpoint: '$_baseUrl/api/rental-bookings/$bookingId/payment',
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// PATCH /api/rental-bookings/:BOOKING_ID/checkin
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> checkinByRenter( {
    required String bookingId,
  }) async {
    try {
      final response = await patch(
        endpoint: '$_baseUrl/api/rental-bookings/$bookingId/checkin',
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  /// PATCH /api/rental-bookings/:BOOKING_ID/checkout
  /// Returns `Either<String, Map<String, dynamic>?>` where:
  /// - Left: Error message
  /// - Right: Response data
  Future<Either<String, Map<String, dynamic>?>> checkoutByRenter( {
    required String bookingId,
  }) async {
    try {
      final response = await patch(
        endpoint: '$_baseUrl/api/rental-bookings/$bookingId/checkout',
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left('API Error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

}
