import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_offer.freezed.dart';
part 'service_offer.g.dart';

@freezed
class ServiceOffer with _$ServiceOffer {
  const factory ServiceOffer({
    required String id,
    required String title,
    required String description,
    required String category,
    required String prestataireId,
    required String prestataireName,
    required String prestatairePhone,
    required String location,
    required double price,
    required DateTime createdAt,
    @Default('available') String status,
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
    @Default([]) List<String> images,
    String? experience,
    String? availability,
  }) = _ServiceOffer;

  factory ServiceOffer.fromJson(Map<String, dynamic> json) =>
      _$ServiceOfferFromJson(json);
}
