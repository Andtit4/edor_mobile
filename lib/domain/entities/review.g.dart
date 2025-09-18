// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewImpl _$$ReviewImplFromJson(Map<String, dynamic> json) => _$ReviewImpl(
  id: json['id'] as String,
  serviceRequestId: json['serviceRequestId'] as String,
  prestataireId: json['prestataireId'] as String,
  clientId: json['clientId'] as String,
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String?,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
  clientName: json['clientName'] as String?,
  serviceRequestTitle: json['serviceRequestTitle'] as String?,
);

Map<String, dynamic> _$$ReviewImplToJson(_$ReviewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serviceRequestId': instance.serviceRequestId,
      'prestataireId': instance.prestataireId,
      'clientId': instance.clientId,
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'clientName': instance.clientName,
      'serviceRequestTitle': instance.serviceRequestTitle,
    };
