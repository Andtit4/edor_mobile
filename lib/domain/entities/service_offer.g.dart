// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceOfferImpl _$$ServiceOfferImplFromJson(Map<String, dynamic> json) =>
    _$ServiceOfferImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      prestataireId: json['prestataireId'] as String,
      prestataireName: json['prestataireName'] as String,
      prestatairePhone: json['prestatairePhone'] as String,
      location: json['location'] as String,
      price: (json['price'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String? ?? 'available',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      experience: json['experience'] as String?,
      availability: json['availability'] as String?,
    );

Map<String, dynamic> _$$ServiceOfferImplToJson(_$ServiceOfferImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'prestataireId': instance.prestataireId,
      'prestataireName': instance.prestataireName,
      'prestatairePhone': instance.prestatairePhone,
      'location': instance.location,
      'price': instance.price,
      'createdAt': instance.createdAt.toIso8601String(),
      'status': instance.status,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'images': instance.images,
      'experience': instance.experience,
      'availability': instance.availability,
    };
