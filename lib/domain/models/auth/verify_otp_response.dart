// To parse this JSON data, do
//
//     final verifyOtpResponse = verifyOtpResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'verify_otp_response.freezed.dart';
part 'verify_otp_response.g.dart';

VerifyOtpResponse verifyOtpResponseFromJson(String str) => VerifyOtpResponse.fromJson(json.decode(str));

String verifyOtpResponseToJson(VerifyOtpResponse data) => json.encode(data.toJson());

@freezed
abstract class VerifyOtpResponse with _$VerifyOtpResponse {
  const factory VerifyOtpResponse({
    @JsonKey(name: "success")
    bool? success,
    @JsonKey(name: "message")
    String? message,
    @JsonKey(name: "data")
    Data? data,
  }) = _VerifyOtpResponse;

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) => _$VerifyOtpResponseFromJson(json);
}

@freezed
abstract class Data with _$Data {
  const factory Data({
    @JsonKey(name: "token")
    String? token,
    @JsonKey(name: "isNewUser")
    bool? isNewUser,
    @JsonKey(name: "sessionId")
    String? sessionId,
    @JsonKey(name: "loginAt")
    DateTime? loginAt,
    @JsonKey(name: "profileCompletion")
    ProfileCompletion? profileCompletion,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
abstract class ProfileCompletion with _$ProfileCompletion {
  const factory ProfileCompletion({
    @JsonKey(name: "required")
    bool? required,
    @JsonKey(name: "message")
    String? message,
  }) = _ProfileCompletion;

  factory ProfileCompletion.fromJson(Map<String, dynamic> json) => _$ProfileCompletionFromJson(json);
}
