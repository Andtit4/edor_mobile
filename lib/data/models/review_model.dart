import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/review.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

@freezed
@JsonSerializable()
class ReviewModel with _$ReviewModel {
  const factory ReviewModel({
    required String id,
    required String serviceRequestId,
    required String prestataireId,
    required String clientId,
    required int rating,
    String? comment,
    String? createdAt,
    String? updatedAt,
    // Informations supplémentaires
    String? clientName,
    String? serviceRequestTitle,
  }) = _ReviewModel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);
}

extension ReviewModelExtension on ReviewModel {
  Review toEntity() {
    return Review(
      id: id,
      serviceRequestId: serviceRequestId,
      prestataireId: prestataireId,
      clientId: clientId,
      rating: rating,
      comment: comment,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
      // Informations supplémentaires
      clientName: clientName,
      serviceRequestTitle: serviceRequestTitle,
    );
  }
}
