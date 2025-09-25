import 'package:zavona_flutter_app/core/domain/base_repository.dart';
import 'package:zavona_flutter_app/core/locator.dart';
import 'package:zavona_flutter_app/data/services/zavona_parking_app_service.dart';
import 'package:zavona_flutter_app/data/services/zavona_parking_app_service_models.dart';
import 'package:zavona_flutter_app/domain/models/bookings/get_rental_bookings_list_response.dart';
import 'package:zavona_flutter_app/domain/models/bookings/rental_booking_details_response.dart';
import 'package:zavona_flutter_app/domain/models/common_api_response.dart';
import 'package:zavona_flutter_app/domain/models/parking/get_parking_list_response.dart';

class BookingsRepository extends BaseRepository {
  ZavonaParkingAppService apiService = locator<ZavonaParkingAppService>();

  Future<CommonApiResponse> createBooking({
    required String parkingspace,
    required String parkingspot,
    required String renter,
    required String checkindatetime,
    required String checkoutdatetime,
    required String pricingRatetype,
    required num pricingRate,
    required num pricingPlatformfee,
  }) async {
    try {
      var res = await apiService.createBooking(
        requestParams: CreatebookingRequestParams(
          parkingspace: parkingspace,
          parkingspot: parkingspot,
          renter: renter,
          checkindatetime: checkindatetime,
          checkoutdatetime: checkoutdatetime,
          pricingRatetype: pricingRatetype,
          pricingRate: pricingRate,
          pricingPlatformfee: pricingPlatformfee,
        ),
      );
      return super.handleApiResponse(res, CommonApiResponse.fromJson);
    } catch (e, str) {
      throw super.handleException(e, str);
    }
  }

  Future<RentalBookingDetailsResponse> getBookingDetails({
    required String bookingId,
  }) async {
    try {
      var res = await apiService.getBookingDetails(bookingId: bookingId);
      return super.handleApiResponse(res, RentalBookingDetailsResponse.fromJson);
    } catch (e, str) {
      throw super.handleException(e, str);
    }
  }

  Future<GetRentalBookingsListResponse> listBookings({
    required int page,
    required int limit,
     String? owner,
    List<String>? status,
    String? renter,
    String? search,
    String? sortby,
  }) async {
    try {
      var res = await apiService.getRentalBookings(
        queryParams: GetrentalbookingsQueryParams(
          page: page.toString(),
          limit: limit.toString(),
          status: status,
          owner: owner,
          renter: renter,
          search: search,
          sortby: sortby,
        ),
      );
      return super.handleApiResponse(res, GetRentalBookingsListResponse.fromJson);
    } catch (e, str) {
      throw super.handleException(e, str);
    }
  }

  Future<CommonApiResponse> rejectBooking({required String bookingId}) async {
    try {
      var res = await apiService.rejectBookingByOwner(bookingId: bookingId);
      return super.handleApiResponse(res, CommonApiResponse.fromJson);
    } catch (e, str) {
      throw super.handleException(e, str);
    }
  }

  Future<CommonApiResponse> cancelBooking({required String bookingId}) async {
    try {
      var res = await apiService.cancelBookingByRenter(bookingId: bookingId);
      return super.handleApiResponse(res, CommonApiResponse.fromJson);
    } catch (e, str) {
      throw super.handleException(e, str);
    }
  }

  Future<CommonApiResponse> acceptBooking({required String bookingId}) async {
    try {
      var res = await apiService.confirmBookingByOwner(bookingId: bookingId);
      return super.handleApiResponse(res, CommonApiResponse.fromJson);
    } catch (e, str) {
      throw super.handleException(e, str);
    }
  }
}
