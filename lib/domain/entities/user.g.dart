// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: json['id'] as String,
  email: json['email'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  phone: json['phone'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  profileImage: json['profileImage'] as String?,
  address: json['address'] as String?,
  city: json['city'] as String?,
  postalCode: json['postalCode'] as String?,
  bio: json['bio'] as String?,
  rating: (json['rating'] as num?)?.toDouble(),
  reviewCount: (json['reviewCount'] as num?)?.toInt(),
  skills: (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
  categories:
      (json['categories'] as List<dynamic>?)?.map((e) => e as String).toList(),
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'role': _$UserRoleEnumMap[instance.role]!,
      'profileImage': instance.profileImage,
      'address': instance.address,
      'city': instance.city,
      'postalCode': instance.postalCode,
      'bio': instance.bio,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'skills': instance.skills,
      'categories': instance.categories,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.client: 'client',
  UserRole.prestataire: 'prestataire',
};
