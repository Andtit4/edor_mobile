// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
  id: json['id'] as String,
  serviceRequestId: json['serviceRequestId'] as String,
  prestataireId: json['prestataireId'] as String,
  clientId: json['clientId'] as String,
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  clientName: json['clientName'] as String?,
  serviceRequestTitle: json['serviceRequestTitle'] as String?,
);

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serviceRequestId': instance.serviceRequestId,
      'prestataireId': instance.prestataireId,
      'clientId': instance.clientId,
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'clientName': instance.clientName,
      'serviceRequestTitle': instance.serviceRequestTitle,
    };

_$ReviewModelImpl _$$ReviewModelImplFromJson(Map<String, dynamic> json) =>
    _$ReviewModelImpl(
      id: json['id'] as String,
      serviceRequestId: json['serviceRequestId'] as String,
      prestataireId: json['prestataireId'] as String,
      clientId: json['clientId'] as String,
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      clientName: json['clientName'] as String?,
      serviceRequestTitle: json['serviceRequestTitle'] as String?,
    );

Map<String, dynamic> _$$ReviewModelImplToJson(_$ReviewModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serviceRequestId': instance.serviceRequestId,
      'prestataireId': instance.prestataireId,
      'clientId': instance.clientId,
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'clientName': instance.clientName,
      'serviceRequestTitle': instance.serviceRequestTitle,
    };
