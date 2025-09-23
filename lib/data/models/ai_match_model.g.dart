// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_match_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AIMatchModelImpl _$$AIMatchModelImplFromJson(Map<String, dynamic> json) =>
    _$AIMatchModelImpl(
      id: json['id'] as String,
      serviceRequestId: json['serviceRequestId'] as String,
      prestataireId: json['prestataireId'] as String,
      compatibilityScore: _compatibilityScoreFromJson(
        json['compatibilityScore'],
      ),
      skillsScore: _skillsScoreFromJson(json['skillsScore']),
      performanceScore: _performanceScoreFromJson(json['performanceScore']),
      locationScore: _locationScoreFromJson(json['locationScore']),
      budgetScore: _budgetScoreFromJson(json['budgetScore']),
      availabilityScore: _availabilityScoreFromJson(json['availabilityScore']),
      distance: _distanceFromJson(json['distance']),
      estimatedPrice: _estimatedPriceFromJson(json['estimatedPrice']),
      reasoning: json['reasoning'] as String,
      matchingFactors: AIMatchingFactorsModel.fromJson(
        json['matchingFactors'] as Map<String, dynamic>,
      ),
      status: json['status'] as String,
      expiresAt: _dateTimeFromJsonNullable(json['expiresAt']),
      createdAt: _dateTimeFromJson(json['createdAt']),
      updatedAt: _dateTimeFromJson(json['updatedAt']),
      prestataire:
          json['prestataire'] == null
              ? null
              : PrestataireInfoModel.fromJson(
                json['prestataire'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$$AIMatchModelImplToJson(_$AIMatchModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serviceRequestId': instance.serviceRequestId,
      'prestataireId': instance.prestataireId,
      'compatibilityScore': instance.compatibilityScore,
      'skillsScore': instance.skillsScore,
      'performanceScore': instance.performanceScore,
      'locationScore': instance.locationScore,
      'budgetScore': instance.budgetScore,
      'availabilityScore': instance.availabilityScore,
      'distance': instance.distance,
      'estimatedPrice': instance.estimatedPrice,
      'reasoning': instance.reasoning,
      'matchingFactors': instance.matchingFactors,
      'status': instance.status,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'prestataire': instance.prestataire,
    };

_$AIMatchingFactorsModelImpl _$$AIMatchingFactorsModelImplFromJson(
  Map<String, dynamic> json,
) => _$AIMatchingFactorsModelImpl(
  skills:
      (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  location: json['location'] as String,
  budget: json['budget'] as String,
  performance: json['performance'] as String,
  availability: json['availability'] as String,
);

Map<String, dynamic> _$$AIMatchingFactorsModelImplToJson(
  _$AIMatchingFactorsModelImpl instance,
) => <String, dynamic>{
  'skills': instance.skills,
  'location': instance.location,
  'budget': instance.budget,
  'performance': instance.performance,
  'availability': instance.availability,
};

_$PrestataireInfoModelImpl _$$PrestataireInfoModelImplFromJson(
  Map<String, dynamic> json,
) => _$PrestataireInfoModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  category: json['category'] as String,
  location: json['location'] as String,
  address: json['address'] as String?,
  city: json['city'] as String?,
  bio: json['bio'] as String?,
  rating: _ratingFromJson(json['rating']),
  reviewCount: _reviewCountFromJson(json['reviewCount']),
  pricePerHour: _pricePerHourFromJson(json['pricePerHour']),
  skills:
      (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  portfolio:
      (json['portfolio'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  profileImage: json['profileImage'] as String?,
  isAvailable: json['isAvailable'] as bool,
  completedJobs: _completedJobsFromJson(json['completedJobs']),
  totalReviews: _totalReviewsFromJson(json['totalReviews']),
  totalEarnings: _totalEarningsFromJson(json['totalEarnings']),
);

Map<String, dynamic> _$$PrestataireInfoModelImplToJson(
  _$PrestataireInfoModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'phone': instance.phone,
  'category': instance.category,
  'location': instance.location,
  'address': instance.address,
  'city': instance.city,
  'bio': instance.bio,
  'rating': instance.rating,
  'reviewCount': instance.reviewCount,
  'pricePerHour': instance.pricePerHour,
  'skills': instance.skills,
  'portfolio': instance.portfolio,
  'profileImage': instance.profileImage,
  'isAvailable': instance.isAvailable,
  'completedJobs': instance.completedJobs,
  'totalReviews': instance.totalReviews,
  'totalEarnings': instance.totalEarnings,
};
