import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Charger les utilisateurs depuis le JSON
      final usersData = await localDataSource.loadAssetJson('assets/mock/users.json');
      final usersList = usersData['users'] as List<dynamic>? ?? usersData as List<dynamic>;
      
      // Trouver l'utilisateur avec cet email
      final userData = usersList.firstWhere(
        (user) => user['email'] == email,
        orElse: () => null,
      );

      if (userData == null) {
        return const Left(Failure.authentication(message: 'Email ou mot de passe incorrect'));
      }

      // Pour le MVP, on accepte n'importe quel mot de passe
      final user = User.fromJson(userData as Map<String, dynamic>);

      // Sauvegarder la session
      await localDataSource.saveToCache('current_user', user.toJson());
      await localDataSource.saveToCache('is_logged_in', {'value': true});

      return Right(user);
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      // Pour le MVP, créer un nouvel utilisateur temporaire
      final newUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        role: role,
        isOnline: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Sauvegarder la session
      await localDataSource.saveToCache('current_user', newUser.toJson());
      await localDataSource.saveToCache('is_logged_in', {'value': true});

      return Right(newUser);
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.saveToCache('is_logged_in', {'value': false});
      // Optionnel: supprimer les données utilisateur
      // await localDataSource.clearCache();
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
