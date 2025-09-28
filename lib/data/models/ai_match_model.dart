// lib/data/models/ai_match_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/ai_match.dart';

part 'ai_match_model.freezed.dart';
part 'ai_match_model.g.dart';

@freezed
class AIMatchModel with _$AIMatchModel {
  const factory AIMatchModel({
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
    required AIMatchingFactorsModel matchingFactors,
    required String status,
    @JsonKey(fromJson: _dateTimeFromJsonNullable) DateTime? expiresAt,
    @JsonKey(fromJson: _dateTimeFromJson) required DateTime createdAt,
    @JsonKey(fromJson: _dateTimeFromJson) required DateTime updatedAt,
    PrestataireInfoModel? prestataire,
  }) = _AIMatchModel;

  factory AIMatchModel.fromJson(Map<String, dynamic> json) =>
      _$AIMatchModelFromJson(json);
}

@freezed
class AIMatchingFactorsModel with _$AIMatchingFactorsModel {
  const factory AIMatchingFactorsModel({
    @Default([]) List<String> skills,
    required String location,
    required String budget,
    required String performance,
    required String availability,
  }) = _AIMatchingFactorsModel;

  factory AIMatchingFactorsModel.fromJson(Map<String, dynamic> json) =>
      _$AIMatchingFactorsModelFromJson(json);
}

@freezed
class PrestataireInfoModel with _$PrestataireInfoModel {
  const factory PrestataireInfoModel({
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
  }) = _PrestataireInfoModel;

  factory PrestataireInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PrestataireInfoModelFromJson(json);
}

// Extension pour convertir vers les entités
extension AIMatchModelExtension on AIMatchModel {
  AIMatch toEntity() {
    return AIMatch(
      id: id,
      serviceRequestId: serviceRequestId,
      prestataireId: prestataireId,
      compatibilityScore: compatibilityScore,
      skillsScore: skillsScore,
      performanceScore: performanceScore,
      locationScore: locationScore,
      budgetScore: budgetScore,
      availabilityScore: availabilityScore,
      distance: distance,
      estimatedPrice: estimatedPrice,
      reasoning: reasoning,
      matchingFactors: matchingFactors.toEntity(),
      status: status,
      expiresAt: expiresAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      prestataire: prestataire?.toEntity(),
    );
  }
}

extension AIMatchingFactorsModelExtension on AIMatchingFactorsModel {
  AIMatchingFactors toEntity() {
    return AIMatchingFactors(
      skills: skills,
      location: location,
      budget: budget,
      performance: performance,
      availability: availability,
    );
  }
}

extension PrestataireInfoModelExtension on PrestataireInfoModel {
  PrestataireInfo toEntity() {
    return PrestataireInfo(
      id: id,
      name: name,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      category: category,
      location: location,
      address: address,
      city: city,
      bio: bio,
      rating: rating,
      reviewCount: reviewCount,
      pricePerHour: pricePerHour,
      skills: skills,
      portfolio: portfolio,
      profileImage: profileImage,
      isAvailable: isAvailable,
      completedJobs: completedJobs,
      totalReviews: totalReviews,
      totalEarnings: totalEarnings,
    );
  }
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
