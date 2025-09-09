// To parse this JSON data, do
//
//     final requestAuthOtpResponse = requestAuthOtpResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'request_auth_otp_response.freezed.dart';
part 'request_auth_otp_response.g.dart';

RequestAuthOtpResponse requestAuthOtpResponseFromJson(String str) => RequestAuthOtpResponse.fromJson(json.decode(str));

String requestAuthOtpResponseToJson(RequestAuthOtpResponse data) => json.encode(data.toJson());

@freezed
abstract class RequestAuthOtpResponse with _$RequestAuthOtpResponse {
  const factory RequestAuthOtpResponse({
    @JsonKey(name: "success")
    bool? success,
    @JsonKey(name: "message")
    String? message,
    @JsonKey(name: "data")
    Data? data,
  }) = _RequestAuthOtpResponse;

  factory RequestAuthOtpResponse.fromJson(Map<String, dynamic> json) => _$RequestAuthOtpResponseFromJson(json);
}

@freezed
abstract class Data with _$Data {
  const factory Data({
    @JsonKey(name: "identifier")
    String? identifier,
    @JsonKey(name: "identifierType")
    String? identifierType,
    @JsonKey(name: "purpose")
    String? purpose,
    @JsonKey(name: "isNewUser")
    bool? isNewUser,
    @JsonKey(name: "expiresIn")
    int? expiresIn,
    @JsonKey(name: "deliveryStatus")
    DeliveryStatus? deliveryStatus,
    @JsonKey(name: "developmentOTP")
    String? developmentOtp,
    @JsonKey(name: "note")
    String? note,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
abstract class DeliveryStatus with _$DeliveryStatus {
  const factory DeliveryStatus({
    @JsonKey(name: "emailSent")
    bool? emailSent,
  }) = _DeliveryStatus;

  factory DeliveryStatus.fromJson(Map<String, dynamic> json) => _$DeliveryStatusFromJson(json);
}
