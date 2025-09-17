// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_negotiation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PriceNegotiationModelImpl _$$PriceNegotiationModelImplFromJson(
  Map<String, dynamic> json,
) => _$PriceNegotiationModelImpl(
  id: json['id'] as String,
  serviceRequestId: json['serviceRequestId'] as String,
  prestataireId: json['prestataireId'] as String,
  clientId: json['clientId'] as String,
  proposedPrice: (json['proposedPrice'] as num).toDouble(),
  message: json['message'] as String?,
  status: json['status'] as String? ?? 'pending',
  isFromPrestataire: json['isFromPrestataire'] as bool? ?? true,
  parentNegotiationId: json['parentNegotiationId'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$$PriceNegotiationModelImplToJson(
  _$PriceNegotiationModelImpl instance,
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
};
