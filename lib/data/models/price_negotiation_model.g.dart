// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_negotiation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceNegotiationModel _$PriceNegotiationModelFromJson(
  Map<String, dynamic> json,
) => PriceNegotiationModel(
  id: json['id'] as String,
  serviceRequestId: json['serviceRequestId'] as String,
  prestataireId: json['prestataireId'] as String,
  clientId: json['clientId'] as String,
  proposedPrice: (json['proposedPrice'] as num).toDouble(),
  message: json['message'] as String?,
  status: json['status'] as String,
  isFromPrestataire: json['isFromPrestataire'] as bool,
  parentNegotiationId: json['parentNegotiationId'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  prestataireName: json['prestataireName'] as String?,
  serviceRequestTitle: json['serviceRequestTitle'] as String?,
  clientName: json['clientName'] as String?,
);

Map<String, dynamic> _$PriceNegotiationModelToJson(
  PriceNegotiationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'serviceRequestId': instance.serviceRequestId,
  'prestataireId': instance.prestataireId,
  'clientId': instance.clientId,
  'proposedPrice': instance.proposedPrice,
  'message': instance.message,
  'status': instance.status,
  'isFromPrestataire': instance.isFromPrestataire,
  'parentNegotiationId': instance.parentNegotiationId,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'prestataireName': instance.prestataireName,
  'serviceRequestTitle': instance.serviceRequestTitle,
  'clientName': instance.clientName,
};
