// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_negotiation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PriceNegotiationModel _$PriceNegotiationModelFromJson(
  Map<String, dynamic> json,
) {
  return _PriceNegotiationModel.fromJson(json);
}

/// @nodoc
mixin _$PriceNegotiationModel {
  String get id => throw _privateConstructorUsedError;
  String get serviceRequestId => throw _privateConstructorUsedError;
  String get prestataireId => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  double get proposedPrice => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  bool get isFromPrestataire => throw _privateConstructorUsedError;
  String? get parentNegotiationId => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PriceNegotiationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PriceNegotiationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PriceNegotiationModelCopyWith<PriceNegotiationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PriceNegotiationModelCopyWith<$Res> {
  factory $PriceNegotiationModelCopyWith(
    PriceNegotiationModel value,
    $Res Function(PriceNegotiationModel) then,
  ) = _$PriceNegotiationModelCopyWithImpl<$Res, PriceNegotiationModel>;
  @useResult
  $Res call({
    String id,
    String serviceRequestId,
    String prestataireId,
    String clientId,
    double proposedPrice,
    String? message,
    String status,
    bool isFromPrestataire,
    String? parentNegotiationId,
    String? createdAt,
    String? updatedAt,
  });
}

/// @nodoc
class _$PriceNegotiationModelCopyWithImpl<
  $Res,
  $Val extends PriceNegotiationModel
>
    implements $PriceNegotiationModelCopyWith<$Res> {
  _$PriceNegotiationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PriceNegotiationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serviceRequestId = null,
    Object? prestataireId = null,
    Object? clientId = null,
    Object? proposedPrice = null,
    Object? message = freezed,
    Object? status = null,
    Object? isFromPrestataire = null,
    Object? parentNegotiationId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
            proposedPrice:
                null == proposedPrice
                    ? _value.proposedPrice
                    : proposedPrice // ignore: cast_nullable_to_non_nullable
                        as double,
            message:
                freezed == message
                    ? _value.message
                    : message // ignore: cast_nullable_to_non_nullable
                        as String?,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as String,
            isFromPrestataire:
                null == isFromPrestataire
                    ? _value.isFromPrestataire
                    : isFromPrestataire // ignore: cast_nullable_to_non_nullable
                        as bool,
            parentNegotiationId:
                freezed == parentNegotiationId
                    ? _value.parentNegotiationId
                    : parentNegotiationId // ignore: cast_nullable_to_non_nullable
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PriceNegotiationModelImplCopyWith<$Res>
    implements $PriceNegotiationModelCopyWith<$Res> {
  factory _$$PriceNegotiationModelImplCopyWith(
    _$PriceNegotiationModelImpl value,
    $Res Function(_$PriceNegotiationModelImpl) then,
  ) = __$$PriceNegotiationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String serviceRequestId,
    String prestataireId,
    String clientId,
    double proposedPrice,
    String? message,
    String status,
    bool isFromPrestataire,
    String? parentNegotiationId,
    String? createdAt,
    String? updatedAt,
  });
}

/// @nodoc
class __$$PriceNegotiationModelImplCopyWithImpl<$Res>
    extends
        _$PriceNegotiationModelCopyWithImpl<$Res, _$PriceNegotiationModelImpl>
    implements _$$PriceNegotiationModelImplCopyWith<$Res> {
  __$$PriceNegotiationModelImplCopyWithImpl(
    _$PriceNegotiationModelImpl _value,
    $Res Function(_$PriceNegotiationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PriceNegotiationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serviceRequestId = null,
    Object? prestataireId = null,
    Object? clientId = null,
    Object? proposedPrice = null,
    Object? message = freezed,
    Object? status = null,
    Object? isFromPrestataire = null,
    Object? parentNegotiationId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$PriceNegotiationModelImpl(
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
        proposedPrice:
            null == proposedPrice
                ? _value.proposedPrice
                : proposedPrice // ignore: cast_nullable_to_non_nullable
                    as double,
        message:
            freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String?,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as String,
        isFromPrestataire:
            null == isFromPrestataire
                ? _value.isFromPrestataire
                : isFromPrestataire // ignore: cast_nullable_to_non_nullable
                    as bool,
        parentNegotiationId:
            freezed == parentNegotiationId
                ? _value.parentNegotiationId
                : parentNegotiationId // ignore: cast_nullable_to_non_nullable
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PriceNegotiationModelImpl implements _PriceNegotiationModel {
  const _$PriceNegotiationModelImpl({
    required this.id,
    required this.serviceRequestId,
    required this.prestataireId,
    required this.clientId,
    required this.proposedPrice,
    this.message,
    this.status = 'pending',
    this.isFromPrestataire = true,
    this.parentNegotiationId,
    this.createdAt,
    this.updatedAt,
  });

  factory _$PriceNegotiationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PriceNegotiationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String serviceRequestId;
  @override
  final String prestataireId;
  @override
  final String clientId;
  @override
  final double proposedPrice;
  @override
  final String? message;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final bool isFromPrestataire;
  @override
  final String? parentNegotiationId;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;

  @override
  String toString() {
    return 'PriceNegotiationModel(id: $id, serviceRequestId: $serviceRequestId, prestataireId: $prestataireId, clientId: $clientId, proposedPrice: $proposedPrice, message: $message, status: $status, isFromPrestataire: $isFromPrestataire, parentNegotiationId: $parentNegotiationId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PriceNegotiationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serviceRequestId, serviceRequestId) ||
                other.serviceRequestId == serviceRequestId) &&
            (identical(other.prestataireId, prestataireId) ||
                other.prestataireId == prestataireId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.proposedPrice, proposedPrice) ||
                other.proposedPrice == proposedPrice) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isFromPrestataire, isFromPrestataire) ||
                other.isFromPrestataire == isFromPrestataire) &&
            (identical(other.parentNegotiationId, parentNegotiationId) ||
                other.parentNegotiationId == parentNegotiationId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    serviceRequestId,
    prestataireId,
    clientId,
    proposedPrice,
    message,
    status,
    isFromPrestataire,
    parentNegotiationId,
    createdAt,
    updatedAt,
  );

  /// Create a copy of PriceNegotiationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PriceNegotiationModelImplCopyWith<_$PriceNegotiationModelImpl>
  get copyWith =>
      __$$PriceNegotiationModelImplCopyWithImpl<_$PriceNegotiationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PriceNegotiationModelImplToJson(this);
  }
}

abstract class _PriceNegotiationModel implements PriceNegotiationModel {
  const factory _PriceNegotiationModel({
    required final String id,
    required final String serviceRequestId,
    required final String prestataireId,
    required final String clientId,
    required final double proposedPrice,
    final String? message,
    final String status,
    final bool isFromPrestataire,
    final String? parentNegotiationId,
    final String? createdAt,
    final String? updatedAt,
  }) = _$PriceNegotiationModelImpl;

  factory _PriceNegotiationModel.fromJson(Map<String, dynamic> json) =
      _$PriceNegotiationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get serviceRequestId;
  @override
  String get prestataireId;
  @override
  String get clientId;
  @override
  double get proposedPrice;
  @override
  String? get message;
  @override
  String get status;
  @override
  bool get isFromPrestataire;
  @override
  String? get parentNegotiationId;
  @override
  String? get createdAt;
  @override
  String? get updatedAt;

  /// Create a copy of PriceNegotiationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PriceNegotiationModelImplCopyWith<_$PriceNegotiationModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
