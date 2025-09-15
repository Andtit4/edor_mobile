// lib/data/repositories_impl/auth_repository_impl.dart
import 'package:edor/core/network/network_info.dart';
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

  AuthRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource, required NetworkInfo networkInfo,
  });

  // lib/data/repositories_impl/auth_repository_impl.dart
  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('Starting login process...');
      final result = await remoteDataSource.login(email, password);

      print('Login result received: ${result.keys}');

      if (result['user'] == null || result['token'] == null) {
        print('Error: Missing user or token in login result');
        return Left(
          Failure.server(message: 'Données manquantes dans la réponse'),
        );
      }

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

  // lib/data/repositories_impl/auth_repository_impl.dart
  @override
  Future<Either<Failure, User>> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      print('Starting register process...');
      final result = await remoteDataSource.register(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        email: email,
        password: password,
        role: role,
      );

      print('Register result received: ${result.keys}');

      if (result['user'] == null || result['token'] == null) {
        print('Error: Missing user or token in result');
        return Left(
          Failure.server(message: 'Données manquantes dans la réponse'),
        );
      }

      final user = result['user'] as User;
      final token = result['token'] as String;

      print('User parsed: ${user.email}, Token: ${token.substring(0, 20)}...');

      // Sauvegarder la session avec le token
      await localDataSource.saveToCache('current_user', user.toJson());
      await localDataSource.saveToCache('auth_token', {'token': token});
      await localDataSource.saveToCache('is_logged_in', {'value': true});

      print('User data saved to cache');

      return Right(user);
    } on ConflictException catch (e) {
      print('ConflictException: ${e.message}');
      return Left(Failure.authentication(message: e.message));
    } on ServerException catch (e) {
      print('ServerException: ${e.message}');
      return Left(Failure.server(message: e.message));
    } on CacheException catch (e) {
      print('CacheException: ${e.message}');
      return Left(Failure.cache(message: e.message));
    } catch (e) {
      print('Unknown exception: $e');
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.saveToCache('is_logged_in', {'value': false});
      await localDataSource.saveToCache('auth_token', {'token': ''});
      return const Right(null);
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
      if (userData == null) return const Right(null);

      final user = User.fromJson(userData);
      return Right(user);
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final loginData = await localDataSource.getFromCache('is_logged_in');
      final isLoggedIn = loginData?['value'] as bool? ?? false;
      return Right(isLoggedIn);
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}
