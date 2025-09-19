// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ServiceRequest _$ServiceRequestFromJson(Map<String, dynamic> json) {
  return _ServiceRequest.fromJson(json);
}

/// @nodoc
mixin _$ServiceRequest {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get clientName => throw _privateConstructorUsedError;
  String get clientPhone => throw _privateConstructorUsedError;
  String? get clientImage => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _latitudeFromJson)
  double? get latitude => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _longitudeFromJson)
  double? get longitude => throw _privateConstructorUsedError;
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
  List<String> get photos => throw _privateConstructorUsedError;

  /// Serializes this ServiceRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceRequestCopyWith<ServiceRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceRequestCopyWith<$Res> {
  factory $ServiceRequestCopyWith(
    ServiceRequest value,
    $Res Function(ServiceRequest) then,
  ) = _$ServiceRequestCopyWithImpl<$Res, ServiceRequest>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String category,
    String clientId,
    String clientName,
    String clientPhone,
    String? clientImage,
    String location,
    @JsonKey(fromJson: _latitudeFromJson) double? latitude,
    @JsonKey(fromJson: _longitudeFromJson) double? longitude,
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
    List<String> photos,
  });
}

/// @nodoc
class _$ServiceRequestCopyWithImpl<$Res, $Val extends ServiceRequest>
    implements $ServiceRequestCopyWith<$Res> {
  _$ServiceRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceRequest
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
    Object? clientImage = freezed,
    Object? location = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
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
    Object? photos = null,
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
            clientImage:
                freezed == clientImage
                    ? _value.clientImage
                    : clientImage // ignore: cast_nullable_to_non_nullable
                        as String?,
            location:
                null == location
                    ? _value.location
                    : location // ignore: cast_nullable_to_non_nullable
                        as String,
            latitude:
                freezed == latitude
                    ? _value.latitude
                    : latitude // ignore: cast_nullable_to_non_nullable
                        as double?,
            longitude:
                freezed == longitude
                    ? _value.longitude
                    : longitude // ignore: cast_nullable_to_non_nullable
                        as double?,
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
            photos:
                null == photos
                    ? _value.photos
                    : photos // ignore: cast_nullable_to_non_nullable
                        as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ServiceRequestImplCopyWith<$Res>
    implements $ServiceRequestCopyWith<$Res> {
  factory _$$ServiceRequestImplCopyWith(
    _$ServiceRequestImpl value,
    $Res Function(_$ServiceRequestImpl) then,
  ) = __$$ServiceRequestImplCopyWithImpl<$Res>;
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
    String? clientImage,
    String location,
    @JsonKey(fromJson: _latitudeFromJson) double? latitude,
    @JsonKey(fromJson: _longitudeFromJson) double? longitude,
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
    List<String> photos,
  });
}

/// @nodoc
class __$$ServiceRequestImplCopyWithImpl<$Res>
    extends _$ServiceRequestCopyWithImpl<$Res, _$ServiceRequestImpl>
    implements _$$ServiceRequestImplCopyWith<$Res> {
  __$$ServiceRequestImplCopyWithImpl(
    _$ServiceRequestImpl _value,
    $Res Function(_$ServiceRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ServiceRequest
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
    Object? clientImage = freezed,
    Object? location = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
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
    Object? photos = null,
  }) {
    return _then(
      _$ServiceRequestImpl(
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
        clientImage:
            freezed == clientImage
                ? _value.clientImage
                : clientImage // ignore: cast_nullable_to_non_nullable
                    as String?,
        location:
            null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                    as String,
        latitude:
            freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                    as double?,
        longitude:
            freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                    as double?,
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
        photos:
            null == photos
                ? _value._photos
                : photos // ignore: cast_nullable_to_non_nullable
                    as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceRequestImpl implements _ServiceRequest {
  const _$ServiceRequestImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.clientId,
    required this.clientName,
    required this.clientPhone,
    this.clientImage,
    required this.location,
    @JsonKey(fromJson: _latitudeFromJson) this.latitude,
    @JsonKey(fromJson: _longitudeFromJson) this.longitude,
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
    final List<String> photos = const [],
  }) : _photos = photos;

  factory _$ServiceRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceRequestImplFromJson(json);

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
  final String? clientImage;
  @override
  final String location;
  @override
  @JsonKey(fromJson: _latitudeFromJson)
  final double? latitude;
  @override
  @JsonKey(fromJson: _longitudeFromJson)
  final double? longitude;
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
  final List<String> _photos;
  @override
  @JsonKey()
  List<String> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  @override
  String toString() {
    return 'ServiceRequest(id: $id, title: $title, description: $description, category: $category, clientId: $clientId, clientName: $clientName, clientPhone: $clientPhone, clientImage: $clientImage, location: $location, latitude: $latitude, longitude: $longitude, budget: $budget, createdAt: $createdAt, deadline: $deadline, status: $status, assignedPrestataireId: $assignedPrestataireId, prestataireName: $prestataireName, assignedPrestataireName: $assignedPrestataireName, notes: $notes, completionDate: $completionDate, completionNotes: $completionNotes, photos: $photos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceRequestImpl &&
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
            (identical(other.clientImage, clientImage) ||
                other.clientImage == clientImage) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
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
                other.completionNotes == completionNotes) &&
            const DeepCollectionEquality().equals(other._photos, _photos));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    description,
    category,
    clientId,
    clientName,
    clientPhone,
    clientImage,
    location,
    latitude,
    longitude,
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
    const DeepCollectionEquality().hash(_photos),
  ]);

  /// Create a copy of ServiceRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceRequestImplCopyWith<_$ServiceRequestImpl> get copyWith =>
      __$$ServiceRequestImplCopyWithImpl<_$ServiceRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceRequestImplToJson(this);
  }
}

abstract class _ServiceRequest implements ServiceRequest {
  const factory _ServiceRequest({
    required final String id,
    required final String title,
    required final String description,
    required final String category,
    required final String clientId,
    required final String clientName,
    required final String clientPhone,
    final String? clientImage,
    required final String location,
    @JsonKey(fromJson: _latitudeFromJson) final double? latitude,
    @JsonKey(fromJson: _longitudeFromJson) final double? longitude,
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
    final List<String> photos,
  }) = _$ServiceRequestImpl;

  factory _ServiceRequest.fromJson(Map<String, dynamic> json) =
      _$ServiceRequestImpl.fromJson;

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
  String? get clientImage;
  @override
  String get location;
  @override
  @JsonKey(fromJson: _latitudeFromJson)
  double? get latitude;
  @override
  @JsonKey(fromJson: _longitudeFromJson)
  double? get longitude;
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
  @override
  List<String> get photos;

  /// Create a copy of ServiceRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceRequestImplCopyWith<_$ServiceRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
