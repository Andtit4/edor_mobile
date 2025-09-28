// lib/domain/entities/price_negotiation.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'price_negotiation.freezed.dart';
part 'price_negotiation.g.dart';

enum NegotiationStatus {
  pending,
  accepted,
  rejected,
  countered,
}

@freezed
class PriceNegotiation with _$PriceNegotiation {
  const factory PriceNegotiation({
    required String id,
    required String serviceRequestId,
    required String prestataireId,
    required String clientId,
    required double proposedPrice,
    String? message,
    @Default(NegotiationStatus.pending) NegotiationStatus status,
    @Default(true) bool isFromPrestataire,
    String? parentNegotiationId,
    DateTime? createdAt,
    DateTime? updatedAt,
    // Informations supplémentaires
    String? prestataireName,
    String? serviceRequestTitle,
    String? clientName,
  }) = _PriceNegotiation;

  factory PriceNegotiation.fromJson(Map<String, dynamic> json) =>
      _$PriceNegotiationFromJson(json);
}
