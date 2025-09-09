// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReservationImpl _$$ReservationImplFromJson(Map<String, dynamic> json) =>
    _$ReservationImpl(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      prestataireId: json['prestataireId'] as String,
      service: json['service'] as String,
      scheduledDate: DateTime.parse(json['scheduledDate'] as String),
      duration: (json['duration'] as num).toInt(),
      totalPrice: (json['totalPrice'] as num).toInt(),
      status: $enumDecode(_$ReservationStatusEnumMap, json['status']),
      description: json['description'] as String?,
      clientNotes: json['clientNotes'] as String?,
      prestataireNotes: json['prestataireNotes'] as String?,
      address: json['address'] as String?,
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ReservationImplToJson(_$ReservationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'prestataireId': instance.prestataireId,
      'service': instance.service,
      'scheduledDate': instance.scheduledDate.toIso8601String(),
      'duration': instance.duration,
      'totalPrice': instance.totalPrice,
      'status': _$ReservationStatusEnumMap[instance.status]!,
      'description': instance.description,
      'clientNotes': instance.clientNotes,
      'prestataireNotes': instance.prestataireNotes,
      'address': instance.address,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$ReservationStatusEnumMap = {
  ReservationStatus.pending: 'pending',
  ReservationStatus.confirmed: 'confirmed',
  ReservationStatus.inProgress: 'inProgress',
  ReservationStatus.completed: 'completed',
  ReservationStatus.cancelled: 'cancelled',
};
