// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'convert_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConvertRequest _$ConvertRequestFromJson(Map<String, dynamic> json) {
  return _ConvertRequest.fromJson(json);
}

/// @nodoc
mixin _$ConvertRequest {
  String get userId => throw _privateConstructorUsedError;
  String get originalFile => throw _privateConstructorUsedError;
  String? get convertedFile => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  ConvertOptions get options => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this ConvertRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConvertRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConvertRequestCopyWith<ConvertRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConvertRequestCopyWith<$Res> {
  factory $ConvertRequestCopyWith(
          ConvertRequest value, $Res Function(ConvertRequest) then) =
      _$ConvertRequestCopyWithImpl<$Res, ConvertRequest>;
  @useResult
  $Res call(
      {String userId,
      String originalFile,
      String? convertedFile,
      String status,
      ConvertOptions options,
      DateTime? createdAt,
      DateTime? completedAt});

  $ConvertOptionsCopyWith<$Res> get options;
}

/// @nodoc
class _$ConvertRequestCopyWithImpl<$Res, $Val extends ConvertRequest>
    implements $ConvertRequestCopyWith<$Res> {
  _$ConvertRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConvertRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? originalFile = null,
    Object? convertedFile = freezed,
    Object? status = null,
    Object? options = null,
    Object? createdAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      originalFile: null == originalFile
          ? _value.originalFile
          : originalFile // ignore: cast_nullable_to_non_nullable
              as String,
      convertedFile: freezed == convertedFile
          ? _value.convertedFile
          : convertedFile // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as ConvertOptions,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of ConvertRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConvertOptionsCopyWith<$Res> get options {
    return $ConvertOptionsCopyWith<$Res>(_value.options, (value) {
      return _then(_value.copyWith(options: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConvertRequestImplCopyWith<$Res>
    implements $ConvertRequestCopyWith<$Res> {
  factory _$$ConvertRequestImplCopyWith(_$ConvertRequestImpl value,
          $Res Function(_$ConvertRequestImpl) then) =
      __$$ConvertRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String originalFile,
      String? convertedFile,
      String status,
      ConvertOptions options,
      DateTime? createdAt,
      DateTime? completedAt});

  @override
  $ConvertOptionsCopyWith<$Res> get options;
}

/// @nodoc
class __$$ConvertRequestImplCopyWithImpl<$Res>
    extends _$ConvertRequestCopyWithImpl<$Res, _$ConvertRequestImpl>
    implements _$$ConvertRequestImplCopyWith<$Res> {
  __$$ConvertRequestImplCopyWithImpl(
      _$ConvertRequestImpl _value, $Res Function(_$ConvertRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConvertRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? originalFile = null,
    Object? convertedFile = freezed,
    Object? status = null,
    Object? options = null,
    Object? createdAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_$ConvertRequestImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      originalFile: null == originalFile
          ? _value.originalFile
          : originalFile // ignore: cast_nullable_to_non_nullable
              as String,
      convertedFile: freezed == convertedFile
          ? _value.convertedFile
          : convertedFile // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as ConvertOptions,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConvertRequestImpl implements _ConvertRequest {
  const _$ConvertRequestImpl(
      {required this.userId,
      required this.originalFile,
      this.convertedFile,
      this.status = 'pending',
      required this.options,
      this.createdAt,
      this.completedAt});

  factory _$ConvertRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConvertRequestImplFromJson(json);

  @override
  final String userId;
  @override
  final String originalFile;
  @override
  final String? convertedFile;
  @override
  @JsonKey()
  final String status;
  @override
  final ConvertOptions options;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'ConvertRequest(userId: $userId, originalFile: $originalFile, convertedFile: $convertedFile, status: $status, options: $options, createdAt: $createdAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConvertRequestImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.originalFile, originalFile) ||
                other.originalFile == originalFile) &&
            (identical(other.convertedFile, convertedFile) ||
                other.convertedFile == convertedFile) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.options, options) || other.options == options) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, originalFile,
      convertedFile, status, options, createdAt, completedAt);

  /// Create a copy of ConvertRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConvertRequestImplCopyWith<_$ConvertRequestImpl> get copyWith =>
      __$$ConvertRequestImplCopyWithImpl<_$ConvertRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConvertRequestImplToJson(
      this,
    );
  }
}

abstract class _ConvertRequest implements ConvertRequest {
  const factory _ConvertRequest(
      {required final String userId,
      required final String originalFile,
      final String? convertedFile,
      final String status,
      required final ConvertOptions options,
      final DateTime? createdAt,
      final DateTime? completedAt}) = _$ConvertRequestImpl;

  factory _ConvertRequest.fromJson(Map<String, dynamic> json) =
      _$ConvertRequestImpl.fromJson;

  @override
  String get userId;
  @override
  String get originalFile;
  @override
  String? get convertedFile;
  @override
  String get status;
  @override
  ConvertOptions get options;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get completedAt;

  /// Create a copy of ConvertRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConvertRequestImplCopyWith<_$ConvertRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConvertOptions _$ConvertOptionsFromJson(Map<String, dynamic> json) {
  return _ConvertOptions.fromJson(json);
}

/// @nodoc
mixin _$ConvertOptions {
  String get format => throw _privateConstructorUsedError;
  int get quality => throw _privateConstructorUsedError;
  int get fps => throw _privateConstructorUsedError;
  String get resolution => throw _privateConstructorUsedError;
  double get startTime => throw _privateConstructorUsedError;
  double? get endTime => throw _privateConstructorUsedError;
  double get speed => throw _privateConstructorUsedError;

  /// Serializes this ConvertOptions to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConvertOptions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConvertOptionsCopyWith<ConvertOptions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConvertOptionsCopyWith<$Res> {
  factory $ConvertOptionsCopyWith(
          ConvertOptions value, $Res Function(ConvertOptions) then) =
      _$ConvertOptionsCopyWithImpl<$Res, ConvertOptions>;
  @useResult
  $Res call(
      {String format,
      int quality,
      int fps,
      String resolution,
      double startTime,
      double? endTime,
      double speed});
}

/// @nodoc
class _$ConvertOptionsCopyWithImpl<$Res, $Val extends ConvertOptions>
    implements $ConvertOptionsCopyWith<$Res> {
  _$ConvertOptionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConvertOptions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? format = null,
    Object? quality = null,
    Object? fps = null,
    Object? resolution = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? speed = null,
  }) {
    return _then(_value.copyWith(
      format: null == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String,
      quality: null == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as int,
      fps: null == fps
          ? _value.fps
          : fps // ignore: cast_nullable_to_non_nullable
              as int,
      resolution: null == resolution
          ? _value.resolution
          : resolution // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as double,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as double?,
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConvertOptionsImplCopyWith<$Res>
    implements $ConvertOptionsCopyWith<$Res> {
  factory _$$ConvertOptionsImplCopyWith(_$ConvertOptionsImpl value,
          $Res Function(_$ConvertOptionsImpl) then) =
      __$$ConvertOptionsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String format,
      int quality,
      int fps,
      String resolution,
      double startTime,
      double? endTime,
      double speed});
}

/// @nodoc
class __$$ConvertOptionsImplCopyWithImpl<$Res>
    extends _$ConvertOptionsCopyWithImpl<$Res, _$ConvertOptionsImpl>
    implements _$$ConvertOptionsImplCopyWith<$Res> {
  __$$ConvertOptionsImplCopyWithImpl(
      _$ConvertOptionsImpl _value, $Res Function(_$ConvertOptionsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConvertOptions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? format = null,
    Object? quality = null,
    Object? fps = null,
    Object? resolution = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? speed = null,
  }) {
    return _then(_$ConvertOptionsImpl(
      format: null == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String,
      quality: null == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as int,
      fps: null == fps
          ? _value.fps
          : fps // ignore: cast_nullable_to_non_nullable
              as int,
      resolution: null == resolution
          ? _value.resolution
          : resolution // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as double,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as double?,
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConvertOptionsImpl implements _ConvertOptions {
  const _$ConvertOptionsImpl(
      {required this.format,
      required this.quality,
      required this.fps,
      required this.resolution,
      this.startTime = 0.0,
      this.endTime,
      this.speed = 1.0});

  factory _$ConvertOptionsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConvertOptionsImplFromJson(json);

  @override
  final String format;
  @override
  final int quality;
  @override
  final int fps;
  @override
  final String resolution;
  @override
  @JsonKey()
  final double startTime;
  @override
  final double? endTime;
  @override
  @JsonKey()
  final double speed;

  @override
  String toString() {
    return 'ConvertOptions(format: $format, quality: $quality, fps: $fps, resolution: $resolution, startTime: $startTime, endTime: $endTime, speed: $speed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConvertOptionsImpl &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.quality, quality) || other.quality == quality) &&
            (identical(other.fps, fps) || other.fps == fps) &&
            (identical(other.resolution, resolution) ||
                other.resolution == resolution) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.speed, speed) || other.speed == speed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, format, quality, fps, resolution, startTime, endTime, speed);

  /// Create a copy of ConvertOptions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConvertOptionsImplCopyWith<_$ConvertOptionsImpl> get copyWith =>
      __$$ConvertOptionsImplCopyWithImpl<_$ConvertOptionsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConvertOptionsImplToJson(
      this,
    );
  }
}

abstract class _ConvertOptions implements ConvertOptions {
  const factory _ConvertOptions(
      {required final String format,
      required final int quality,
      required final int fps,
      required final String resolution,
      final double startTime,
      final double? endTime,
      final double speed}) = _$ConvertOptionsImpl;

  factory _ConvertOptions.fromJson(Map<String, dynamic> json) =
      _$ConvertOptionsImpl.fromJson;

  @override
  String get format;
  @override
  int get quality;
  @override
  int get fps;
  @override
  String get resolution;
  @override
  double get startTime;
  @override
  double? get endTime;
  @override
  double get speed;

  /// Create a copy of ConvertOptions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConvertOptionsImplCopyWith<_$ConvertOptionsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
