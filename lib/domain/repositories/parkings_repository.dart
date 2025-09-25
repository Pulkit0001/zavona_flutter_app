import 'package:zavona_flutter_app/core/domain/base_repository.dart';
import 'package:zavona_flutter_app/core/locator.dart';
import 'package:zavona_flutter_app/data/services/zavona_parking_app_service.dart';
import 'package:zavona_flutter_app/data/services/zavona_parking_app_service_models.dart';
import 'package:zavona_flutter_app/domain/models/common_api_response.dart';
import 'package:zavona_flutter_app/domain/models/parking/get_parking_list_response.dart';
import 'package:zavona_flutter_app/domain/models/parking/parking_details_response.dart';

class ParkingsRepository extends BaseRepository {
  ZavonaParkingAppService apiService = locator<ZavonaParkingAppService>();

  Future<CommonApiResponse> createParking({
    required String parkingNumber,
    required String societyName,
    required String address,
    required double latitude,
    required double longitude,
    required List<String> docs,
    required String thumbnail,
    required List<String> availableVehicleSizes,
    required String ownerId,
    required bool isAvailableToRent,
    required bool isAvailableToSell,
    double? rentPricePerHour,
    double? rentPricePerDay,
    double? sellingPrice,
  }) async {
    try {
      var res = await apiService.createResidentialParkingSpace(
        requestParams: CreateresidentialparkingspaceRequestParams(
          name: parkingNumber,
          type: "residential",
          areasocietyname: societyName,
          address: address,
          coordinatesLatitude: latitude,
          coordinatesLongitude: longitude,
          images: docs,
          thumbnailurl: thumbnail,
          owner: ownerId,
          parkingnumber: parkingNumber,
          parkingsize: availableVehicleSizes,
          availabletosell: isAvailableToSell,
          availabletorent: isAvailableToRent,
          sellingprice: sellingPrice,
          rentpriceperday: rentPricePerHour,
          rentpriceperhour: rentPricePerDay,
        ),
      );
      return super.handleApiResponse(res, CommonApiResponse.fromJson);
    } catch (e, str) {
      throw super.handleException(e, str);
    }
  }

  Future<CommonApiResponse> updateParking({
    required String parkingSpaceId,
    required String parkingNumber,
    required String societyName,
    required String address,
    required double latitude,
    required double longitude,
    required List<String> docs,
    required String thumbnail,
    required List<String> availableVehicleSizes,
    required String ownerId,
    required bool isAvailableToRent,
    required bool isAvailableToSell,
    double? rentPricePerHour,
    double? rentPricePerDay,
    double? sellingPrice,
    required bool isVerified,
  }) async {
    try {
      var res = await apiService.updateResidentialParkingSpace(
        parkingSpaceIdHere: parkingSpaceId,
        requestParams: UpdateresidentialparkingspaceRequestParams(
          name: parkingNumber,
          areasocietyname: societyName,
          address: address,
          coordinatesLatitude: latitude,
          coordinatesLongitude: longitude,
          images: docs,
          thumbnailurl: thumbnail,
          parkingnumber: parkingNumber,
          parkingsize: availableVehicleSizes,
          availabletosell: isAvailableToSell,
          availabletorent: isAvailableToRent,
          sellingprice: sellingPrice,
          rentpriceperday: rentPricePerHour,
          rentpriceperhour: rentPricePerDay,
          isverified: isVerified,
        ),
      );
      return super.handleApiResponse(res, CommonApiResponse.fromJson);
    } catch (e, str) {
      throw super.handleException(e, str);
    }
  }

  Future<ParkingDetailsResponse> getParkingById(String parkingSpaceId) async {
    try {
      var res = await apiService.getParkingSpaceDetails(
        parkingSpaceIdHere: parkingSpaceId,
      );
      return super.handleApiResponse(res, ParkingDetailsResponse.fromJson);
    } catch (e, str) {
      throw super.handleException(e, str);
    }
  }

  Future<GetParkingListResponse> listParkings({
    required int page,
    required int limit,
     double? latitude,
     double? longitude,
     String? maxDistance,
    String? owner,
    String? societyName,
    String? isVerified,
    String? minSellingPrice,
    String? maxSellingPrice,
    String? minRentPricePerDay,
    String? maxRentPricePerDay,
    String? minRentPricePerHour,
    String? maxRentPricePerHour,
    String? availableToSell,
    String? availableToRent,
  }) async {
    try {
      var res = await apiService.listParkings(
        queryParams: ListparkingsQueryParams(
          page: page.toString(),
          limit: limit.toString(),
          isverified: isVerified,
          owner: owner,
          areasocietyname: societyName,
          latitude: latitude,
          longitude: longitude,
          maxdistance: maxDistance,
          minsellingprice: minSellingPrice,
          maxsellingprice: maxSellingPrice,
          minrentpriceperday: minRentPricePerDay,
          maxrentpriceperday: maxRentPricePerDay,
          minrentpriceperhour: minRentPricePerHour,
          maxrentpriceperhour: maxRentPricePerHour,
          availabletosell: availableToSell,
          availabletorent: availableToRent,
        ),
      );
      return super.handleApiResponse(res, GetParkingListResponse.fromJson);
    } catch (e, str) {
      throw super.handleException(e, str);
    }
  }
}
