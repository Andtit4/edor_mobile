import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/prestataire.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/prestataire_repository.dart';
import '../datasources/local/local_data_source.dart';

class PrestataireRepositoryImpl implements PrestataireRepository {
  final LocalDataSource localDataSource;

  PrestataireRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Prestataire>>> getAllPrestataires() async {
    try {
      final prestatairesData = await localDataSource.loadAssetJson(
        'assets/mock/prestataires.json',
      );
      
      // Gérer les deux cas : array direct ou object avec array
      List<dynamic> prestatairesList;
      if (prestatairesData is List) {
        prestatairesList = prestatairesData;
      } else if (prestatairesData is Map<String, dynamic>) {
        prestatairesList = prestatairesData['prestataires'] as List<dynamic>? ?? [];
      } else {
        throw const CacheException(message: 'Format de données invalide');
      }
      
      final prestataires = prestatairesList
          .map((json) => Prestataire.fromJson(json as Map<String, dynamic>))
          .toList();

      return Right(prestataires);
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Prestataire>>> getPrestatairesByCategory(
    String categoryId,
  ) async {
    try {
      final result = await getAllPrestataires();
      return result.fold((failure) => Left(failure), (prestataires) {
        final filtered = prestataires
            .where(
              (p) => p.category.toLowerCase().contains(
                categoryId.toLowerCase(),
              ),
            )
            .toList();
        return Right(filtered);
      });
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Prestataire>>> searchPrestataires(
    String query,
  ) async {
    try {
      final result = await getAllPrestataires();
      return result.fold((failure) => Left(failure), (prestataires) {
        final filtered = prestataires
            .where(
              (p) =>
                  p.name.toLowerCase().contains(query.toLowerCase()) ||
                  p.category.toLowerCase().contains(query.toLowerCase()) ||
                  p.skills.any(
                    (skill) =>
                        skill.toLowerCase().contains(query.toLowerCase()),
                  ),
            )
            .toList();
        return Right(filtered);
      });
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Prestataire>> getPrestataireById(String id) async {
    try {
      final result = await getAllPrestataires();
      return result.fold((failure) => Left(failure), (prestataires) {
        final prestataire = prestataires.firstWhere(
          (p) => p.id == id,
          orElse: () =>
              throw const CacheException(message: 'Prestataire non trouvé'),
        );
        return Right(prestataire);
      });
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final categoriesData = await localDataSource.loadAssetJson(
        'assets/mock/categories.json',
      );
      
      // Gérer les deux cas : array direct ou object avec array
      List<dynamic> categoriesList;
      if (categoriesData is List) {
        categoriesList = categoriesData;
      } else if (categoriesData is Map<String, dynamic>) {
        categoriesList = categoriesData['categories'] as List<dynamic>? ?? [];
      } else {
        throw const CacheException(message: 'Format de données invalide');
      }
      
      final categories = categoriesList
          .map((json) => Category.fromJson(json as Map<String, dynamic>))
          .toList();

      return Right(categories);
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Prestataire>>> getFavoritePrestataires() async {
    try {
      final favoritesData = await localDataSource.getFromCache(
        'favorite_prestataires',
      );
      if (favoritesData == null) return const Right([]);

      final favoriteIds =
          (favoritesData['ids'] as List<dynamic>).cast<String>();
      final result = await getAllPrestataires();

      return result.fold((failure) => Left(failure), (prestataires) {
        final favorites =
            prestataires.where((p) => favoriteIds.contains(p.id)).toList();
        return Right(favorites);
      });
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(String prestataireId) async {
    try {
      final favoritesData = await localDataSource.getFromCache(
        'favorite_prestataires',
      );
      final currentFavorites = favoritesData?['ids'] as List<dynamic>? ?? [];
      final favoriteIds = currentFavorites.cast<String>().toList();

      if (favoriteIds.contains(prestataireId)) {
        favoriteIds.remove(prestataireId);
      } else {
        favoriteIds.add(prestataireId);
      }

      await localDataSource.saveToCache('favorite_prestataires', {
        'ids': favoriteIds,
      });
      return const Right(null);
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}