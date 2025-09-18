// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceRequestModelImpl _$$ServiceRequestModelImplFromJson(
  Map<String, dynamic> json,
) => _$ServiceRequestModelImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  category: json['category'] as String,
  clientId: json['clientId'] as String,
  clientName: json['clientName'] as String,
  clientPhone: json['clientPhone'] as String,
  location: json['location'] as String,
  latitude: _latitudeFromJson(json['latitude']),
  longitude: _longitudeFromJson(json['longitude']),
  budget: _budgetFromJson(json['budget']),
  createdAt: _dateTimeFromJson(json['createdAt']),
  deadline: _dateTimeFromJson(json['deadline']),
  status: json['status'] as String? ?? 'pending',
  assignedPrestataireId: json['assignedPrestataireId'] as String?,
  prestataireName: json['prestataireName'] as String?,
  assignedPrestataireName: json['assignedPrestataireName'] as String?,
  notes: json['notes'] as String?,
  completionDate: _dateTimeFromJsonNullable(json['completionDate']),
  completionNotes: json['completionNotes'] as String?,
);

Map<String, dynamic> _$$ServiceRequestModelImplToJson(
  _$ServiceRequestModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'category': instance.category,
  'clientId': instance.clientId,
  'clientName': instance.clientName,
  'clientPhone': instance.clientPhone,
  'location': instance.location,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'budget': instance.budget,
  'createdAt': instance.createdAt.toIso8601String(),
  'deadline': instance.deadline.toIso8601String(),
  'status': instance.status,
  'assignedPrestataireId': instance.assignedPrestataireId,
  'prestataireName': instance.prestataireName,
  'assignedPrestataireName': instance.assignedPrestataireName,
  'notes': instance.notes,
  'completionDate': instance.completionDate?.toIso8601String(),
  'completionNotes': instance.completionNotes,
};
