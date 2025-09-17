// lib/data/models/price_negotiation_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/price_negotiation.dart';

part 'price_negotiation_model.freezed.dart';
part 'price_negotiation_model.g.dart';

@freezed
@JsonSerializable()
class PriceNegotiationModel with _$PriceNegotiationModel {
  const factory PriceNegotiationModel({
    required String id,
    required String serviceRequestId,
    required String prestataireId,
    required String clientId,
    required double proposedPrice,
    String? message,
    @Default('pending') String status,
    @Default(true) bool isFromPrestataire,
    String? parentNegotiationId,
    String? createdAt,
    String? updatedAt,
  }) = _PriceNegotiationModel;

  factory PriceNegotiationModel.fromJson(Map<String, dynamic> json) {
    // Convertir proposedPrice de String vers double si nécessaire
    if (json['proposedPrice'] is String) {
      json['proposedPrice'] = double.parse(json['proposedPrice']);
    }
    return _$PriceNegotiationModelFromJson(json);
  }
}

extension PriceNegotiationModelExtension on PriceNegotiationModel {
  PriceNegotiation toEntity() {
    return PriceNegotiation(
      id: id,
      serviceRequestId: serviceRequestId,
      prestataireId: prestataireId,
      clientId: clientId,
      proposedPrice: proposedPrice,
      message: message,
      status: _statusFromString(status),
      isFromPrestataire: isFromPrestataire,
      parentNegotiationId: parentNegotiationId,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
    );
  }

  NegotiationStatus _statusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return NegotiationStatus.pending;
      case 'accepted':
        return NegotiationStatus.accepted;
      case 'rejected':
        return NegotiationStatus.rejected;
      case 'countered':
        return NegotiationStatus.countered;
      default:
        return NegotiationStatus.pending;
    }
  }
}
