import 'package:freezed_annotation/freezed_annotation.dart';

part 'convert_request.freezed.dart';
part 'convert_request.g.dart';

@freezed
class ConvertRequest with _$ConvertRequest {
  const factory ConvertRequest({
    required String userId,
    required String originalFile,
    String? convertedFile,
    @Default('pending') String status,
    required ConvertOptions options,
    DateTime? createdAt,
    DateTime? completedAt,
  }) = _ConvertRequest;

  factory ConvertRequest.fromJson(Map<String, dynamic> json) =>
      _$ConvertRequestFromJson(json);
}

@freezed
class ConvertOptions with _$ConvertOptions {
  const factory ConvertOptions({
    required String format,
    required int quality,
    required int fps,
    required String resolution,
    @Default(0.0) double startTime,
    double? endTime,
  }) = _ConvertOptions;

  factory ConvertOptions.fromJson(Map<String, dynamic> json) =>
      _$ConvertOptionsFromJson(json);
}
