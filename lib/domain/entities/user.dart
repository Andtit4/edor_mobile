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
    double? rating,
    int? reviewCount,
    List<String>? skills, // Pour les prestataires
    List<String>? categories, // Pour les prestataires
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
