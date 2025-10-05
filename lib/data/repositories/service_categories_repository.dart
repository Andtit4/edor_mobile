import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import 'dart:io';
import '../../domain/entities/service_category.dart';
import '../../domain/repositories/service_categories_repository.dart';
import '../datasources/remote/service_categories_remote_data_source.dart';
import '../../core/errors/failures.dart';

// Provider pour le repository
final serviceCategoriesRepositoryProvider = Provider<ServiceCategoriesRepository>((ref) {
  return ServiceCategoriesRepositoryImpl(
    remoteDataSource: ref.read(serviceCategoriesRemoteDataSourceProvider),
  );
});

// Implémentation du repository
class ServiceCategoriesRepositoryImpl implements ServiceCategoriesRepository {
  final ServiceCategoriesRemoteDataSource remoteDataSource;

  ServiceCategoriesRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<ServiceCategory>>> getCategories() async {
    try {
      // Récupérer directement depuis l'API
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } on SocketException {
      return Left(Failure.server(message: 'Pas de connexion internet'));
    } catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ServiceCategory>> getCategoryById(String id) async {
    try {
      final categories = await getCategories();
      return categories.fold(
        (failure) => Left(failure),
        (categoriesList) {
          try {
            final category = categoriesList.firstWhere((cat) => cat.id == id);
            return Right(category);
          } catch (e) {
            return Left(Failure.server(message: 'Catégorie non trouvée'));
          }
        },
      );
    } catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }
}
