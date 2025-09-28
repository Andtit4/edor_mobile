// lib/data/models/user_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    required String phone,
    required String role,
    String? profileImage,
    String? address,
    String? city,
    String? postalCode,
    String? bio,
    @JsonKey(fromJson: _ratingFromJson) double? rating,
    @JsonKey(fromJson: _reviewCountFromJson) int? reviewCount,
    List<String>? skills,
    List<String>? categories,
    String? createdAt,
    String? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}

// Extension pour ajouter la méthode toEntity
extension UserModelExtension on UserModel {
  User toEntity() {
    return User(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      role: UserRole.values.firstWhere((e) => e.name == role),
      profileImage: profileImage,
      address: address,
      city: city,
      postalCode: postalCode,
      bio: bio,
      rating: rating,
      reviewCount: reviewCount,
      skills: skills,
      categories: categories,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
    );
  }
}

// Fonctions de conversion pour gérer les types mixtes
double? _ratingFromJson(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    // Gérer les cas comme "0.00"
    final parsed = double.tryParse(value);
    return parsed;
  }
  return null;
}

int? _reviewCountFromJson(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}