// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_offer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ServiceOffer _$ServiceOfferFromJson(Map<String, dynamic> json) {
  return _ServiceOffer.fromJson(json);
}

/// @nodoc
mixin _$ServiceOffer {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get prestataireId => throw _privateConstructorUsedError;
  String get prestataireName => throw _privateConstructorUsedError;
  String get prestatairePhone => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  String? get experience => throw _privateConstructorUsedError;
  String? get availability => throw _privateConstructorUsedError;

  /// Serializes this ServiceOffer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceOffer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceOfferCopyWith<ServiceOffer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceOfferCopyWith<$Res> {
  factory $ServiceOfferCopyWith(
    ServiceOffer value,
    $Res Function(ServiceOffer) then,
  ) = _$ServiceOfferCopyWithImpl<$Res, ServiceOffer>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String category,
    String prestataireId,
    String prestataireName,
    String prestatairePhone,
    String location,
    double price,
    DateTime createdAt,
    String status,
    double rating,
    int reviewCount,
    List<String> images,
    String? experience,
    String? availability,
  });
}

/// @nodoc
class _$ServiceOfferCopyWithImpl<$Res, $Val extends ServiceOffer>
    implements $ServiceOfferCopyWith<$Res> {
  _$ServiceOfferCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceOffer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? prestataireId = null,
    Object? prestataireName = null,
    Object? prestatairePhone = null,
    Object? location = null,
    Object? price = null,
    Object? createdAt = null,
    Object? status = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? images = null,
    Object? experience = freezed,
    Object? availability = freezed,
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
            prestataireId:
                null == prestataireId
                    ? _value.prestataireId
                    : prestataireId // ignore: cast_nullable_to_non_nullable
                        as String,
            prestataireName:
                null == prestataireName
                    ? _value.prestataireName
                    : prestataireName // ignore: cast_nullable_to_non_nullable
                        as String,
            prestatairePhone:
                null == prestatairePhone
                    ? _value.prestatairePhone
                    : prestatairePhone // ignore: cast_nullable_to_non_nullable
                        as String,
            location:
                null == location
                    ? _value.location
                    : location // ignore: cast_nullable_to_non_nullable
                        as String,
            price:
                null == price
                    ? _value.price
                    : price // ignore: cast_nullable_to_non_nullable
                        as double,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as String,
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
            images:
                null == images
                    ? _value.images
                    : images // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            experience:
                freezed == experience
                    ? _value.experience
                    : experience // ignore: cast_nullable_to_non_nullable
                        as String?,
            availability:
                freezed == availability
                    ? _value.availability
                    : availability // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ServiceOfferImplCopyWith<$Res>
    implements $ServiceOfferCopyWith<$Res> {
  factory _$$ServiceOfferImplCopyWith(
    _$ServiceOfferImpl value,
    $Res Function(_$ServiceOfferImpl) then,
  ) = __$$ServiceOfferImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String category,
    String prestataireId,
    String prestataireName,
    String prestatairePhone,
    String location,
    double price,
    DateTime createdAt,
    String status,
    double rating,
    int reviewCount,
    List<String> images,
    String? experience,
    String? availability,
  });
}

/// @nodoc
class __$$ServiceOfferImplCopyWithImpl<$Res>
    extends _$ServiceOfferCopyWithImpl<$Res, _$ServiceOfferImpl>
    implements _$$ServiceOfferImplCopyWith<$Res> {
  __$$ServiceOfferImplCopyWithImpl(
    _$ServiceOfferImpl _value,
    $Res Function(_$ServiceOfferImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ServiceOffer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? prestataireId = null,
    Object? prestataireName = null,
    Object? prestatairePhone = null,
    Object? location = null,
    Object? price = null,
    Object? createdAt = null,
    Object? status = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? images = null,
    Object? experience = freezed,
    Object? availability = freezed,
  }) {
    return _then(
      _$ServiceOfferImpl(
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
        prestataireId:
            null == prestataireId
                ? _value.prestataireId
                : prestataireId // ignore: cast_nullable_to_non_nullable
                    as String,
        prestataireName:
            null == prestataireName
                ? _value.prestataireName
                : prestataireName // ignore: cast_nullable_to_non_nullable
                    as String,
        prestatairePhone:
            null == prestatairePhone
                ? _value.prestatairePhone
                : prestatairePhone // ignore: cast_nullable_to_non_nullable
                    as String,
        location:
            null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                    as String,
        price:
            null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                    as double,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as String,
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
        images:
            null == images
                ? _value._images
                : images // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        experience:
            freezed == experience
                ? _value.experience
                : experience // ignore: cast_nullable_to_non_nullable
                    as String?,
        availability:
            freezed == availability
                ? _value.availability
                : availability // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceOfferImpl implements _ServiceOffer {
  const _$ServiceOfferImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.prestataireId,
    required this.prestataireName,
    required this.prestatairePhone,
    required this.location,
    required this.price,
    required this.createdAt,
    this.status = 'available',
    this.rating = 0.0,
    this.reviewCount = 0,
    final List<String> images = const [],
    this.experience,
    this.availability,
  }) : _images = images;

  factory _$ServiceOfferImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceOfferImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String category;
  @override
  final String prestataireId;
  @override
  final String prestataireName;
  @override
  final String prestatairePhone;
  @override
  final String location;
  @override
  final double price;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final double rating;
  @override
  @JsonKey()
  final int reviewCount;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final String? experience;
  @override
  final String? availability;

  @override
  String toString() {
    return 'ServiceOffer(id: $id, title: $title, description: $description, category: $category, prestataireId: $prestataireId, prestataireName: $prestataireName, prestatairePhone: $prestatairePhone, location: $location, price: $price, createdAt: $createdAt, status: $status, rating: $rating, reviewCount: $reviewCount, images: $images, experience: $experience, availability: $availability)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceOfferImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.prestataireId, prestataireId) ||
                other.prestataireId == prestataireId) &&
            (identical(other.prestataireName, prestataireName) ||
                other.prestataireName == prestataireName) &&
            (identical(other.prestatairePhone, prestatairePhone) ||
                other.prestatairePhone == prestatairePhone) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.experience, experience) ||
                other.experience == experience) &&
            (identical(other.availability, availability) ||
                other.availability == availability));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    category,
    prestataireId,
    prestataireName,
    prestatairePhone,
    location,
    price,
    createdAt,
    status,
    rating,
    reviewCount,
    const DeepCollectionEquality().hash(_images),
    experience,
    availability,
  );

  /// Create a copy of ServiceOffer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceOfferImplCopyWith<_$ServiceOfferImpl> get copyWith =>
      __$$ServiceOfferImplCopyWithImpl<_$ServiceOfferImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceOfferImplToJson(this);
  }
}

abstract class _ServiceOffer implements ServiceOffer {
  const factory _ServiceOffer({
    required final String id,
    required final String title,
    required final String description,
    required final String category,
    required final String prestataireId,
    required final String prestataireName,
    required final String prestatairePhone,
    required final String location,
    required final double price,
    required final DateTime createdAt,
    final String status,
    final double rating,
    final int reviewCount,
    final List<String> images,
    final String? experience,
    final String? availability,
  }) = _$ServiceOfferImpl;

  factory _ServiceOffer.fromJson(Map<String, dynamic> json) =
      _$ServiceOfferImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get category;
  @override
  String get prestataireId;
  @override
  String get prestataireName;
  @override
  String get prestatairePhone;
  @override
  String get location;
  @override
  double get price;
  @override
  DateTime get createdAt;
  @override
  String get status;
  @override
  double get rating;
  @override
  int get reviewCount;
  @override
  List<String> get images;
  @override
  String? get experience;
  @override
  String? get availability;

  /// Create a copy of ServiceOffer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceOfferImplCopyWith<_$ServiceOfferImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
