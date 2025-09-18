import 'package:freezed_annotation/freezed_annotation.dart';

part 'prestataire.freezed.dart';
part 'prestataire.g.dart';

@freezed
class Prestataire with _$Prestataire {
  const factory Prestataire({
    required String id,
    required String name,
    required String email,
    String? avatar,
    String? phone,
    required String category,
    required String location,
    required String description,
    required double rating,
    required int pricePerHour,
    @Default([]) List<String> skills,
    @Default([]) List<String> portfolio,
    @Default(true) bool isAvailable,
    @Default(0) int completedJobs,
    @Default(0) int totalReviews,
    @JsonKey(name: 'reviewCount') @Default(0) int reviewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Prestataire;

  factory Prestataire.fromJson(Map<String, dynamic> json) =>
      _$PrestataireFromJson(json);
}
