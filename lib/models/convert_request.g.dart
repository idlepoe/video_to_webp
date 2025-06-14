// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConvertRequestImpl _$$ConvertRequestImplFromJson(Map<String, dynamic> json) =>
    _$ConvertRequestImpl(
      userId: json['userId'] as String,
      originalFile: json['originalFile'] as String,
      convertedFile: json['convertedFile'] as String?,
      status: json['status'] as String? ?? 'pending',
      options: ConvertOptions.fromJson(json['options'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$ConvertRequestImplToJson(
  _$ConvertRequestImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'originalFile': instance.originalFile,
  'convertedFile': instance.convertedFile,
  'status': instance.status,
  'options': instance.options,
  'createdAt': instance.createdAt?.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
};

_$ConvertOptionsImpl _$$ConvertOptionsImplFromJson(Map<String, dynamic> json) =>
    _$ConvertOptionsImpl(
      format: json['format'] as String,
      quality: (json['quality'] as num).toInt(),
      fps: (json['fps'] as num).toInt(),
      resolution: json['resolution'] as String,
    );

Map<String, dynamic> _$$ConvertOptionsImplToJson(
  _$ConvertOptionsImpl instance,
) => <String, dynamic>{
  'format': instance.format,
  'quality': instance.quality,
  'fps': instance.fps,
  'resolution': instance.resolution,
};
