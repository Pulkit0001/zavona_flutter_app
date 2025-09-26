// To parse this JSON data, do
//
//     final parkingDetailsResponse = parkingDetailsResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'parking_details_response.freezed.dart';
part 'parking_details_response.g.dart';

ParkingDetailsResponse parkingDetailsResponseFromJson(String str) =>
    ParkingDetailsResponse.fromJson(json.decode(str));

String parkingDetailsResponseToJson(ParkingDetailsResponse data) =>
    json.encode(data.toJson());

@freezed
abstract class ParkingDetailsResponse with _$ParkingDetailsResponse {
  const factory ParkingDetailsResponse({
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "data") Data? data,
  }) = _ParkingDetailsResponse;

  factory ParkingDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$ParkingDetailsResponseFromJson(json);
}

@freezed
abstract class Data with _$Data {
  const factory Data({
    @JsonKey(name: "parkingSpace") ParkingSpace? parkingSpace,
    @JsonKey(name: "parkingSpot") List<ParkingSpot>? parkingSpot,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
abstract class ParkingSpace with _$ParkingSpace {
  const factory ParkingSpace({
    @JsonKey(name: "coordinates") Coordinates? coordinates,
    @JsonKey(name: "type") String? type,
    @JsonKey(name: "images") List<String>? images,
    @JsonKey(name: "isVerified") bool? isVerified,
    @JsonKey(name: "isActive") bool? isActive,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "areaSocietyName") String? areaSocietyName,
    @JsonKey(name: "address") String? address,
    @JsonKey(name: "thumbnailUrl") String? thumbnailUrl,
    @JsonKey(name: "owner") Owner? owner,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "id") String? id,
  }) = _ParkingSpace;

  factory ParkingSpace.fromJson(Map<String, dynamic> json) =>
      _$ParkingSpaceFromJson(json);
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
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "profileImage") dynamic profileImage,
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "email") String? email,
  }) = _Owner;

  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);
}

@freezed
abstract class ParkingSpot with _$ParkingSpot {
  const factory ParkingSpot({
    @JsonKey(name: "parkingSize") List<String>? parkingSize,
    @JsonKey(name: "availableToSell") bool? availableToSell,
    @JsonKey(name: "availableToRent") bool? availableToRent,
    @JsonKey(name: "isVerified") bool? isVerified,
    @JsonKey(name: "isActive") bool? isActive,
    @JsonKey(name: "parkingNumber") String? parkingNumber,
    @JsonKey(name: "parkingSpace") String? parkingSpace,
    @JsonKey(name: "sellingPrice") num? sellingPrice,
    @JsonKey(name: "rentPricePerDay") num? rentPricePerDay,
    @JsonKey(name: "rentPricePerHour") num? rentPricePerHour,
    @JsonKey(name: "owner") String? owner,
    @JsonKey(name: "amenities") List<String>? amenities,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "isAvailable") bool? isAvailable,
    @JsonKey(name: "id") String? id,
  }) = _ParkingSpot;

  factory ParkingSpot.fromJson(Map<String, dynamic> json) =>
      _$ParkingSpotFromJson(json);
}
