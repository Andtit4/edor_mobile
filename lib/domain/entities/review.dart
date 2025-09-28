import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
class Review with _$Review {
  const factory Review({
    required String id,
    required String serviceRequestId,
    required String prestataireId,
    required String clientId,
    required int rating,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
    // Informations supplémentaires
    String? clientName,
    String? serviceRequestTitle,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) =>
      _$ReviewFromJson(json);
}
