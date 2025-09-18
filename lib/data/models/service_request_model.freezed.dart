// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ServiceRequestModel _$ServiceRequestModelFromJson(Map<String, dynamic> json) {
  return _ServiceRequestModel.fromJson(json);
}

/// @nodoc
mixin _$ServiceRequestModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get clientName => throw _privateConstructorUsedError;
  String get clientPhone => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _budgetFromJson)
  double get budget => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJson)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJson)
  DateTime get deadline => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get assignedPrestataireId => throw _privateConstructorUsedError;
  String? get prestataireName => throw _privateConstructorUsedError;
  String? get assignedPrestataireName => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJsonNullable)
  DateTime? get completionDate => throw _privateConstructorUsedError;
  String? get completionNotes => throw _privateConstructorUsedError;

  /// Serializes this ServiceRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceRequestModelCopyWith<ServiceRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceRequestModelCopyWith<$Res> {
  factory $ServiceRequestModelCopyWith(
    ServiceRequestModel value,
    $Res Function(ServiceRequestModel) then,
  ) = _$ServiceRequestModelCopyWithImpl<$Res, ServiceRequestModel>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String category,
    String clientId,
    String clientName,
    String clientPhone,
    String location,
    @JsonKey(fromJson: _budgetFromJson) double budget,
    @JsonKey(fromJson: _dateTimeFromJson) DateTime createdAt,
    @JsonKey(fromJson: _dateTimeFromJson) DateTime deadline,
    String status,
    String? assignedPrestataireId,
    String? prestataireName,
    String? assignedPrestataireName,
    String? notes,
    @JsonKey(fromJson: _dateTimeFromJsonNullable) DateTime? completionDate,
    String? completionNotes,
  });
}

/// @nodoc
class _$ServiceRequestModelCopyWithImpl<$Res, $Val extends ServiceRequestModel>
    implements $ServiceRequestModelCopyWith<$Res> {
  _$ServiceRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? clientId = null,
    Object? clientName = null,
    Object? clientPhone = null,
    Object? location = null,
    Object? budget = null,
    Object? createdAt = null,
    Object? deadline = null,
    Object? status = null,
    Object? assignedPrestataireId = freezed,
    Object? prestataireName = freezed,
    Object? assignedPrestataireName = freezed,
    Object? notes = freezed,
    Object? completionDate = freezed,
    Object? completionNotes = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                null == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String,
            category:
                null == category
                    ? _value.category
                    : category // ignore: cast_nullable_to_non_nullable
                        as String,
            clientId:
                null == clientId
                    ? _value.clientId
                    : clientId // ignore: cast_nullable_to_non_nullable
                        as String,
            clientName:
                null == clientName
                    ? _value.clientName
                    : clientName // ignore: cast_nullable_to_non_nullable
                        as String,
            clientPhone:
                null == clientPhone
                    ? _value.clientPhone
                    : clientPhone // ignore: cast_nullable_to_non_nullable
                        as String,
            location:
                null == location
                    ? _value.location
                    : location // ignore: cast_nullable_to_non_nullable
                        as String,
            budget:
                null == budget
                    ? _value.budget
                    : budget // ignore: cast_nullable_to_non_nullable
                        as double,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            deadline:
                null == deadline
                    ? _value.deadline
                    : deadline // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as String,
            assignedPrestataireId:
                freezed == assignedPrestataireId
                    ? _value.assignedPrestataireId
                    : assignedPrestataireId // ignore: cast_nullable_to_non_nullable
                        as String?,
            prestataireName:
                freezed == prestataireName
                    ? _value.prestataireName
                    : prestataireName // ignore: cast_nullable_to_non_nullable
                        as String?,
            assignedPrestataireName:
                freezed == assignedPrestataireName
                    ? _value.assignedPrestataireName
                    : assignedPrestataireName // ignore: cast_nullable_to_non_nullable
                        as String?,
            notes:
                freezed == notes
                    ? _value.notes
                    : notes // ignore: cast_nullable_to_non_nullable
                        as String?,
            completionDate:
                freezed == completionDate
                    ? _value.completionDate
                    : completionDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            completionNotes:
                freezed == completionNotes
                    ? _value.completionNotes
                    : completionNotes // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ServiceRequestModelImplCopyWith<$Res>
    implements $ServiceRequestModelCopyWith<$Res> {
  factory _$$ServiceRequestModelImplCopyWith(
    _$ServiceRequestModelImpl value,
    $Res Function(_$ServiceRequestModelImpl) then,
  ) = __$$ServiceRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String category,
    String clientId,
    String clientName,
    String clientPhone,
    String location,
    @JsonKey(fromJson: _budgetFromJson) double budget,
    @JsonKey(fromJson: _dateTimeFromJson) DateTime createdAt,
    @JsonKey(fromJson: _dateTimeFromJson) DateTime deadline,
    String status,
    String? assignedPrestataireId,
    String? prestataireName,
    String? assignedPrestataireName,
    String? notes,
    @JsonKey(fromJson: _dateTimeFromJsonNullable) DateTime? completionDate,
    String? completionNotes,
  });
}

/// @nodoc
class __$$ServiceRequestModelImplCopyWithImpl<$Res>
    extends _$ServiceRequestModelCopyWithImpl<$Res, _$ServiceRequestModelImpl>
    implements _$$ServiceRequestModelImplCopyWith<$Res> {
  __$$ServiceRequestModelImplCopyWithImpl(
    _$ServiceRequestModelImpl _value,
    $Res Function(_$ServiceRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ServiceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? clientId = null,
    Object? clientName = null,
    Object? clientPhone = null,
    Object? location = null,
    Object? budget = null,
    Object? createdAt = null,
    Object? deadline = null,
    Object? status = null,
    Object? assignedPrestataireId = freezed,
    Object? prestataireName = freezed,
    Object? assignedPrestataireName = freezed,
    Object? notes = freezed,
    Object? completionDate = freezed,
    Object? completionNotes = freezed,
  }) {
    return _then(
      _$ServiceRequestModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String,
        category:
            null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                    as String,
        clientId:
            null == clientId
                ? _value.clientId
                : clientId // ignore: cast_nullable_to_non_nullable
                    as String,
        clientName:
            null == clientName
                ? _value.clientName
                : clientName // ignore: cast_nullable_to_non_nullable
                    as String,
        clientPhone:
            null == clientPhone
                ? _value.clientPhone
                : clientPhone // ignore: cast_nullable_to_non_nullable
                    as String,
        location:
            null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                    as String,
        budget:
            null == budget
                ? _value.budget
                : budget // ignore: cast_nullable_to_non_nullable
                    as double,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        deadline:
            null == deadline
                ? _value.deadline
                : deadline // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as String,
        assignedPrestataireId:
            freezed == assignedPrestataireId
                ? _value.assignedPrestataireId
                : assignedPrestataireId // ignore: cast_nullable_to_non_nullable
                    as String?,
        prestataireName:
            freezed == prestataireName
                ? _value.prestataireName
                : prestataireName // ignore: cast_nullable_to_non_nullable
                    as String?,
        assignedPrestataireName:
            freezed == assignedPrestataireName
                ? _value.assignedPrestataireName
                : assignedPrestataireName // ignore: cast_nullable_to_non_nullable
                    as String?,
        notes:
            freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                    as String?,
        completionDate:
            freezed == completionDate
                ? _value.completionDate
                : completionDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        completionNotes:
            freezed == completionNotes
                ? _value.completionNotes
                : completionNotes // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceRequestModelImpl implements _ServiceRequestModel {
  const _$ServiceRequestModelImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.clientId,
    required this.clientName,
    required this.clientPhone,
    required this.location,
    @JsonKey(fromJson: _budgetFromJson) required this.budget,
    @JsonKey(fromJson: _dateTimeFromJson) required this.createdAt,
    @JsonKey(fromJson: _dateTimeFromJson) required this.deadline,
    this.status = 'pending',
    this.assignedPrestataireId,
    this.prestataireName,
    this.assignedPrestataireName,
    this.notes,
    @JsonKey(fromJson: _dateTimeFromJsonNullable) this.completionDate,
    this.completionNotes,
  });

  factory _$ServiceRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceRequestModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String category;
  @override
  final String clientId;
  @override
  final String clientName;
  @override
  final String clientPhone;
  @override
  final String location;
  @override
  @JsonKey(fromJson: _budgetFromJson)
  final double budget;
  @override
  @JsonKey(fromJson: _dateTimeFromJson)
  final DateTime createdAt;
  @override
  @JsonKey(fromJson: _dateTimeFromJson)
  final DateTime deadline;
  @override
  @JsonKey()
  final String status;
  @override
  final String? assignedPrestataireId;
  @override
  final String? prestataireName;
  @override
  final String? assignedPrestataireName;
  @override
  final String? notes;
  @override
  @JsonKey(fromJson: _dateTimeFromJsonNullable)
  final DateTime? completionDate;
  @override
  final String? completionNotes;

  @override
  String toString() {
    return 'ServiceRequestModel(id: $id, title: $title, description: $description, category: $category, clientId: $clientId, clientName: $clientName, clientPhone: $clientPhone, location: $location, budget: $budget, createdAt: $createdAt, deadline: $deadline, status: $status, assignedPrestataireId: $assignedPrestataireId, prestataireName: $prestataireName, assignedPrestataireName: $assignedPrestataireName, notes: $notes, completionDate: $completionDate, completionNotes: $completionNotes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceRequestModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.clientName, clientName) ||
                other.clientName == clientName) &&
            (identical(other.clientPhone, clientPhone) ||
                other.clientPhone == clientPhone) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.budget, budget) || other.budget == budget) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.assignedPrestataireId, assignedPrestataireId) ||
                other.assignedPrestataireId == assignedPrestataireId) &&
            (identical(other.prestataireName, prestataireName) ||
                other.prestataireName == prestataireName) &&
            (identical(
                  other.assignedPrestataireName,
                  assignedPrestataireName,
                ) ||
                other.assignedPrestataireName == assignedPrestataireName) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.completionDate, completionDate) ||
                other.completionDate == completionDate) &&
            (identical(other.completionNotes, completionNotes) ||
                other.completionNotes == completionNotes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    category,
    clientId,
    clientName,
    clientPhone,
    location,
    budget,
    createdAt,
    deadline,
    status,
    assignedPrestataireId,
    prestataireName,
    assignedPrestataireName,
    notes,
    completionDate,
    completionNotes,
  );

  /// Create a copy of ServiceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceRequestModelImplCopyWith<_$ServiceRequestModelImpl> get copyWith =>
      __$$ServiceRequestModelImplCopyWithImpl<_$ServiceRequestModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceRequestModelImplToJson(this);
  }
}

abstract class _ServiceRequestModel implements ServiceRequestModel {
  const factory _ServiceRequestModel({
    required final String id,
    required final String title,
    required final String description,
    required final String category,
    required final String clientId,
    required final String clientName,
    required final String clientPhone,
    required final String location,
    @JsonKey(fromJson: _budgetFromJson) required final double budget,
    @JsonKey(fromJson: _dateTimeFromJson) required final DateTime createdAt,
    @JsonKey(fromJson: _dateTimeFromJson) required final DateTime deadline,
    final String status,
    final String? assignedPrestataireId,
    final String? prestataireName,
    final String? assignedPrestataireName,
    final String? notes,
    @JsonKey(fromJson: _dateTimeFromJsonNullable)
    final DateTime? completionDate,
    final String? completionNotes,
  }) = _$ServiceRequestModelImpl;

  factory _ServiceRequestModel.fromJson(Map<String, dynamic> json) =
      _$ServiceRequestModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get category;
  @override
  String get clientId;
  @override
  String get clientName;
  @override
  String get clientPhone;
  @override
  String get location;
  @override
  @JsonKey(fromJson: _budgetFromJson)
  double get budget;
  @override
  @JsonKey(fromJson: _dateTimeFromJson)
  DateTime get createdAt;
  @override
  @JsonKey(fromJson: _dateTimeFromJson)
  DateTime get deadline;
  @override
  String get status;
  @override
  String? get assignedPrestataireId;
  @override
  String? get prestataireName;
  @override
  String? get assignedPrestataireName;
  @override
  String? get notes;
  @override
  @JsonKey(fromJson: _dateTimeFromJsonNullable)
  DateTime? get completionDate;
  @override
  String? get completionNotes;

  /// Create a copy of ServiceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceRequestModelImplCopyWith<_$ServiceRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
