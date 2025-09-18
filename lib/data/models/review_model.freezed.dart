// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) {
  return _ReviewModel.fromJson(json);
}

/// @nodoc
mixin _$ReviewModel {
  String get id => throw _privateConstructorUsedError;
  String get serviceRequestId => throw _privateConstructorUsedError;
  String get prestataireId => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  int get rating => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt =>
      throw _privateConstructorUsedError; // Informations supplémentaires
  String? get clientName => throw _privateConstructorUsedError;
  String? get serviceRequestTitle => throw _privateConstructorUsedError;

  /// Serializes this ReviewModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewModelCopyWith<ReviewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewModelCopyWith<$Res> {
  factory $ReviewModelCopyWith(
    ReviewModel value,
    $Res Function(ReviewModel) then,
  ) = _$ReviewModelCopyWithImpl<$Res, ReviewModel>;
  @useResult
  $Res call({
    String id,
    String serviceRequestId,
    String prestataireId,
    String clientId,
    int rating,
    String? comment,
    String? createdAt,
    String? updatedAt,
    String? clientName,
    String? serviceRequestTitle,
  });
}

/// @nodoc
class _$ReviewModelCopyWithImpl<$Res, $Val extends ReviewModel>
    implements $ReviewModelCopyWith<$Res> {
  _$ReviewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReviewModel
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
                        as String?,
            updatedAt:
                freezed == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as String?,
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
abstract class _$$ReviewModelImplCopyWith<$Res>
    implements $ReviewModelCopyWith<$Res> {
  factory _$$ReviewModelImplCopyWith(
    _$ReviewModelImpl value,
    $Res Function(_$ReviewModelImpl) then,
  ) = __$$ReviewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String serviceRequestId,
    String prestataireId,
    String clientId,
    int rating,
    String? comment,
    String? createdAt,
    String? updatedAt,
    String? clientName,
    String? serviceRequestTitle,
  });
}

/// @nodoc
class __$$ReviewModelImplCopyWithImpl<$Res>
    extends _$ReviewModelCopyWithImpl<$Res, _$ReviewModelImpl>
    implements _$$ReviewModelImplCopyWith<$Res> {
  __$$ReviewModelImplCopyWithImpl(
    _$ReviewModelImpl _value,
    $Res Function(_$ReviewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewModel
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
      _$ReviewModelImpl(
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
                    as String?,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as String?,
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
class _$ReviewModelImpl implements _ReviewModel {
  const _$ReviewModelImpl({
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

  factory _$ReviewModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewModelImplFromJson(json);

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
  final String? createdAt;
  @override
  final String? updatedAt;
  // Informations supplémentaires
  @override
  final String? clientName;
  @override
  final String? serviceRequestTitle;

  @override
  String toString() {
    return 'ReviewModel(id: $id, serviceRequestId: $serviceRequestId, prestataireId: $prestataireId, clientId: $clientId, rating: $rating, comment: $comment, createdAt: $createdAt, updatedAt: $updatedAt, clientName: $clientName, serviceRequestTitle: $serviceRequestTitle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewModelImpl &&
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

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewModelImplCopyWith<_$ReviewModelImpl> get copyWith =>
      __$$ReviewModelImplCopyWithImpl<_$ReviewModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewModelImplToJson(this);
  }
}

abstract class _ReviewModel implements ReviewModel {
  const factory _ReviewModel({
    required final String id,
    required final String serviceRequestId,
    required final String prestataireId,
    required final String clientId,
    required final int rating,
    final String? comment,
    final String? createdAt,
    final String? updatedAt,
    final String? clientName,
    final String? serviceRequestTitle,
  }) = _$ReviewModelImpl;

  factory _ReviewModel.fromJson(Map<String, dynamic> json) =
      _$ReviewModelImpl.fromJson;

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
  String? get createdAt;
  @override
  String? get updatedAt; // Informations supplémentaires
  @override
  String? get clientName;
  @override
  String? get serviceRequestTitle;

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewModelImplCopyWith<_$ReviewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
