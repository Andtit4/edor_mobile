// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(
  Map<String, dynamic> json,
) => _$UserModelImpl(
  id: json['id'] as String,
  email: json['email'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  phone: json['phone'] as String,
  role: json['role'] as String,
  profileImage: json['profileImage'] as String?,
  address: json['address'] as String?,
  city: json['city'] as String?,
  postalCode: json['postalCode'] as String?,
  bio: json['bio'] as String?,
  rating: json['rating'] as String?,
  reviewCount: json['reviewCount'] as String?,
  skills: (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
  categories:
      (json['categories'] as List<dynamic>?)?.map((e) => e as String).toList(),
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'role': instance.role,
      'profileImage': instance.profileImage,
      'address': instance.address,
      'city': instance.city,
      'postalCode': instance.postalCode,
      'bio': instance.bio,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'skills': instance.skills,
      'categories': instance.categories,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
