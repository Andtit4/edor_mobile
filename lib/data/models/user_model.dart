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
    String? rating, // Garder comme string pour le parsing
    String? reviewCount, // Garder comme string pour le parsing
    List<String>? skills,
    List<String>? categories,
    String? createdAt,
    String? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

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
      rating: rating != null ? double.tryParse(rating!) : null,
      reviewCount: reviewCount != null ? int.tryParse(reviewCount!) : null,
      skills: skills,
      categories: categories,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
    );
  }
}