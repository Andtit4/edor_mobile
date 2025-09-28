// lib/data/repositories_impl/ai_matching_repository_impl.dart
import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/ai_match.dart';
import '../../domain/repositories/ai_matching_repository.dart';
import '../datasources/remote/ai_matching_remote_data_source.dart';

class AIMatchingRepositoryImpl implements AIMatchingRepository {
  final AIMatchingRemoteDataSource _remoteDataSource;

  AIMatchingRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<AIMatch>>> generateMatches({
    required String serviceRequestId,
    int? maxResults,
    double? minScore,
    double? maxDistance,
    List<String>? preferredSkills,
    String? sortBy,
    required String token,
  }) async {
    try {
      final matches = await _remoteDataSource.generateMatches(
        serviceRequestId: serviceRequestId,
        maxResults: maxResults,
        minScore: minScore,
        maxDistance: maxDistance,
        preferredSkills: preferredSkills,
        sortBy: sortBy,
        token: token,
      );
      return Right(matches);
    } on ServerException catch (e) {
      return Left(Failure.server(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AIMatch>>> getMatchesForRequest({
    required String serviceRequestId,
    required String token,
  }) async {
    try {
      final matches = await _remoteDataSource.getMatchesForRequest(
        serviceRequestId: serviceRequestId,
        token: token,
      );
      return Right(matches);
    } on ServerException catch (e) {
      return Left(Failure.server(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}
