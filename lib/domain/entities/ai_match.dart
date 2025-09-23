import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_match.freezed.dart';
part 'ai_match.g.dart';

@freezed
class AIMatch with _$AIMatch {
  const factory AIMatch({
    required String id,
    required String serviceRequestId,
    required String prestataireId,
    @JsonKey(fromJson: _compatibilityScoreFromJson) required double compatibilityScore,
    @JsonKey(fromJson: _skillsScoreFromJson) required double skillsScore,
    @JsonKey(fromJson: _performanceScoreFromJson) required double performanceScore,
    @JsonKey(fromJson: _locationScoreFromJson) required double locationScore,
    @JsonKey(fromJson: _budgetScoreFromJson) required double budgetScore,
    @JsonKey(fromJson: _availabilityScoreFromJson) required double availabilityScore,
    @JsonKey(fromJson: _distanceFromJson) double? distance,
    @JsonKey(fromJson: _estimatedPriceFromJson) double? estimatedPrice,
    required String reasoning,
    required AIMatchingFactors matchingFactors,
    required String status,
    @JsonKey(fromJson: _dateTimeFromJsonNullable) DateTime? expiresAt,
    @JsonKey(fromJson: _dateTimeFromJson) required DateTime createdAt,
    @JsonKey(fromJson: _dateTimeFromJson) required DateTime updatedAt,
    PrestataireInfo? prestataire,
  }) = _AIMatch;

  factory AIMatch.fromJson(Map<String, dynamic> json) =>
      _$AIMatchFromJson(json);
}

@freezed
class AIMatchingFactors with _$AIMatchingFactors {
  const factory AIMatchingFactors({
    @Default([]) List<String> skills,
    required String location,
    required String budget,
    required String performance,
    required String availability,
  }) = _AIMatchingFactors;

  factory AIMatchingFactors.fromJson(Map<String, dynamic> json) =>
      _$AIMatchingFactorsFromJson(json);
}

@freezed
class PrestataireInfo with _$PrestataireInfo {
  const factory PrestataireInfo({
    required String id,
    required String name,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    required String category,
    required String location,
    String? address,
    String? city,
    String? bio,
    @JsonKey(fromJson: _ratingFromJson) required double rating,
    @JsonKey(fromJson: _reviewCountFromJson) required int reviewCount,
    @JsonKey(fromJson: _pricePerHourFromJson) required int pricePerHour,
    @Default([]) List<String> skills,
    @Default([]) List<String> portfolio,
    String? profileImage,
    required bool isAvailable,
    @JsonKey(fromJson: _completedJobsFromJson) required int completedJobs,
    @JsonKey(fromJson: _totalReviewsFromJson) required int totalReviews,
    @JsonKey(fromJson: _totalEarningsFromJson) required double totalEarnings,
  }) = _PrestataireInfo;

  factory PrestataireInfo.fromJson(Map<String, dynamic> json) =>
      _$PrestataireInfoFromJson(json);
}

// Fonctions de conversion pour gérer les types mixtes
double _compatibilityScoreFromJson(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

double _skillsScoreFromJson(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

double _performanceScoreFromJson(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

double _locationScoreFromJson(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

double _budgetScoreFromJson(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

double _availabilityScoreFromJson(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

double? _distanceFromJson(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

double? _estimatedPriceFromJson(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

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

double _totalEarningsFromJson(dynamic value) {
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

DateTime? _dateTimeFromJsonNullable(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  return null;
}
