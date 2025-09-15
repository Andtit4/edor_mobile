// lib/data/models/service_request_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/service_request.dart';

part 'service_request_model.freezed.dart';
part 'service_request_model.g.dart';

@freezed
class ServiceRequestModel with _$ServiceRequestModel {
  const factory ServiceRequestModel({
    required String id,
    required String title,
    required String description,
    required String category,
    required String clientId,
    required String clientName,
    required String clientPhone,
    required String location,
    @JsonKey(fromJson: _budgetFromJson) required double budget,
    @JsonKey(fromJson: _dateTimeFromJson) required DateTime createdAt,
    @JsonKey(fromJson: _dateTimeFromJson) required DateTime deadline,
    @Default('pending') String status,
    String? assignedPrestataireId,
    String? prestataireName,
    String? notes,
  }) = _ServiceRequestModel;

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) => 
      _$ServiceRequestModelFromJson(json);
}

// Extension pour ajouter la méthode toEntity
extension ServiceRequestModelExtension on ServiceRequestModel {
  ServiceRequest toEntity() {
    return ServiceRequest(
      id: id,
      title: title,
      description: description,
      category: category,
      clientId: clientId,
      clientName: clientName,
      clientPhone: clientPhone,
      location: location,
      budget: budget,
      createdAt: createdAt,
      deadline: deadline,
      status: status,
      assignedPrestataireId: assignedPrestataireId,
      prestataireName: prestataireName,
      notes: notes,
    );
  }
}

// Fonctions de conversion pour gérer les types mixtes
double _budgetFromJson(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

DateTime _dateTimeFromJson(dynamic value) {
  if (value == null) return DateTime.now();
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
  return DateTime.now();
}