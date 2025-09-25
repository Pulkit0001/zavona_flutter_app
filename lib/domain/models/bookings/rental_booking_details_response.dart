// To parse this JSON data, do
//
//     final rentalBookingDetailsResponse = rentalBookingDetailsResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'rental_booking_details_response.freezed.dart';
part 'rental_booking_details_response.g.dart';

RentalBookingDetailsResponse rentalBookingDetailsResponseFromJson(String str) => RentalBookingDetailsResponse.fromJson(json.decode(str));

String rentalBookingDetailsResponseToJson(RentalBookingDetailsResponse data) => json.encode(data.toJson());

@freezed
abstract class RentalBookingDetailsResponse with _$RentalBookingDetailsResponse {
    const factory RentalBookingDetailsResponse({
        @JsonKey(name: "success")
        bool? success,
        @JsonKey(name: "data")
        Data? data,
    }) = _RentalBookingDetailsResponse;

    factory RentalBookingDetailsResponse.fromJson(Map<String, dynamic> json) => _$RentalBookingDetailsResponseFromJson(json);
}

@freezed
abstract class Data with _$Data {
    const factory Data({
        @JsonKey(name: "pricing")
        Pricing? pricing,
        @JsonKey(name: "gracePeriods")
        GracePeriods? gracePeriods,
        @JsonKey(name: "status")
        String? status,
        @JsonKey(name: "isActive")
        bool? isActive,
        @JsonKey(name: "parkingSpace")
        ParkingSpace? parkingSpace,
        @JsonKey(name: "parkingSpot")
        ParkingSpot? parkingSpot,
        @JsonKey(name: "renter")
        Owner? renter,
        @JsonKey(name: "owner")
        Owner? owner,
        @JsonKey(name: "checkInDateTime")
        DateTime? checkInDateTime,
        @JsonKey(name: "checkOutDateTime")
        DateTime? checkOutDateTime,
        @JsonKey(name: "expiresAt")
        DateTime? expiresAt,
        @JsonKey(name: "createdAt")
        DateTime? createdAt,
        @JsonKey(name: "updatedAt")
        DateTime? updatedAt,
        @JsonKey(name: "isCurrentlyActive")
        bool? isCurrentlyActive,
        @JsonKey(name: "isExpired")
        bool? isExpired,
        @JsonKey(name: "isCheckInOverdue")
        bool? isCheckInOverdue,
        @JsonKey(name: "isCheckOutOverdue")
        bool? isCheckOutOverdue,
        @JsonKey(name: "id")
        String? id,
    }) = _Data;

    factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
abstract class GracePeriods with _$GracePeriods {
    const factory GracePeriods({
        @JsonKey(name: "lateCheckIn")
        int? lateCheckIn,
        @JsonKey(name: "lateCheckOut")
        int? lateCheckOut,
    }) = _GracePeriods;

    factory GracePeriods.fromJson(Map<String, dynamic> json) => _$GracePeriodsFromJson(json);
}

@freezed
abstract class Owner with _$Owner {
    const factory Owner({
        @JsonKey(name: "name")
        String? name,
        @JsonKey(name: "_id")
        String? id,
        @JsonKey(name: "email")
        String? email,
        @JsonKey(name: "profileImage")
        dynamic profileImage,
    }) = _Owner;

    factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);
}

@freezed
abstract class ParkingSpace with _$ParkingSpace {
    const factory ParkingSpace({
        @JsonKey(name: "coordinates")
        Coordinates? coordinates,
        @JsonKey(name: "_id")
        String? id,
        @JsonKey(name: "name")
        String? name,
        @JsonKey(name: "areaSocietyName")
        String? areaSocietyName,
        @JsonKey(name: "address")
        String? address,
        @JsonKey(name: "thumbnailUrl")
        String? thumbnailUrl,
    }) = _ParkingSpace;

    factory ParkingSpace.fromJson(Map<String, dynamic> json) => _$ParkingSpaceFromJson(json);
}

@freezed
abstract class Coordinates with _$Coordinates {
    const factory Coordinates({
        @JsonKey(name: "latitude")
        double? latitude,
        @JsonKey(name: "longitude")
        double? longitude,
    }) = _Coordinates;

    factory Coordinates.fromJson(Map<String, dynamic> json) => _$CoordinatesFromJson(json);
}

@freezed
abstract class ParkingSpot with _$ParkingSpot {
    const factory ParkingSpot({
        @JsonKey(name: "parkingSize")
        List<String>? parkingSize,
        @JsonKey(name: "_id")
        String? id,
        @JsonKey(name: "parkingNumber")
        String? parkingNumber,
        @JsonKey(name: "id")
        String? parkingSpotId,
    }) = _ParkingSpot;

    factory ParkingSpot.fromJson(Map<String, dynamic> json) => _$ParkingSpotFromJson(json);
}

@freezed
abstract class Pricing with _$Pricing {
    const factory Pricing({
        @JsonKey(name: "duration")
        Duration? duration,
        @JsonKey(name: "platformFee")
        int? platformFee,
        @JsonKey(name: "rateType")
        String? rateType,
        @JsonKey(name: "rate")
        int? rate,
        @JsonKey(name: "totalAmount")
        int? totalAmount,
        @JsonKey(name: "finalAmount")
        int? finalAmount,
    }) = _Pricing;

    factory Pricing.fromJson(Map<String, dynamic> json) => _$PricingFromJson(json);
}

@freezed
abstract class Duration with _$Duration {
    const factory Duration({
        @JsonKey(name: "hours")
        int? hours,
        @JsonKey(name: "days")
        int? days,
    }) = _Duration;

    factory Duration.fromJson(Map<String, dynamic> json) => _$DurationFromJson(json);
}
