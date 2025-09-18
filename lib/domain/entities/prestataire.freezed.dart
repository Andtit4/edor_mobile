// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prestataire.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Prestataire _$PrestataireFromJson(Map<String, dynamic> json) {
  return _Prestataire.fromJson(json);
}

/// @nodoc
mixin _$Prestataire {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _ratingFromJson)
  double get rating => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _pricePerHourFromJson)
  int get pricePerHour => throw _privateConstructorUsedError;
  List<String> get skills => throw _privateConstructorUsedError;
  List<String> get portfolio => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _completedJobsFromJson)
  int get completedJobs => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _totalReviewsFromJson)
  int get totalReviews => throw _privateConstructorUsedError;
  @JsonKey(name: 'reviewCount', fromJson: _reviewCountFromJson)
  int get reviewCount => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJsonNullable)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJsonNullable)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Prestataire to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Prestataire
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrestataireCopyWith<Prestataire> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrestataireCopyWith<$Res> {
  factory $PrestataireCopyWith(
    Prestataire value,
    $Res Function(Prestataire) then,
  ) = _$PrestataireCopyWithImpl<$Res, Prestataire>;
  @useResult
  $Res call({
    String id,
    String name,
    String email,
    String? avatar,
    String? phone,
    String category,
    String location,
    String description,
    @JsonKey(fromJson: _ratingFromJson) double rating,
    @JsonKey(fromJson: _pricePerHourFromJson) int pricePerHour,
    List<String> skills,
    List<String> portfolio,
    bool isAvailable,
    @JsonKey(fromJson: _completedJobsFromJson) int completedJobs,
    @JsonKey(fromJson: _totalReviewsFromJson) int totalReviews,
    @JsonKey(name: 'reviewCount', fromJson: _reviewCountFromJson)
    int reviewCount,
    @JsonKey(fromJson: _dateTimeFromJsonNullable) DateTime? createdAt,
    @JsonKey(fromJson: _dateTimeFromJsonNullable) DateTime? updatedAt,
  });
}

/// @nodoc
class _$PrestataireCopyWithImpl<$Res, $Val extends Prestataire>
    implements $PrestataireCopyWith<$Res> {
  _$PrestataireCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Prestataire
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? avatar = freezed,
    Object? phone = freezed,
    Object? category = null,
    Object? location = null,
    Object? description = null,
    Object? rating = null,
    Object? pricePerHour = null,
    Object? skills = null,
    Object? portfolio = null,
    Object? isAvailable = null,
    Object? completedJobs = null,
    Object? totalReviews = null,
    Object? reviewCount = null,
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
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            email:
                null == email
                    ? _value.email
                    : email // ignore: cast_nullable_to_non_nullable
                        as String,
            avatar:
                freezed == avatar
                    ? _value.avatar
                    : avatar // ignore: cast_nullable_to_non_nullable
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
            description:
                null == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String,
            rating:
                null == rating
                    ? _value.rating
                    : rating // ignore: cast_nullable_to_non_nullable
                        as double,
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
            reviewCount:
                null == reviewCount
                    ? _value.reviewCount
                    : reviewCount // ignore: cast_nullable_to_non_nullable
                        as int,
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
abstract class _$$PrestataireImplCopyWith<$Res>
    implements $PrestataireCopyWith<$Res> {
  factory _$$PrestataireImplCopyWith(
    _$PrestataireImpl value,
    $Res Function(_$PrestataireImpl) then,
  ) = __$$PrestataireImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String email,
    String? avatar,
    String? phone,
    String category,
    String location,
    String description,
    @JsonKey(fromJson: _ratingFromJson) double rating,
    @JsonKey(fromJson: _pricePerHourFromJson) int pricePerHour,
    List<String> skills,
    List<String> portfolio,
    bool isAvailable,
    @JsonKey(fromJson: _completedJobsFromJson) int completedJobs,
    @JsonKey(fromJson: _totalReviewsFromJson) int totalReviews,
    @JsonKey(name: 'reviewCount', fromJson: _reviewCountFromJson)
    int reviewCount,
    @JsonKey(fromJson: _dateTimeFromJsonNullable) DateTime? createdAt,
    @JsonKey(fromJson: _dateTimeFromJsonNullable) DateTime? updatedAt,
  });
}

/// @nodoc
class __$$PrestataireImplCopyWithImpl<$Res>
    extends _$PrestataireCopyWithImpl<$Res, _$PrestataireImpl>
    implements _$$PrestataireImplCopyWith<$Res> {
  __$$PrestataireImplCopyWithImpl(
    _$PrestataireImpl _value,
    $Res Function(_$PrestataireImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Prestataire
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? avatar = freezed,
    Object? phone = freezed,
    Object? category = null,
    Object? location = null,
    Object? description = null,
    Object? rating = null,
    Object? pricePerHour = null,
    Object? skills = null,
    Object? portfolio = null,
    Object? isAvailable = null,
    Object? completedJobs = null,
    Object? totalReviews = null,
    Object? reviewCount = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$PrestataireImpl(
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
        email:
            null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                    as String,
        avatar:
            freezed == avatar
                ? _value.avatar
                : avatar // ignore: cast_nullable_to_non_nullable
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
        description:
            null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String,
        rating:
            null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                    as double,
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
        reviewCount:
            null == reviewCount
                ? _value.reviewCount
                : reviewCount // ignore: cast_nullable_to_non_nullable
                    as int,
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
class _$PrestataireImpl implements _Prestataire {
  const _$PrestataireImpl({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.phone,
    required this.category,
    required this.location,
    required this.description,
    @JsonKey(fromJson: _ratingFromJson) required this.rating,
    @JsonKey(fromJson: _pricePerHourFromJson) required this.pricePerHour,
    final List<String> skills = const [],
    final List<String> portfolio = const [],
    this.isAvailable = true,
    @JsonKey(fromJson: _completedJobsFromJson) this.completedJobs = 0,
    @JsonKey(fromJson: _totalReviewsFromJson) this.totalReviews = 0,
    @JsonKey(name: 'reviewCount', fromJson: _reviewCountFromJson)
    this.reviewCount = 0,
    @JsonKey(fromJson: _dateTimeFromJsonNullable) this.createdAt,
    @JsonKey(fromJson: _dateTimeFromJsonNullable) this.updatedAt,
  }) : _skills = skills,
       _portfolio = portfolio;

  factory _$PrestataireImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrestataireImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String email;
  @override
  final String? avatar;
  @override
  final String? phone;
  @override
  final String category;
  @override
  final String location;
  @override
  final String description;
  @override
  @JsonKey(fromJson: _ratingFromJson)
  final double rating;
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
  @JsonKey()
  final bool isAvailable;
  @override
  @JsonKey(fromJson: _completedJobsFromJson)
  final int completedJobs;
  @override
  @JsonKey(fromJson: _totalReviewsFromJson)
  final int totalReviews;
  @override
  @JsonKey(name: 'reviewCount', fromJson: _reviewCountFromJson)
  final int reviewCount;
  @override
  @JsonKey(fromJson: _dateTimeFromJsonNullable)
  final DateTime? createdAt;
  @override
  @JsonKey(fromJson: _dateTimeFromJsonNullable)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Prestataire(id: $id, name: $name, email: $email, avatar: $avatar, phone: $phone, category: $category, location: $location, description: $description, rating: $rating, pricePerHour: $pricePerHour, skills: $skills, portfolio: $portfolio, isAvailable: $isAvailable, completedJobs: $completedJobs, totalReviews: $totalReviews, reviewCount: $reviewCount, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrestataireImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.pricePerHour, pricePerHour) ||
                other.pricePerHour == pricePerHour) &&
            const DeepCollectionEquality().equals(other._skills, _skills) &&
            const DeepCollectionEquality().equals(
              other._portfolio,
              _portfolio,
            ) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.completedJobs, completedJobs) ||
                other.completedJobs == completedJobs) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
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
    name,
    email,
    avatar,
    phone,
    category,
    location,
    description,
    rating,
    pricePerHour,
    const DeepCollectionEquality().hash(_skills),
    const DeepCollectionEquality().hash(_portfolio),
    isAvailable,
    completedJobs,
    totalReviews,
    reviewCount,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Prestataire
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrestataireImplCopyWith<_$PrestataireImpl> get copyWith =>
      __$$PrestataireImplCopyWithImpl<_$PrestataireImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrestataireImplToJson(this);
  }
}

abstract class _Prestataire implements Prestataire {
  const factory _Prestataire({
    required final String id,
    required final String name,
    required final String email,
    final String? avatar,
    final String? phone,
    required final String category,
    required final String location,
    required final String description,
    @JsonKey(fromJson: _ratingFromJson) required final double rating,
    @JsonKey(fromJson: _pricePerHourFromJson) required final int pricePerHour,
    final List<String> skills,
    final List<String> portfolio,
    final bool isAvailable,
    @JsonKey(fromJson: _completedJobsFromJson) final int completedJobs,
    @JsonKey(fromJson: _totalReviewsFromJson) final int totalReviews,
    @JsonKey(name: 'reviewCount', fromJson: _reviewCountFromJson)
    final int reviewCount,
    @JsonKey(fromJson: _dateTimeFromJsonNullable) final DateTime? createdAt,
    @JsonKey(fromJson: _dateTimeFromJsonNullable) final DateTime? updatedAt,
  }) = _$PrestataireImpl;

  factory _Prestataire.fromJson(Map<String, dynamic> json) =
      _$PrestataireImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get email;
  @override
  String? get avatar;
  @override
  String? get phone;
  @override
  String get category;
  @override
  String get location;
  @override
  String get description;
  @override
  @JsonKey(fromJson: _ratingFromJson)
  double get rating;
  @override
  @JsonKey(fromJson: _pricePerHourFromJson)
  int get pricePerHour;
  @override
  List<String> get skills;
  @override
  List<String> get portfolio;
  @override
  bool get isAvailable;
  @override
  @JsonKey(fromJson: _completedJobsFromJson)
  int get completedJobs;
  @override
  @JsonKey(fromJson: _totalReviewsFromJson)
  int get totalReviews;
  @override
  @JsonKey(name: 'reviewCount', fromJson: _reviewCountFromJson)
  int get reviewCount;
  @override
  @JsonKey(fromJson: _dateTimeFromJsonNullable)
  DateTime? get createdAt;
  @override
  @JsonKey(fromJson: _dateTimeFromJsonNullable)
  DateTime? get updatedAt;

  /// Create a copy of Prestataire
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrestataireImplCopyWith<_$PrestataireImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
