// To parse this JSON data, do
//
//     final getParkingListResponse = getParkingListResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_parking_list_response.freezed.dart';
part 'get_parking_list_response.g.dart';

GetParkingListResponse getParkingListResponseFromJson(String str) =>
    GetParkingListResponse.fromJson(json.decode(str));

String getParkingListResponseToJson(GetParkingListResponse data) =>
    json.encode(data.toJson());

@freezed
abstract class GetParkingListResponse with _$GetParkingListResponse {
  const factory GetParkingListResponse({
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "data") List<Datum>? data,
    @JsonKey(name: "pagination") Pagination? pagination,
  }) = _GetParkingListResponse;

  factory GetParkingListResponse.fromJson(Map<String, dynamic> json) =>
      _$GetParkingListResponseFromJson(json);
}

@freezed
abstract class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "type") String? type,
    @JsonKey(name: "images") List<String>? images,
    @JsonKey(name: "isVerified") bool? isVerified,
    @JsonKey(name: "isActive") bool? isActive,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "areaSocietyName") String? areaSocietyName,
    @JsonKey(name: "address") String? address,
    @JsonKey(name: "coordinates") Coordinates? coordinates,
    @JsonKey(name: "thumbnailUrl") String? thumbnailUrl,
    @JsonKey(name: "owner") Owner? owner,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "spots") List<Spot>? spots,
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "distance") dynamic distance,
    @JsonKey(name: "distanceInKm") dynamic distanceInKm,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

@freezed
abstract class Coordinates with _$Coordinates {
  const factory Coordinates({
    @JsonKey(name: "latitude") num? latitude,
    @JsonKey(name: "longitude") num? longitude,
  }) = _Coordinates;

  factory Coordinates.fromJson(Map<String, dynamic> json) =>
      _$CoordinatesFromJson(json);
}

@freezed
abstract class Owner with _$Owner {
  const factory Owner({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "profileImage") String? profileImage,
    @JsonKey(name: "kycStatus") String? kycStatus,
  }) = _Owner;

  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);
}

@freezed
abstract class Spot with _$Spot {
  const factory Spot({
    @JsonKey(name: "parkingSize") List<String>? parkingSize,
    @JsonKey(name: "availableToSell") bool? availableToSell,
    @JsonKey(name: "availableToRent") bool? availableToRent,
    @JsonKey(name: "isVerified") bool? isVerified,
    @JsonKey(name: "isActive") bool? isActive,
    @JsonKey(name: "parkingNumber") String? parkingNumber,
    @JsonKey(name: "sellingPrice") num? sellingPrice,
    @JsonKey(name: "rentPricePerDay") num? rentPricePerDay,
    @JsonKey(name: "rentPricePerHour") num? rentPricePerHour,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "id") String? id,
  }) = _Spot;

  factory Spot.fromJson(Map<String, dynamic> json) => _$SpotFromJson(json);
}

@freezed
abstract class Pagination with _$Pagination {
  const factory Pagination({
    @JsonKey(name: "page") num? page,
    @JsonKey(name: "limit") num? limit,
    @JsonKey(name: "total") num? total,
    @JsonKey(name: "totalPages") num? totalPages,
  }) = _Pagination;

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);
}
