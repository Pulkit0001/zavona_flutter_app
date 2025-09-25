// To parse this JSON data, do
//
//     final getRentalBookingsListResponse = getRentalBookingsListResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_rental_bookings_list_response.freezed.dart';
part 'get_rental_bookings_list_response.g.dart';

GetRentalBookingsListResponse getRentalBookingsListResponseFromJson(String str) => GetRentalBookingsListResponse.fromJson(json.decode(str));

String getRentalBookingsListResponseToJson(GetRentalBookingsListResponse data) => json.encode(data.toJson());

@freezed
abstract class GetRentalBookingsListResponse with _$GetRentalBookingsListResponse {
    const factory GetRentalBookingsListResponse({
        @JsonKey(name: "success")
        bool? success,
        @JsonKey(name: "message")
        String? message,
        @JsonKey(name: "bookings")
        List<Booking>? bookings,
        @JsonKey(name: "pagination")
        Pagination? pagination,
    }) = _GetRentalBookingsListResponse;

    factory GetRentalBookingsListResponse.fromJson(Map<String, dynamic> json) => _$GetRentalBookingsListResponseFromJson(json);
}

@freezed
abstract class Booking with _$Booking {
    const factory Booking({
        @JsonKey(name: "id")
        String? id,
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
    }) = _Booking;

    factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);
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
        @JsonKey(name: "_id")
        String? id,
        @JsonKey(name: "name")
        String? name,
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
abstract class ParkingSpot with _$ParkingSpot {
    const factory ParkingSpot({
        @JsonKey(name: "_id")
        String? id,
        @JsonKey(name: "parkingSize")
        List<String>? parkingSize,
        @JsonKey(name: "parkingNumber")
        String? parkingNumber,
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

@freezed
abstract class Pagination with _$Pagination {
    const factory Pagination({
        @JsonKey(name: "currentPage")
        int? currentPage,
        @JsonKey(name: "totalPages")
        int? totalPages,
        @JsonKey(name: "totalBookings")
        int? totalBookings,
        @JsonKey(name: "bookingsPerPage")
        int? bookingsPerPage,
        @JsonKey(name: "hasNextPage")
        bool? hasNextPage,
        @JsonKey(name: "hasPrevPage")
        bool? hasPrevPage,
        @JsonKey(name: "nextPage")
        dynamic nextPage,
        @JsonKey(name: "prevPage")
        dynamic prevPage,
    }) = _Pagination;

    factory Pagination.fromJson(Map<String, dynamic> json) => _$PaginationFromJson(json);
}
