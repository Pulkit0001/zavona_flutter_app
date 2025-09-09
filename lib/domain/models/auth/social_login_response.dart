// To parse this JSON data, do
//
//     final socialLoginResponse = socialLoginResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'social_login_response.freezed.dart';
part 'social_login_response.g.dart';

SocialLoginResponse socialLoginResponseFromJson(String str) => SocialLoginResponse.fromJson(json.decode(str));

String socialLoginResponseToJson(SocialLoginResponse data) => json.encode(data.toJson());

@freezed
abstract class SocialLoginResponse with _$SocialLoginResponse {
  const factory SocialLoginResponse({
    @JsonKey(name: "success")
    bool? success,
    @JsonKey(name: "message")
    String? message,
    @JsonKey(name: "data")
    Data? data,
  }) = _SocialLoginResponse;

  factory SocialLoginResponse.fromJson(Map<String, dynamic> json) => _$SocialLoginResponseFromJson(json);
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
    @JsonKey(name: "provider")
    String? provider,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}
