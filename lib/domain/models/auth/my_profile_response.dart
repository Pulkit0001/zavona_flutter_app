// To parse this JSON data, do
//
//     final myProfileResponse = myProfileResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'my_profile_response.freezed.dart';
part 'my_profile_response.g.dart';

MyProfileResponse myProfileResponseFromJson(String str) =>
    MyProfileResponse.fromJson(json.decode(str));

String myProfileResponseToJson(MyProfileResponse data) =>
    json.encode(data.toJson());

@freezed
abstract class MyProfileResponse with _$MyProfileResponse {
  const factory MyProfileResponse({
    @JsonKey(name: "success") bool? success,
    @JsonKey(name: "data") Data? data,
  }) = _MyProfileResponse;

  factory MyProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$MyProfileResponseFromJson(json);
}

@freezed
abstract class Data with _$Data {
  const factory Data({@JsonKey(name: "user") User? user}) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
abstract class User with _$User {
  const factory User({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "userId") String? userId,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "mobile") String? mobile,
    @JsonKey(name: "userRole") String? userRole,
    @JsonKey(name: "profileImage") dynamic profileImage,
    @JsonKey(name: "authMethods") List<String>? authMethods,
    @JsonKey(name: "emailVerified") bool? emailVerified,
    @JsonKey(name: "mobileVerified") bool? mobileVerified,
    @JsonKey(name: "kycStatus") String? kycStatus,
    @JsonKey(name: "kycDocs") List<String>? kycDocs,
    @JsonKey(name: "kycRemarks") String? kycRemarks,
    @JsonKey(name: "isActive") bool? isActive,
    @JsonKey(name: "isBlocked") bool? isBlocked,
    @JsonKey(name: "profileCompletion") ProfileCompletion? profileCompletion,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _User.fromJson(json);
}

@freezed
abstract class ProfileCompletion with _$ProfileCompletion {
  const factory ProfileCompletion({
    @JsonKey(name: "required") bool? required,
    @JsonKey(name: "message") String? message,
  }) = _ProfileCompletion;

  factory ProfileCompletion.fromJson(Map<String, dynamic> json) =>
      _ProfileCompletion.fromJson(json);
}
