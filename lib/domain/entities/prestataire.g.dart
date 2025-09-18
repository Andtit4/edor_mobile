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
  phone: json['phone'] as String?,
  category: json['category'] as String,
  location: json['location'] as String,
  description: json['description'] as String,
  rating: (json['rating'] as num).toDouble(),
  pricePerHour: (json['pricePerHour'] as num).toInt(),
  skills:
      (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  portfolio:
      (json['portfolio'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  isAvailable: json['isAvailable'] as bool? ?? true,
  completedJobs: (json['completedJobs'] as num?)?.toInt() ?? 0,
  totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
  reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$PrestataireImplToJson(_$PrestataireImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'avatar': instance.avatar,
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
