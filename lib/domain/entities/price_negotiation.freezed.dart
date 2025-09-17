// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_negotiation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PriceNegotiation _$PriceNegotiationFromJson(Map<String, dynamic> json) {
  return _PriceNegotiation.fromJson(json);
}

/// @nodoc
mixin _$PriceNegotiation {
  String get id => throw _privateConstructorUsedError;
  String get serviceRequestId => throw _privateConstructorUsedError;
  String get prestataireId => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  double get proposedPrice => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  NegotiationStatus get status => throw _privateConstructorUsedError;
  bool get isFromPrestataire => throw _privateConstructorUsedError;
  String? get parentNegotiationId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PriceNegotiation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PriceNegotiation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PriceNegotiationCopyWith<PriceNegotiation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PriceNegotiationCopyWith<$Res> {
  factory $PriceNegotiationCopyWith(
    PriceNegotiation value,
    $Res Function(PriceNegotiation) then,
  ) = _$PriceNegotiationCopyWithImpl<$Res, PriceNegotiation>;
  @useResult
  $Res call({
    String id,
    String serviceRequestId,
    String prestataireId,
    String clientId,
    double proposedPrice,
    String? message,
    NegotiationStatus status,
    bool isFromPrestataire,
    String? parentNegotiationId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$PriceNegotiationCopyWithImpl<$Res, $Val extends PriceNegotiation>
    implements $PriceNegotiationCopyWith<$Res> {
  _$PriceNegotiationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PriceNegotiation
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
                        as NegotiationStatus,
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
                        as DateTime?,
            updatedAt:
                freezed == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PriceNegotiationImplCopyWith<$Res>
    implements $PriceNegotiationCopyWith<$Res> {
  factory _$$PriceNegotiationImplCopyWith(
    _$PriceNegotiationImpl value,
    $Res Function(_$PriceNegotiationImpl) then,
  ) = __$$PriceNegotiationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String serviceRequestId,
    String prestataireId,
    String clientId,
    double proposedPrice,
    String? message,
    NegotiationStatus status,
    bool isFromPrestataire,
    String? parentNegotiationId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$PriceNegotiationImplCopyWithImpl<$Res>
    extends _$PriceNegotiationCopyWithImpl<$Res, _$PriceNegotiationImpl>
    implements _$$PriceNegotiationImplCopyWith<$Res> {
  __$$PriceNegotiationImplCopyWithImpl(
    _$PriceNegotiationImpl _value,
    $Res Function(_$PriceNegotiationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PriceNegotiation
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
      _$PriceNegotiationImpl(
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
                    as NegotiationStatus,
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
                    as DateTime?,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PriceNegotiationImpl implements _PriceNegotiation {
  const _$PriceNegotiationImpl({
    required this.id,
    required this.serviceRequestId,
    required this.prestataireId,
    required this.clientId,
    required this.proposedPrice,
    this.message,
    this.status = NegotiationStatus.pending,
    this.isFromPrestataire = true,
    this.parentNegotiationId,
    this.createdAt,
    this.updatedAt,
  });

  factory _$PriceNegotiationImpl.fromJson(Map<String, dynamic> json) =>
      _$$PriceNegotiationImplFromJson(json);

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
  final NegotiationStatus status;
  @override
  @JsonKey()
  final bool isFromPrestataire;
  @override
  final String? parentNegotiationId;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'PriceNegotiation(id: $id, serviceRequestId: $serviceRequestId, prestataireId: $prestataireId, clientId: $clientId, proposedPrice: $proposedPrice, message: $message, status: $status, isFromPrestataire: $isFromPrestataire, parentNegotiationId: $parentNegotiationId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PriceNegotiationImpl &&
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

  /// Create a copy of PriceNegotiation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PriceNegotiationImplCopyWith<_$PriceNegotiationImpl> get copyWith =>
      __$$PriceNegotiationImplCopyWithImpl<_$PriceNegotiationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PriceNegotiationImplToJson(this);
  }
}

abstract class _PriceNegotiation implements PriceNegotiation {
  const factory _PriceNegotiation({
    required final String id,
    required final String serviceRequestId,
    required final String prestataireId,
    required final String clientId,
    required final double proposedPrice,
    final String? message,
    final NegotiationStatus status,
    final bool isFromPrestataire,
    final String? parentNegotiationId,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$PriceNegotiationImpl;

  factory _PriceNegotiation.fromJson(Map<String, dynamic> json) =
      _$PriceNegotiationImpl.fromJson;

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
  NegotiationStatus get status;
  @override
  bool get isFromPrestataire;
  @override
  String? get parentNegotiationId;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of PriceNegotiation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PriceNegotiationImplCopyWith<_$PriceNegotiationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
