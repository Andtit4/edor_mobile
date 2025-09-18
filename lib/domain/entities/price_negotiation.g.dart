// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_negotiation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PriceNegotiationImpl _$$PriceNegotiationImplFromJson(
  Map<String, dynamic> json,
) => _$PriceNegotiationImpl(
  id: json['id'] as String,
  serviceRequestId: json['serviceRequestId'] as String,
  prestataireId: json['prestataireId'] as String,
  clientId: json['clientId'] as String,
  proposedPrice: (json['proposedPrice'] as num).toDouble(),
  message: json['message'] as String?,
  status:
      $enumDecodeNullable(_$NegotiationStatusEnumMap, json['status']) ??
      NegotiationStatus.pending,
  isFromPrestataire: json['isFromPrestataire'] as bool? ?? true,
  parentNegotiationId: json['parentNegotiationId'] as String?,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
  prestataireName: json['prestataireName'] as String?,
  serviceRequestTitle: json['serviceRequestTitle'] as String?,
  clientName: json['clientName'] as String?,
);

Map<String, dynamic> _$$PriceNegotiationImplToJson(
  _$PriceNegotiationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'serviceRequestId': instance.serviceRequestId,
  'prestataireId': instance.prestataireId,
  'clientId': instance.clientId,
  'proposedPrice': instance.proposedPrice,
  'message': instance.message,
  'status': _$NegotiationStatusEnumMap[instance.status]!,
  'isFromPrestataire': instance.isFromPrestataire,
  'parentNegotiationId': instance.parentNegotiationId,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'prestataireName': instance.prestataireName,
  'serviceRequestTitle': instance.serviceRequestTitle,
  'clientName': instance.clientName,
};

const _$NegotiationStatusEnumMap = {
  NegotiationStatus.pending: 'pending',
  NegotiationStatus.accepted: 'accepted',
  NegotiationStatus.rejected: 'rejected',
  NegotiationStatus.countered: 'countered',
};
