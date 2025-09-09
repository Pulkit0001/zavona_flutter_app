// To parse this JSON data, do
//
//     final commonApiResponse = commonApiResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'common_api_response.freezed.dart';
part 'common_api_response.g.dart';

CommonApiResponse commonApiResponseFromJson(String str) => CommonApiResponse.fromJson(json.decode(str));

String commonApiResponseToJson(CommonApiResponse data) => json.encode(data.toJson());

@freezed
abstract class CommonApiResponse with _$CommonApiResponse {
  const factory CommonApiResponse({
    @JsonKey(name: "success")
    bool? success,
    @JsonKey(name: "message")
    String? message,
  }) = _CommonApiResponse;

  factory CommonApiResponse.fromJson(Map<String, dynamic> json) => _$CommonApiResponseFromJson(json);
}
