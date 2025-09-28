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
    String? profileImage,
    String? phone,
    required String category,
    required String location,
    required String description,
    @JsonKey(fromJson: _ratingFromJson) required double rating,
    @JsonKey(fromJson: _pricePerHourFromJson) required int pricePerHour,
    @Default([]) List<String> skills,
    @Default([]) List<String> portfolio,
    @Default(true) bool isAvailable,
    @JsonKey(fromJson: _completedJobsFromJson) @Default(0) int completedJobs,
    @JsonKey(fromJson: _totalReviewsFromJson) @Default(0) int totalReviews,
    @JsonKey(name: 'reviewCount', fromJson: _reviewCountFromJson) @Default(0) int reviewCount,
    @JsonKey(fromJson: _dateTimeFromJsonNullable) DateTime? createdAt,
    @JsonKey(fromJson: _dateTimeFromJsonNullable) DateTime? updatedAt,
  }) = _Prestataire;

  factory Prestataire.fromJson(Map<String, dynamic> json) =>
      _$PrestataireFromJson(json);
}

// Fonctions de conversion pour gérer les types mixtes
double _ratingFromJson(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

int _pricePerHourFromJson(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

int _completedJobsFromJson(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

int _totalReviewsFromJson(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

int _reviewCountFromJson(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

DateTime? _dateTimeFromJsonNullable(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  return null;
}
