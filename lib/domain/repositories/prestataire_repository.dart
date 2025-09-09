import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../entities/prestataire.dart';
import '../entities/category.dart';

abstract class PrestataireRepository {
  Future<Either<Failure, List<Prestataire>>> getAllPrestataires();

  Future<Either<Failure, List<Prestataire>>> getPrestatairesByCategory(
    String categoryId,
  );

  Future<Either<Failure, List<Prestataire>>> searchPrestataires(String query);

  Future<Either<Failure, Prestataire>> getPrestataireById(String id);

  Future<Either<Failure, List<Category>>> getCategories();

  Future<Either<Failure, List<Prestataire>>> getFavoritePrestataires();

  Future<Either<Failure, void>> toggleFavorite(String prestataireId);
}
