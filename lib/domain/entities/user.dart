// lib/domain/entities/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

enum UserRole { client, prestataire }

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    required String phone,
    required UserRole role,
    String? profileImage,
    String? address,
    String? city,
    String? postalCode,
    String? bio,
    @JsonKey(fromJson: _ratingFromJson) double? rating,
    @JsonKey(fromJson: _reviewCountFromJson) int? reviewCount,
    List<String>? skills,
    List<String>? categories,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

// Fonctions de conversion
double? _ratingFromJson(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

int? _reviewCountFromJson(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}