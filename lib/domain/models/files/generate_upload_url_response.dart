// To parse this JSON data, do
//
//     final generateUploadUrlResponse = generateUploadUrlResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'generate_upload_url_response.freezed.dart';
part 'generate_upload_url_response.g.dart';

GenerateUploadUrlResponse generateUploadUrlResponseFromJson(String str) => GenerateUploadUrlResponse.fromJson(json.decode(str));

String generateUploadUrlResponseToJson(GenerateUploadUrlResponse data) => json.encode(data.toJson());

@freezed
abstract class GenerateUploadUrlResponse with _$GenerateUploadUrlResponse {
  const factory GenerateUploadUrlResponse({
    @JsonKey(name: "success")
    bool? success,
    @JsonKey(name: "uploadUrl")
    String? uploadUrl,
    @JsonKey(name: "key")
    String? key,
    @JsonKey(name: "expiresIn")
    int? expiresIn,
    @JsonKey(name: "fileType")
    String? fileType,
    @JsonKey(name: "maxSize")
    int? maxSize,
    @JsonKey(name: "allowedMimeTypes")
    List<String>? allowedMimeTypes,
    @JsonKey(name: "instructions")
    Instructions? instructions,
  }) = _GenerateUploadUrlResponse;

  factory GenerateUploadUrlResponse.fromJson(Map<String, dynamic> json) => _$GenerateUploadUrlResponseFromJson(json);
}

@freezed
abstract class Instructions with _$Instructions {
  const factory Instructions({
    @JsonKey(name: "method")
    String? method,
    @JsonKey(name: "headers")
    Headers? headers,
    @JsonKey(name: "note")
    String? note,
  }) = _Instructions;

  factory Instructions.fromJson(Map<String, dynamic> json) => _$InstructionsFromJson(json);
}

@freezed
abstract class Headers with _$Headers {
  const factory Headers({
    @JsonKey(name: "Content-Type")
    String? contentType,
  }) = _Headers;

  factory Headers.fromJson(Map<String, dynamic> json) => _$HeadersFromJson(json);
}
