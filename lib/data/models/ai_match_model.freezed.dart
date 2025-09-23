// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_match_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AIMatchModel _$AIMatchModelFromJson(Map<String, dynamic> json) {
  return _AIMatchModel.fromJson(json);
}

/// @nodoc
mixin _$AIMatchModel {
  String get id => throw _privateConstructorUsedError;
  String get serviceRequestId => throw _privateConstructorUsedError;
  String get prestataireId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _compatibilityScoreFromJson)
  double get compatibilityScore => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _skillsScoreFromJson)
  double get skillsScore => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _performanceScoreFromJson)
  double get performanceScore => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _locationScoreFromJson)
  double get locationScore => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _budgetScoreFromJson)
  double get budgetScore => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _availabilityScoreFromJson)
  double get availabilityScore => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _distanceFromJson)
  double? get distance => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _estimatedPriceFromJson)
  double? get estimatedPrice => throw _privateConstructorUsedError;
  String get reasoning => throw _privateConstructorUsedError;
  AIMatchingFactorsModel get matchingFactors =>
      throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJsonNullable)
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJson)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJson)
  DateTime get updatedAt => throw _privateConstructorUsedError;
  PrestataireInfoModel? get prestataire => throw _privateConstructorUsedError;

  /// Serializes this AIMatchModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIMatchModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIMatchModelCopyWith<AIMatchModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIMatchModelCopyWith<$Res> {
  factory $AIMatchModelCopyWith(
    AIMatchModel value,
    $Res Function(AIMatchModel) then,
  ) = _$AIMatchModelCopyWithImpl<$Res, AIMatchModel>;
  @useResult
  $Res call({
    String id,
    String serviceRequestId,
    String prestataireId,
    @JsonKey(fromJson: _compatibilityScoreFromJson) double compatibilityScore,
    @JsonKey(fromJson: _skillsScoreFromJson) double skillsScore,
    @JsonKey(fromJson: _performanceScoreFromJson) double performanceScore,
    @JsonKey(fromJson: _locationScoreFromJson) double locationScore,
    @JsonKey(fromJson: _budgetScoreFromJson) double budgetScore,
    @JsonKey(fromJson: _availabilityScoreFromJson) double availabilityScore,
    @JsonKey(fromJson: _distanceFromJson) double? distance,
    @JsonKey(fromJson: _estimatedPriceFromJson) double? estimatedPrice,
    String reasoning,
    AIMatchingFactorsModel matchingFactors,
    String status,
    @JsonKey(fromJson: _dateTimeFromJsonNullable) DateTime? expiresAt,
    @JsonKey(fromJson: _dateTimeFromJson) DateTime createdAt,
    @JsonKey(fromJson: _dateTimeFromJson) DateTime updatedAt,
    PrestataireInfoModel? prestataire,
  });

  $AIMatchingFactorsModelCopyWith<$Res> get matchingFactors;
  $PrestataireInfoModelCopyWith<$Res>? get prestataire;
}

/// @nodoc
class _$AIMatchModelCopyWithImpl<$Res, $Val extends AIMatchModel>
    implements $AIMatchModelCopyWith<$Res> {
  _$AIMatchModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIMatchModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serviceRequestId = null,
    Object? prestataireId = null,
    Object? compatibilityScore = null,
    Object? skillsScore = null,
    Object? performanceScore = null,
    Object? locationScore = null,
    Object? budgetScore = null,
    Object? availabilityScore = null,
    Object? distance = freezed,
    Object? estimatedPrice = freezed,
    Object? reasoning = null,
    Object? matchingFactors = null,
    Object? status = null,
    Object? expiresAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? prestataire = freezed,
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
            compatibilityScore:
                null == compatibilityScore
                    ? _value.compatibilityScore
                    : compatibilityScore // ignore: cast_nullable_to_non_nullable
                        as double,
            skillsScore:
                null == skillsScore
                    ? _value.skillsScore
                    : skillsScore // ignore: cast_nullable_to_non_nullable
                        as double,
            performanceScore:
                null == performanceScore
                    ? _value.performanceScore
                    : performanceScore // ignore: cast_nullable_to_non_nullable
                        as double,
            locationScore:
                null == locationScore
                    ? _value.locationScore
                    : locationScore // ignore: cast_nullable_to_non_nullable
                        as double,
            budgetScore:
                null == budgetScore
                    ? _value.budgetScore
                    : budgetScore // ignore: cast_nullable_to_non_nullable
                        as double,
            availabilityScore:
                null == availabilityScore
                    ? _value.availabilityScore
                    : availabilityScore // ignore: cast_nullable_to_non_nullable
                        as double,
            distance:
                freezed == distance
                    ? _value.distance
                    : distance // ignore: cast_nullable_to_non_nullable
                        as double?,
            estimatedPrice:
                freezed == estimatedPrice
                    ? _value.estimatedPrice
                    : estimatedPrice // ignore: cast_nullable_to_non_nullable
                        as double?,
            reasoning:
                null == reasoning
                    ? _value.reasoning
                    : reasoning // ignore: cast_nullable_to_non_nullable
                        as String,
            matchingFactors:
                null == matchingFactors
                    ? _value.matchingFactors
                    : matchingFactors // ignore: cast_nullable_to_non_nullable
                        as AIMatchingFactorsModel,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as String,
            expiresAt:
                freezed == expiresAt
                    ? _value.expiresAt
                    : expiresAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            updatedAt:
                null == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            prestataire:
                freezed == prestataire
                    ? _value.prestataire
                    : prestataire // ignore: cast_nullable_to_non_nullable
                        as PrestataireInfoModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of AIMatchModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AIMatchingFactorsModelCopyWith<$Res> get matchingFactors {
    return $AIMatchingFactorsModelCopyWith<$Res>(_value.matchingFactors, (
      value,
    ) {
      return _then(_value.copyWith(matchingFactors: value) as $Val);
    });
  }

  /// Create a copy of AIMatchModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PrestataireInfoModelCopyWith<$Res>? get prestataire {
    if (_value.prestataire == null) {
      return null;
    }

    return $PrestataireInfoModelCopyWith<$Res>(_value.prestataire!, (value) {
      return _then(_value.copyWith(prestataire: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AIMatchModelImplCopyWith<$Res>
    implements $AIMatchModelCopyWith<$Res> {
  factory _$$AIMatchModelImplCopyWith(
    _$AIMatchModelImpl value,
    $Res Function(_$AIMatchModelImpl) then,
  ) = __$$AIMatchModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String serviceRequestId,
    String prestataireId,
    @JsonKey(fromJson: _compatibilityScoreFromJson) double compatibilityScore,
    @JsonKey(fromJson: _skillsScoreFromJson) double skillsScore,
    @JsonKey(fromJson: _performanceScoreFromJson) double performanceScore,
    @JsonKey(fromJson: _locationScoreFromJson) double locationScore,
    @JsonKey(fromJson: _budgetScoreFromJson) double budgetScore,
    @JsonKey(fromJson: _availabilityScoreFromJson) double availabilityScore,
    @JsonKey(fromJson: _distanceFromJson) double? distance,
    @JsonKey(fromJson: _estimatedPriceFromJson) double? estimatedPrice,
    String reasoning,
    AIMatchingFactorsModel matchingFactors,
    String status,
    @JsonKey(fromJson: _dateTimeFromJsonNullable) DateTime? expiresAt,
    @JsonKey(fromJson: _dateTimeFromJson) DateTime createdAt,
    @JsonKey(fromJson: _dateTimeFromJson) DateTime updatedAt,
    PrestataireInfoModel? prestataire,
  });

  @override
  $AIMatchingFactorsModelCopyWith<$Res> get matchingFactors;
  @override
  $PrestataireInfoModelCopyWith<$Res>? get prestataire;
}

/// @nodoc
class __$$AIMatchModelImplCopyWithImpl<$Res>
    extends _$AIMatchModelCopyWithImpl<$Res, _$AIMatchModelImpl>
    implements _$$AIMatchModelImplCopyWith<$Res> {
  __$$AIMatchModelImplCopyWithImpl(
    _$AIMatchModelImpl _value,
    $Res Function(_$AIMatchModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AIMatchModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serviceRequestId = null,
    Object? prestataireId = null,
    Object? compatibilityScore = null,
    Object? skillsScore = null,
    Object? performanceScore = null,
    Object? locationScore = null,
    Object? budgetScore = null,
    Object? availabilityScore = null,
    Object? distance = freezed,
    Object? estimatedPrice = freezed,
    Object? reasoning = null,
    Object? matchingFactors = null,
    Object? status = null,
    Object? expiresAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? prestataire = freezed,
  }) {
    return _then(
      _$AIMatchModelImpl(
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
        compatibilityScore:
            null == compatibilityScore
                ? _value.compatibilityScore
                : compatibilityScore // ignore: cast_nullable_to_non_nullable
                    as double,
        skillsScore:
            null == skillsScore
                ? _value.skillsScore
                : skillsScore // ignore: cast_nullable_to_non_nullable
                    as double,
        performanceScore:
            null == performanceScore
                ? _value.performanceScore
                : performanceScore // ignore: cast_nullable_to_non_nullable
                    as double,
        locationScore:
            null == locationScore
                ? _value.locationScore
                : locationScore // ignore: cast_nullable_to_non_nullable
                    as double,
        budgetScore:
            null == budgetScore
                ? _value.budgetScore
                : budgetScore // ignore: cast_nullable_to_non_nullable
                    as double,
        availabilityScore:
            null == availabilityScore
                ? _value.availabilityScore
                : availabilityScore // ignore: cast_nullable_to_non_nullable
                    as double,
        distance:
            freezed == distance
                ? _value.distance
                : distance // ignore: cast_nullable_to_non_nullable
                    as double?,
        estimatedPrice:
            freezed == estimatedPrice
                ? _value.estimatedPrice
                : estimatedPrice // ignore: cast_nullable_to_non_nullable
                    as double?,
        reasoning:
            null == reasoning
                ? _value.reasoning
                : reasoning // ignore: cast_nullable_to_non_nullable
                    as String,
        matchingFactors:
            null == matchingFactors
                ? _value.matchingFactors
                : matchingFactors // ignore: cast_nullable_to_non_nullable
                    as AIMatchingFactorsModel,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as String,
        expiresAt:
            freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        updatedAt:
            null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        prestataire:
            freezed == prestataire
                ? _value.prestataire
                : prestataire // ignore: cast_nullable_to_non_nullable
                    as PrestataireInfoModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AIMatchModelImpl implements _AIMatchModel {
  const _$AIMatchModelImpl({
    required this.id,
    required this.serviceRequestId,
    required this.prestataireId,
    @JsonKey(fromJson: _compatibilityScoreFromJson)
    required this.compatibilityScore,
    @JsonKey(fromJson: _skillsScoreFromJson) required this.skillsScore,
    @JsonKey(fromJson: _performanceScoreFromJson)
    required this.performanceScore,
    @JsonKey(fromJson: _locationScoreFromJson) required this.locationScore,
    @JsonKey(fromJson: _budgetScoreFromJson) required this.budgetScore,
    @JsonKey(fromJson: _availabilityScoreFromJson)
    required this.availabilityScore,
    @JsonKey(fromJson: _distanceFromJson) this.distance,
    @JsonKey(fromJson: _estimatedPriceFromJson) this.estimatedPrice,
    required this.reasoning,
    required this.matchingFactors,
    required this.status,
    @JsonKey(fromJson: _dateTimeFromJsonNullable) this.expiresAt,
    @JsonKey(fromJson: _dateTimeFromJson) required this.createdAt,
    @JsonKey(fromJson: _dateTimeFromJson) required this.updatedAt,
    this.prestataire,
  });

  factory _$AIMatchModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIMatchModelImplFromJson(json);

  @override
  final String id;
  @override
  final String serviceRequestId;
  @override
  final String prestataireId;
  @override
  @JsonKey(fromJson: _compatibilityScoreFromJson)
  final double compatibilityScore;
  @override
  @JsonKey(fromJson: _skillsScoreFromJson)
  final double skillsScore;
  @override
  @JsonKey(fromJson: _performanceScoreFromJson)
  final double performanceScore;
  @override
  @JsonKey(fromJson: _locationScoreFromJson)
  final double locationScore;
  @override
  @JsonKey(fromJson: _budgetScoreFromJson)
  final double budgetScore;
  @override
  @JsonKey(fromJson: _availabilityScoreFromJson)
  final double availabilityScore;
  @override
  @JsonKey(fromJson: _distanceFromJson)
  final double? distance;
  @override
  @JsonKey(fromJson: _estimatedPriceFromJson)
  final double? estimatedPrice;
  @override
  final String reasoning;
  @override
  final AIMatchingFactorsModel matchingFactors;
  @override
  final String status;
  @override
  @JsonKey(fromJson: _dateTimeFromJsonNullable)
  final DateTime? expiresAt;
  @override
  @JsonKey(fromJson: _dateTimeFromJson)
  final DateTime createdAt;
  @override
  @JsonKey(fromJson: _dateTimeFromJson)
  final DateTime updatedAt;
  @override
  final PrestataireInfoModel? prestataire;

  @override
  String toString() {
    return 'AIMatchModel(id: $id, serviceRequestId: $serviceRequestId, prestataireId: $prestataireId, compatibilityScore: $compatibilityScore, skillsScore: $skillsScore, performanceScore: $performanceScore, locationScore: $locationScore, budgetScore: $budgetScore, availabilityScore: $availabilityScore, distance: $distance, estimatedPrice: $estimatedPrice, reasoning: $reasoning, matchingFactors: $matchingFactors, status: $status, expiresAt: $expiresAt, createdAt: $createdAt, updatedAt: $updatedAt, prestataire: $prestataire)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIMatchModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serviceRequestId, serviceRequestId) ||
                other.serviceRequestId == serviceRequestId) &&
            (identical(other.prestataireId, prestataireId) ||
                other.prestataireId == prestataireId) &&
            (identical(other.compatibilityScore, compatibilityScore) ||
                other.compatibilityScore == compatibilityScore) &&
            (identical(other.skillsScore, skillsScore) ||
                other.skillsScore == skillsScore) &&
            (identical(other.performanceScore, performanceScore) ||
                other.performanceScore == performanceScore) &&
            (identical(other.locationScore, locationScore) ||
                other.locationScore == locationScore) &&
            (identical(other.budgetScore, budgetScore) ||
                other.budgetScore == budgetScore) &&
            (identical(other.availabilityScore, availabilityScore) ||
                other.availabilityScore == availabilityScore) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.estimatedPrice, estimatedPrice) ||
                other.estimatedPrice == estimatedPrice) &&
            (identical(other.reasoning, reasoning) ||
                other.reasoning == reasoning) &&
            (identical(other.matchingFactors, matchingFactors) ||
                other.matchingFactors == matchingFactors) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.prestataire, prestataire) ||
                other.prestataire == prestataire));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    serviceRequestId,
    prestataireId,
    compatibilityScore,
    skillsScore,
    performanceScore,
    locationScore,
    budgetScore,
    availabilityScore,
    distance,
    estimatedPrice,
    reasoning,
    matchingFactors,
    status,
    expiresAt,
    createdAt,
    updatedAt,
    prestataire,
  );

  /// Create a copy of AIMatchModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIMatchModelImplCopyWith<_$AIMatchModelImpl> get copyWith =>
      __$$AIMatchModelImplCopyWithImpl<_$AIMatchModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIMatchModelImplToJson(this);
  }
}

abstract class _AIMatchModel implements AIMatchModel {
  const factory _AIMatchModel({
    required final String id,
    required final String serviceRequestId,
    required final String prestataireId,
    @JsonKey(fromJson: _compatibilityScoreFromJson)
    required final double compatibilityScore,
    @JsonKey(fromJson: _skillsScoreFromJson) required final double skillsScore,
    @JsonKey(fromJson: _performanceScoreFromJson)
    required final double performanceScore,
    @JsonKey(fromJson: _locationScoreFromJson)
    required final double locationScore,
    @JsonKey(fromJson: _budgetScoreFromJson) required final double budgetScore,
    @JsonKey(fromJson: _availabilityScoreFromJson)
    required final double availabilityScore,
    @JsonKey(fromJson: _distanceFromJson) final double? distance,
    @JsonKey(fromJson: _estimatedPriceFromJson) final double? estimatedPrice,
    required final String reasoning,
    required final AIMatchingFactorsModel matchingFactors,
    required final String status,
    @JsonKey(fromJson: _dateTimeFromJsonNullable) final DateTime? expiresAt,
    @JsonKey(fromJson: _dateTimeFromJson) required final DateTime createdAt,
    @JsonKey(fromJson: _dateTimeFromJson) required final DateTime updatedAt,
    final PrestataireInfoModel? prestataire,
  }) = _$AIMatchModelImpl;

  factory _AIMatchModel.fromJson(Map<String, dynamic> json) =
      _$AIMatchModelImpl.fromJson;

  @override
  String get id;
  @override
  String get serviceRequestId;
  @override
  String get prestataireId;
  @override
  @JsonKey(fromJson: _compatibilityScoreFromJson)
  double get compatibilityScore;
  @override
  @JsonKey(fromJson: _skillsScoreFromJson)
  double get skillsScore;
  @override
  @JsonKey(fromJson: _performanceScoreFromJson)
  double get performanceScore;
  @override
  @JsonKey(fromJson: _locationScoreFromJson)
  double get locationScore;
  @override
  @JsonKey(fromJson: _budgetScoreFromJson)
  double get budgetScore;
  @override
  @JsonKey(fromJson: _availabilityScoreFromJson)
  double get availabilityScore;
  @override
  @JsonKey(fromJson: _distanceFromJson)
  double? get distance;
  @override
  @JsonKey(fromJson: _estimatedPriceFromJson)
  double? get estimatedPrice;
  @override
  String get reasoning;
  @override
  AIMatchingFactorsModel get matchingFactors;
  @override
  String get status;
  @override
  @JsonKey(fromJson: _dateTimeFromJsonNullable)
  DateTime? get expiresAt;
  @override
  @JsonKey(fromJson: _dateTimeFromJson)
  DateTime get createdAt;
  @override
  @JsonKey(fromJson: _dateTimeFromJson)
  DateTime get updatedAt;
  @override
  PrestataireInfoModel? get prestataire;

  /// Create a copy of AIMatchModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIMatchModelImplCopyWith<_$AIMatchModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AIMatchingFactorsModel _$AIMatchingFactorsModelFromJson(
  Map<String, dynamic> json,
) {
  return _AIMatchingFactorsModel.fromJson(json);
}

/// @nodoc
mixin _$AIMatchingFactorsModel {
  List<String> get skills => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String get budget => throw _privateConstructorUsedError;
  String get performance => throw _privateConstructorUsedError;
  String get availability => throw _privateConstructorUsedError;

  /// Serializes this AIMatchingFactorsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIMatchingFactorsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIMatchingFactorsModelCopyWith<AIMatchingFactorsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIMatchingFactorsModelCopyWith<$Res> {
  factory $AIMatchingFactorsModelCopyWith(
    AIMatchingFactorsModel value,
    $Res Function(AIMatchingFactorsModel) then,
  ) = _$AIMatchingFactorsModelCopyWithImpl<$Res, AIMatchingFactorsModel>;
  @useResult
  $Res call({
    List<String> skills,
    String location,
    String budget,
    String performance,
    String availability,
  });
}

/// @nodoc
class _$AIMatchingFactorsModelCopyWithImpl<
  $Res,
  $Val extends AIMatchingFactorsModel
>
    implements $AIMatchingFactorsModelCopyWith<$Res> {
  _$AIMatchingFactorsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIMatchingFactorsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? skills = null,
    Object? location = null,
    Object? budget = null,
    Object? performance = null,
    Object? availability = null,
  }) {
    return _then(
      _value.copyWith(
            skills:
                null == skills
                    ? _value.skills
                    : skills // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            location:
                null == location
                    ? _value.location
                    : location // ignore: cast_nullable_to_non_nullable
                        as String,
            budget:
                null == budget
                    ? _value.budget
                    : budget // ignore: cast_nullable_to_non_nullable
                        as String,
            performance:
                null == performance
                    ? _value.performance
                    : performance // ignore: cast_nullable_to_non_nullable
                        as String,
            availability:
                null == availability
                    ? _value.availability
                    : availability // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AIMatchingFactorsModelImplCopyWith<$Res>
    implements $AIMatchingFactorsModelCopyWith<$Res> {
  factory _$$AIMatchingFactorsModelImplCopyWith(
    _$AIMatchingFactorsModelImpl value,
    $Res Function(_$AIMatchingFactorsModelImpl) then,
  ) = __$$AIMatchingFactorsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<String> skills,
    String location,
    String budget,
    String performance,
    String availability,
  });
}

/// @nodoc
class __$$AIMatchingFactorsModelImplCopyWithImpl<$Res>
    extends
        _$AIMatchingFactorsModelCopyWithImpl<$Res, _$AIMatchingFactorsModelImpl>
    implements _$$AIMatchingFactorsModelImplCopyWith<$Res> {
  __$$AIMatchingFactorsModelImplCopyWithImpl(
    _$AIMatchingFactorsModelImpl _value,
    $Res Function(_$AIMatchingFactorsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AIMatchingFactorsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? skills = null,
    Object? location = null,
    Object? budget = null,
    Object? performance = null,
    Object? availability = null,
  }) {
    return _then(
      _$AIMatchingFactorsModelImpl(
        skills:
            null == skills
                ? _value._skills
                : skills // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        location:
            null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                    as String,
        budget:
            null == budget
                ? _value.budget
                : budget // ignore: cast_nullable_to_non_nullable
                    as String,
        performance:
            null == performance
                ? _value.performance
                : performance // ignore: cast_nullable_to_non_nullable
                    as String,
        availability:
            null == availability
                ? _value.availability
                : availability // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AIMatchingFactorsModelImpl implements _AIMatchingFactorsModel {
  const _$AIMatchingFactorsModelImpl({
    final List<String> skills = const [],
    required this.location,
    required this.budget,
    required this.performance,
    required this.availability,
  }) : _skills = skills;

  factory _$AIMatchingFactorsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIMatchingFactorsModelImplFromJson(json);

  final List<String> _skills;
  @override
  @JsonKey()
  List<String> get skills {
    if (_skills is EqualUnmodifiableListView) return _skills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skills);
  }

  @override
  final String location;
  @override
  final String budget;
  @override
  final String performance;
  @override
  final String availability;

  @override
  String toString() {
    return 'AIMatchingFactorsModel(skills: $skills, location: $location, budget: $budget, performance: $performance, availability: $availability)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIMatchingFactorsModelImpl &&
            const DeepCollectionEquality().equals(other._skills, _skills) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.budget, budget) || other.budget == budget) &&
            (identical(other.performance, performance) ||
                other.performance == performance) &&
            (identical(other.availability, availability) ||
                other.availability == availability));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_skills),
    location,
    budget,
    performance,
    availability,
  );

  /// Create a copy of AIMatchingFactorsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIMatchingFactorsModelImplCopyWith<_$AIMatchingFactorsModelImpl>
  get copyWith =>
      __$$AIMatchingFactorsModelImplCopyWithImpl<_$AIMatchingFactorsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AIMatchingFactorsModelImplToJson(this);
  }
}

abstract class _AIMatchingFactorsModel implements AIMatchingFactorsModel {
  const factory _AIMatchingFactorsModel({
    final List<String> skills,
    required final String location,
    required final String budget,
    required final String performance,
    required final String availability,
  }) = _$AIMatchingFactorsModelImpl;

  factory _AIMatchingFactorsModel.fromJson(Map<String, dynamic> json) =
      _$AIMatchingFactorsModelImpl.fromJson;

  @override
  List<String> get skills;
  @override
  String get location;
  @override
  String get budget;
  @override
  String get performance;
  @override
  String get availability;

  /// Create a copy of AIMatchingFactorsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIMatchingFactorsModelImplCopyWith<_$AIMatchingFactorsModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

PrestataireInfoModel _$PrestataireInfoModelFromJson(Map<String, dynamic> json) {
  return _PrestataireInfoModel.fromJson(json);
}

/// @nodoc
mixin _$PrestataireInfoModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get firstName => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _ratingFromJson)
  double get rating => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _reviewCountFromJson)
  int get reviewCount => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _pricePerHourFromJson)
  int get pricePerHour => throw _privateConstructorUsedError;
  List<String> get skills => throw _privateConstructorUsedError;
  List<String> get portfolio => throw _privateConstructorUsedError;
  String? get profileImage => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _completedJobsFromJson)
  int get completedJobs => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _totalReviewsFromJson)
  int get totalReviews => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _totalEarningsFromJson)
  double get totalEarnings => throw _privateConstructorUsedError;

  /// Serializes this PrestataireInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrestataireInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrestataireInfoModelCopyWith<PrestataireInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrestataireInfoModelCopyWith<$Res> {
  factory $PrestataireInfoModelCopyWith(
    PrestataireInfoModel value,
    $Res Function(PrestataireInfoModel) then,
  ) = _$PrestataireInfoModelCopyWithImpl<$Res, PrestataireInfoModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String category,
    String location,
    String? address,
    String? city,
    String? bio,
    @JsonKey(fromJson: _ratingFromJson) double rating,
    @JsonKey(fromJson: _reviewCountFromJson) int reviewCount,
    @JsonKey(fromJson: _pricePerHourFromJson) int pricePerHour,
    List<String> skills,
    List<String> portfolio,
    String? profileImage,
    bool isAvailable,
    @JsonKey(fromJson: _completedJobsFromJson) int completedJobs,
    @JsonKey(fromJson: _totalReviewsFromJson) int totalReviews,
    @JsonKey(fromJson: _totalEarningsFromJson) double totalEarnings,
  });
}

/// @nodoc
class _$PrestataireInfoModelCopyWithImpl<
  $Res,
  $Val extends PrestataireInfoModel
>
    implements $PrestataireInfoModelCopyWith<$Res> {
  _$PrestataireInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrestataireInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? category = null,
    Object? location = null,
    Object? address = freezed,
    Object? city = freezed,
    Object? bio = freezed,
    Object? rating = null,
    Object? reviewCount = null,
    Object? pricePerHour = null,
    Object? skills = null,
    Object? portfolio = null,
    Object? profileImage = freezed,
    Object? isAvailable = null,
    Object? completedJobs = null,
    Object? totalReviews = null,
    Object? totalEarnings = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            firstName:
                freezed == firstName
                    ? _value.firstName
                    : firstName // ignore: cast_nullable_to_non_nullable
                        as String?,
            lastName:
                freezed == lastName
                    ? _value.lastName
                    : lastName // ignore: cast_nullable_to_non_nullable
                        as String?,
            email:
                freezed == email
                    ? _value.email
                    : email // ignore: cast_nullable_to_non_nullable
                        as String?,
            phone:
                freezed == phone
                    ? _value.phone
                    : phone // ignore: cast_nullable_to_non_nullable
                        as String?,
            category:
                null == category
                    ? _value.category
                    : category // ignore: cast_nullable_to_non_nullable
                        as String,
            location:
                null == location
                    ? _value.location
                    : location // ignore: cast_nullable_to_non_nullable
                        as String,
            address:
                freezed == address
                    ? _value.address
                    : address // ignore: cast_nullable_to_non_nullable
                        as String?,
            city:
                freezed == city
                    ? _value.city
                    : city // ignore: cast_nullable_to_non_nullable
                        as String?,
            bio:
                freezed == bio
                    ? _value.bio
                    : bio // ignore: cast_nullable_to_non_nullable
                        as String?,
            rating:
                null == rating
                    ? _value.rating
                    : rating // ignore: cast_nullable_to_non_nullable
                        as double,
            reviewCount:
                null == reviewCount
                    ? _value.reviewCount
                    : reviewCount // ignore: cast_nullable_to_non_nullable
                        as int,
            pricePerHour:
                null == pricePerHour
                    ? _value.pricePerHour
                    : pricePerHour // ignore: cast_nullable_to_non_nullable
                        as int,
            skills:
                null == skills
                    ? _value.skills
                    : skills // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            portfolio:
                null == portfolio
                    ? _value.portfolio
                    : portfolio // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            profileImage:
                freezed == profileImage
                    ? _value.profileImage
                    : profileImage // ignore: cast_nullable_to_non_nullable
                        as String?,
            isAvailable:
                null == isAvailable
                    ? _value.isAvailable
                    : isAvailable // ignore: cast_nullable_to_non_nullable
                        as bool,
            completedJobs:
                null == completedJobs
                    ? _value.completedJobs
                    : completedJobs // ignore: cast_nullable_to_non_nullable
                        as int,
            totalReviews:
                null == totalReviews
                    ? _value.totalReviews
                    : totalReviews // ignore: cast_nullable_to_non_nullable
                        as int,
            totalEarnings:
                null == totalEarnings
                    ? _value.totalEarnings
                    : totalEarnings // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PrestataireInfoModelImplCopyWith<$Res>
    implements $PrestataireInfoModelCopyWith<$Res> {
  factory _$$PrestataireInfoModelImplCopyWith(
    _$PrestataireInfoModelImpl value,
    $Res Function(_$PrestataireInfoModelImpl) then,
  ) = __$$PrestataireInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String category,
    String location,
    String? address,
    String? city,
    String? bio,
    @JsonKey(fromJson: _ratingFromJson) double rating,
    @JsonKey(fromJson: _reviewCountFromJson) int reviewCount,
    @JsonKey(fromJson: _pricePerHourFromJson) int pricePerHour,
    List<String> skills,
    List<String> portfolio,
    String? profileImage,
    bool isAvailable,
    @JsonKey(fromJson: _completedJobsFromJson) int completedJobs,
    @JsonKey(fromJson: _totalReviewsFromJson) int totalReviews,
    @JsonKey(fromJson: _totalEarningsFromJson) double totalEarnings,
  });
}

/// @nodoc
class __$$PrestataireInfoModelImplCopyWithImpl<$Res>
    extends _$PrestataireInfoModelCopyWithImpl<$Res, _$PrestataireInfoModelImpl>
    implements _$$PrestataireInfoModelImplCopyWith<$Res> {
  __$$PrestataireInfoModelImplCopyWithImpl(
    _$PrestataireInfoModelImpl _value,
    $Res Function(_$PrestataireInfoModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PrestataireInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? category = null,
    Object? location = null,
    Object? address = freezed,
    Object? city = freezed,
    Object? bio = freezed,
    Object? rating = null,
    Object? reviewCount = null,
    Object? pricePerHour = null,
    Object? skills = null,
    Object? portfolio = null,
    Object? profileImage = freezed,
    Object? isAvailable = null,
    Object? completedJobs = null,
    Object? totalReviews = null,
    Object? totalEarnings = null,
  }) {
    return _then(
      _$PrestataireInfoModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        firstName:
            freezed == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                    as String?,
        lastName:
            freezed == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                    as String?,
        email:
            freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                    as String?,
        phone:
            freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                    as String?,
        category:
            null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                    as String,
        location:
            null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                    as String,
        address:
            freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                    as String?,
        city:
            freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                    as String?,
        bio:
            freezed == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                    as String?,
        rating:
            null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                    as double,
        reviewCount:
            null == reviewCount
                ? _value.reviewCount
                : reviewCount // ignore: cast_nullable_to_non_nullable
                    as int,
        pricePerHour:
            null == pricePerHour
                ? _value.pricePerHour
                : pricePerHour // ignore: cast_nullable_to_non_nullable
                    as int,
        skills:
            null == skills
                ? _value._skills
                : skills // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        portfolio:
            null == portfolio
                ? _value._portfolio
                : portfolio // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        profileImage:
            freezed == profileImage
                ? _value.profileImage
                : profileImage // ignore: cast_nullable_to_non_nullable
                    as String?,
        isAvailable:
            null == isAvailable
                ? _value.isAvailable
                : isAvailable // ignore: cast_nullable_to_non_nullable
                    as bool,
        completedJobs:
            null == completedJobs
                ? _value.completedJobs
                : completedJobs // ignore: cast_nullable_to_non_nullable
                    as int,
        totalReviews:
            null == totalReviews
                ? _value.totalReviews
                : totalReviews // ignore: cast_nullable_to_non_nullable
                    as int,
        totalEarnings:
            null == totalEarnings
                ? _value.totalEarnings
                : totalEarnings // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PrestataireInfoModelImpl implements _PrestataireInfoModel {
  const _$PrestataireInfoModelImpl({
    required this.id,
    required this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    required this.category,
    required this.location,
    this.address,
    this.city,
    this.bio,
    @JsonKey(fromJson: _ratingFromJson) required this.rating,
    @JsonKey(fromJson: _reviewCountFromJson) required this.reviewCount,
    @JsonKey(fromJson: _pricePerHourFromJson) required this.pricePerHour,
    final List<String> skills = const [],
    final List<String> portfolio = const [],
    this.profileImage,
    required this.isAvailable,
    @JsonKey(fromJson: _completedJobsFromJson) required this.completedJobs,
    @JsonKey(fromJson: _totalReviewsFromJson) required this.totalReviews,
    @JsonKey(fromJson: _totalEarningsFromJson) required this.totalEarnings,
  }) : _skills = skills,
       _portfolio = portfolio;

  factory _$PrestataireInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrestataireInfoModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String category;
  @override
  final String location;
  @override
  final String? address;
  @override
  final String? city;
  @override
  final String? bio;
  @override
  @JsonKey(fromJson: _ratingFromJson)
  final double rating;
  @override
  @JsonKey(fromJson: _reviewCountFromJson)
  final int reviewCount;
  @override
  @JsonKey(fromJson: _pricePerHourFromJson)
  final int pricePerHour;
  final List<String> _skills;
  @override
  @JsonKey()
  List<String> get skills {
    if (_skills is EqualUnmodifiableListView) return _skills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skills);
  }

  final List<String> _portfolio;
  @override
  @JsonKey()
  List<String> get portfolio {
    if (_portfolio is EqualUnmodifiableListView) return _portfolio;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_portfolio);
  }

  @override
  final String? profileImage;
  @override
  final bool isAvailable;
  @override
  @JsonKey(fromJson: _completedJobsFromJson)
  final int completedJobs;
  @override
  @JsonKey(fromJson: _totalReviewsFromJson)
  final int totalReviews;
  @override
  @JsonKey(fromJson: _totalEarningsFromJson)
  final double totalEarnings;

  @override
  String toString() {
    return 'PrestataireInfoModel(id: $id, name: $name, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, category: $category, location: $location, address: $address, city: $city, bio: $bio, rating: $rating, reviewCount: $reviewCount, pricePerHour: $pricePerHour, skills: $skills, portfolio: $portfolio, profileImage: $profileImage, isAvailable: $isAvailable, completedJobs: $completedJobs, totalReviews: $totalReviews, totalEarnings: $totalEarnings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrestataireInfoModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.pricePerHour, pricePerHour) ||
                other.pricePerHour == pricePerHour) &&
            const DeepCollectionEquality().equals(other._skills, _skills) &&
            const DeepCollectionEquality().equals(
              other._portfolio,
              _portfolio,
            ) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.completedJobs, completedJobs) ||
                other.completedJobs == completedJobs) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            (identical(other.totalEarnings, totalEarnings) ||
                other.totalEarnings == totalEarnings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    firstName,
    lastName,
    email,
    phone,
    category,
    location,
    address,
    city,
    bio,
    rating,
    reviewCount,
    pricePerHour,
    const DeepCollectionEquality().hash(_skills),
    const DeepCollectionEquality().hash(_portfolio),
    profileImage,
    isAvailable,
    completedJobs,
    totalReviews,
    totalEarnings,
  ]);

  /// Create a copy of PrestataireInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrestataireInfoModelImplCopyWith<_$PrestataireInfoModelImpl>
  get copyWith =>
      __$$PrestataireInfoModelImplCopyWithImpl<_$PrestataireInfoModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PrestataireInfoModelImplToJson(this);
  }
}

abstract class _PrestataireInfoModel implements PrestataireInfoModel {
  const factory _PrestataireInfoModel({
    required final String id,
    required final String name,
    final String? firstName,
    final String? lastName,
    final String? email,
    final String? phone,
    required final String category,
    required final String location,
    final String? address,
    final String? city,
    final String? bio,
    @JsonKey(fromJson: _ratingFromJson) required final double rating,
    @JsonKey(fromJson: _reviewCountFromJson) required final int reviewCount,
    @JsonKey(fromJson: _pricePerHourFromJson) required final int pricePerHour,
    final List<String> skills,
    final List<String> portfolio,
    final String? profileImage,
    required final bool isAvailable,
    @JsonKey(fromJson: _completedJobsFromJson) required final int completedJobs,
    @JsonKey(fromJson: _totalReviewsFromJson) required final int totalReviews,
    @JsonKey(fromJson: _totalEarningsFromJson)
    required final double totalEarnings,
  }) = _$PrestataireInfoModelImpl;

  factory _PrestataireInfoModel.fromJson(Map<String, dynamic> json) =
      _$PrestataireInfoModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get firstName;
  @override
  String? get lastName;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  String get category;
  @override
  String get location;
  @override
  String? get address;
  @override
  String? get city;
  @override
  String? get bio;
  @override
  @JsonKey(fromJson: _ratingFromJson)
  double get rating;
  @override
  @JsonKey(fromJson: _reviewCountFromJson)
  int get reviewCount;
  @override
  @JsonKey(fromJson: _pricePerHourFromJson)
  int get pricePerHour;
  @override
  List<String> get skills;
  @override
  List<String> get portfolio;
  @override
  String? get profileImage;
  @override
  bool get isAvailable;
  @override
  @JsonKey(fromJson: _completedJobsFromJson)
  int get completedJobs;
  @override
  @JsonKey(fromJson: _totalReviewsFromJson)
  int get totalReviews;
  @override
  @JsonKey(fromJson: _totalEarningsFromJson)
  double get totalEarnings;

  /// Create a copy of PrestataireInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrestataireInfoModelImplCopyWith<_$PrestataireInfoModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
