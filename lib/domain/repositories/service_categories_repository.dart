import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/service_category.dart';

abstract class ServiceCategoriesRepository {
  Future<Either<Failure, List<ServiceCategory>>> getCategories();
  Future<Either<Failure, ServiceCategory>> getCategoryById(String id);
}
