// lib/data/repositories_impl/auth_repository_impl.dart
import 'package:edor/core/network/network_info.dart';
import 'package:edor/data/models/user_model.dart';
import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/local_data_source.dart';
import '../datasources/remote/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login({required String email, required String password}) async {
    try {
      print('Starting login process...');
      final result = await remoteDataSource.login(email, password);
      final user = result['user'] as User;
      final token = result['token'] as String;

      print(
        'Login user parsed: ${user.email}, Token: ${token.substring(0, 20)}...',
      );

      // Sauvegarder la session avec le token
      await localDataSource.saveToCache('current_user', user.toJson());
      await localDataSource.saveToCache('auth_token', {'token': token});
      await localDataSource.saveToCache('is_logged_in', {'value': true});

      print('Login user data saved to cache');

      return Right(user);
    } on UnauthorizedException catch (e) {
      print('UnauthorizedException: ${e.message}');
      return Left(Failure.authentication(message: e.message));
    } on ServerException catch (e) {
      print('ServerException: ${e.message}');
      return Left(Failure.server(message: e.message));
    } on CacheException catch (e) {
      print('CacheException: ${e.message}');
      return Left(Failure.cache(message: e.message));
    } catch (e) {
      print('Unknown login exception: $e');
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final result = await remoteDataSource.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        role: role,
        category: category,
        location: location,
        description: description,
        pricePerHour: pricePerHour,
        skills: skills,
      );
      
      // Sauvegarder le token
      await localDataSource.saveToCache('auth_token', {'token': result['token']});
      
      // Convertir UserModel en User entity
      final userModel = UserModel.fromJson(result['user']);
      final user = userModel.toEntity();
      
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      print('Error in register: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final isLoggedInData = await localDataSource.getFromCache('is_logged_in');
      if (isLoggedInData != null && isLoggedInData['value'] == true) {
        return const Right(true);
      } else {
        return const Right(false);
      }
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final userData = await localDataSource.getFromCache('current_user');
      if (userData != null) {
        final user = User.fromJson(userData);
        return Right(user);
      } else {
        return const Right(null);
      }
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.removeFromCache('current_user');
      await localDataSource.removeFromCache('auth_token');
      await localDataSource.removeFromCache('is_logged_in');
      return const Right(null);
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getToken() async {
    try {
      final tokenData = await localDataSource.getFromCache('auth_token');
      if (tokenData != null && tokenData['token'] != null) {
        return Right(tokenData['token'] as String);
      } else {
        return Left(Failure.cache(message: 'Token non trouvé'));
      }
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}