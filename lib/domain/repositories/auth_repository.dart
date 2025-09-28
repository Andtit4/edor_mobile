// lib/domain/repositories/auth_repository.dart
import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({required String email, required String password});
  Future<Either<Failure, User>> register({
    required String email, 
    required String password, 
    required String firstName, 
    required String lastName, 
    required String phone,
    required UserRole role,
    String? category,
    String? location,
    String? description,
    double? pricePerHour,
    List<String>? skills,
  });
  Future<Either<Failure, bool>> isLoggedIn();
  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, String>> getToken();
}