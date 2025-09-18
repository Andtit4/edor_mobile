import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_request.freezed.dart';
part 'service_request.g.dart';

@freezed
class ServiceRequest with _$ServiceRequest {
  const factory ServiceRequest({
    required String id,
    required String title,
    required String description,
    required String category,
    required String clientId,
    required String clientName,
    required String clientPhone,
    required String location,
    required double budget,
    required DateTime createdAt,
    required DateTime deadline,
    @Default('pending') String status,
    String? assignedPrestataireId,
    String? prestataireName,
    String? assignedPrestataireName,
    String? notes,
    DateTime? completionDate,
    String? completionNotes,
  }) = _ServiceRequest;

  factory ServiceRequest.fromJson(Map<String, dynamic> json) =>
      _$ServiceRequestFromJson(json);
}
