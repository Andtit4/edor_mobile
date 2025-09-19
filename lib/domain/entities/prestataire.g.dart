// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prestataire.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrestataireImpl _$$PrestataireImplFromJson(
  Map<String, dynamic> json,
) => _$PrestataireImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  avatar: json['avatar'] as String?,
  profileImage: json['profileImage'] as String?,
  phone: json['phone'] as String?,
  category: json['category'] as String,
  location: json['location'] as String,
  description: json['description'] as String,
  rating: _ratingFromJson(json['rating']),
  pricePerHour: _pricePerHourFromJson(json['pricePerHour']),
  skills:
      (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  portfolio:
      (json['portfolio'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  isAvailable: json['isAvailable'] as bool? ?? true,
  completedJobs:
      json['completedJobs'] == null
          ? 0
          : _completedJobsFromJson(json['completedJobs']),
  totalReviews:
      json['totalReviews'] == null
          ? 0
          : _totalReviewsFromJson(json['totalReviews']),
  reviewCount:
      json['reviewCount'] == null
          ? 0
          : _reviewCountFromJson(json['reviewCount']),
  createdAt: _dateTimeFromJsonNullable(json['createdAt']),
  updatedAt: _dateTimeFromJsonNullable(json['updatedAt']),
);

Map<String, dynamic> _$$PrestataireImplToJson(_$PrestataireImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'avatar': instance.avatar,
      'profileImage': instance.profileImage,
      'phone': instance.phone,
      'category': instance.category,
      'location': instance.location,
      'description': instance.description,
      'rating': instance.rating,
      'pricePerHour': instance.pricePerHour,
      'skills': instance.skills,
      'portfolio': instance.portfolio,
      'isAvailable': instance.isAvailable,
      'completedJobs': instance.completedJobs,
      'totalReviews': instance.totalReviews,
      'reviewCount': instance.reviewCount,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
