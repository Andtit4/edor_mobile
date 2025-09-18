// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Review _$ReviewFromJson(Map<String, dynamic> json) {
  return _Review.fromJson(json);
}

/// @nodoc
mixin _$Review {
  String get id => throw _privateConstructorUsedError;
  String get serviceRequestId => throw _privateConstructorUsedError;
  String get prestataireId => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  int get rating => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Informations supplémentaires
  String? get clientName => throw _privateConstructorUsedError;
  String? get serviceRequestTitle => throw _privateConstructorUsedError;

  /// Serializes this Review to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewCopyWith<Review> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewCopyWith<$Res> {
  factory $ReviewCopyWith(Review value, $Res Function(Review) then) =
      _$ReviewCopyWithImpl<$Res, Review>;
  @useResult
  $Res call({
    String id,
    String serviceRequestId,
    String prestataireId,
    String clientId,
    int rating,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? clientName,
    String? serviceRequestTitle,
  });
}

/// @nodoc
class _$ReviewCopyWithImpl<$Res, $Val extends Review>
    implements $ReviewCopyWith<$Res> {
  _$ReviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serviceRequestId = null,
    Object? prestataireId = null,
    Object? clientId = null,
    Object? rating = null,
    Object? comment = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? clientName = freezed,
    Object? serviceRequestTitle = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            serviceRequestId:
                null == serviceRequestId
                    ? _value.serviceRequestId
                    : serviceRequestId // ignore: cast_nullable_to_non_nullable
                        as String,
            prestataireId:
                null == prestataireId
                    ? _value.prestataireId
                    : prestataireId // ignore: cast_nullable_to_non_nullable
                        as String,
            clientId:
                null == clientId
                    ? _value.clientId
                    : clientId // ignore: cast_nullable_to_non_nullable
                        as String,
            rating:
                null == rating
                    ? _value.rating
                    : rating // ignore: cast_nullable_to_non_nullable
                        as int,
            comment:
                freezed == comment
                    ? _value.comment
                    : comment // ignore: cast_nullable_to_non_nullable
                        as String?,
            createdAt:
                freezed == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            updatedAt:
                freezed == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            clientName:
                freezed == clientName
                    ? _value.clientName
                    : clientName // ignore: cast_nullable_to_non_nullable
                        as String?,
            serviceRequestTitle:
                freezed == serviceRequestTitle
                    ? _value.serviceRequestTitle
                    : serviceRequestTitle // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReviewImplCopyWith<$Res> implements $ReviewCopyWith<$Res> {
  factory _$$ReviewImplCopyWith(
    _$ReviewImpl value,
    $Res Function(_$ReviewImpl) then,
  ) = __$$ReviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String serviceRequestId,
    String prestataireId,
    String clientId,
    int rating,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? clientName,
    String? serviceRequestTitle,
  });
}

/// @nodoc
class __$$ReviewImplCopyWithImpl<$Res>
    extends _$ReviewCopyWithImpl<$Res, _$ReviewImpl>
    implements _$$ReviewImplCopyWith<$Res> {
  __$$ReviewImplCopyWithImpl(
    _$ReviewImpl _value,
    $Res Function(_$ReviewImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serviceRequestId = null,
    Object? prestataireId = null,
    Object? clientId = null,
    Object? rating = null,
    Object? comment = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? clientName = freezed,
    Object? serviceRequestTitle = freezed,
  }) {
    return _then(
      _$ReviewImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        serviceRequestId:
            null == serviceRequestId
                ? _value.serviceRequestId
                : serviceRequestId // ignore: cast_nullable_to_non_nullable
                    as String,
        prestataireId:
            null == prestataireId
                ? _value.prestataireId
                : prestataireId // ignore: cast_nullable_to_non_nullable
                    as String,
        clientId:
            null == clientId
                ? _value.clientId
                : clientId // ignore: cast_nullable_to_non_nullable
                    as String,
        rating:
            null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                    as int,
        comment:
            freezed == comment
                ? _value.comment
                : comment // ignore: cast_nullable_to_non_nullable
                    as String?,
        createdAt:
            freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        clientName:
            freezed == clientName
                ? _value.clientName
                : clientName // ignore: cast_nullable_to_non_nullable
                    as String?,
        serviceRequestTitle:
            freezed == serviceRequestTitle
                ? _value.serviceRequestTitle
                : serviceRequestTitle // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewImpl implements _Review {
  const _$ReviewImpl({
    required this.id,
    required this.serviceRequestId,
    required this.prestataireId,
    required this.clientId,
    required this.rating,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.clientName,
    this.serviceRequestTitle,
  });

  factory _$ReviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewImplFromJson(json);

  @override
  final String id;
  @override
  final String serviceRequestId;
  @override
  final String prestataireId;
  @override
  final String clientId;
  @override
  final int rating;
  @override
  final String? comment;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  // Informations supplémentaires
  @override
  final String? clientName;
  @override
  final String? serviceRequestTitle;

  @override
  String toString() {
    return 'Review(id: $id, serviceRequestId: $serviceRequestId, prestataireId: $prestataireId, clientId: $clientId, rating: $rating, comment: $comment, createdAt: $createdAt, updatedAt: $updatedAt, clientName: $clientName, serviceRequestTitle: $serviceRequestTitle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serviceRequestId, serviceRequestId) ||
                other.serviceRequestId == serviceRequestId) &&
            (identical(other.prestataireId, prestataireId) ||
                other.prestataireId == prestataireId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.clientName, clientName) ||
                other.clientName == clientName) &&
            (identical(other.serviceRequestTitle, serviceRequestTitle) ||
                other.serviceRequestTitle == serviceRequestTitle));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    serviceRequestId,
    prestataireId,
    clientId,
    rating,
    comment,
    createdAt,
    updatedAt,
    clientName,
    serviceRequestTitle,
  );

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewImplCopyWith<_$ReviewImpl> get copyWith =>
      __$$ReviewImplCopyWithImpl<_$ReviewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewImplToJson(this);
  }
}

abstract class _Review implements Review {
  const factory _Review({
    required final String id,
    required final String serviceRequestId,
    required final String prestataireId,
    required final String clientId,
    required final int rating,
    final String? comment,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final String? clientName,
    final String? serviceRequestTitle,
  }) = _$ReviewImpl;

  factory _Review.fromJson(Map<String, dynamic> json) = _$ReviewImpl.fromJson;

  @override
  String get id;
  @override
  String get serviceRequestId;
  @override
  String get prestataireId;
  @override
  String get clientId;
  @override
  int get rating;
  @override
  String? get comment;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt; // Informations supplémentaires
  @override
  String? get clientName;
  @override
  String? get serviceRequestTitle;

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewImplCopyWith<_$ReviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
