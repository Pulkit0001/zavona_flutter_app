// To parse this JSON data, do
//
//     final getFileUrlResponse = getFileUrlResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_file_url_response.freezed.dart';
part 'get_file_url_response.g.dart';

GetFileUrlResponse getFileUrlResponseFromJson(String str) => GetFileUrlResponse.fromJson(json.decode(str));

String getFileUrlResponseToJson(GetFileUrlResponse data) => json.encode(data.toJson());

@freezed
abstract class GetFileUrlResponse with _$GetFileUrlResponse {
  const factory GetFileUrlResponse({
    @JsonKey(name: "success")
    bool? success,
    @JsonKey(name: "url")
    String? url,
    @JsonKey(name: "type")
    String? type,
    @JsonKey(name: "fileType")
    String? fileType,
    @JsonKey(name: "expiresIn")
    String? expiresIn,
  }) = _GetFileUrlResponse;

  factory GetFileUrlResponse.fromJson(Map<String, dynamic> json) => _$GetFileUrlResponseFromJson(json);
}
