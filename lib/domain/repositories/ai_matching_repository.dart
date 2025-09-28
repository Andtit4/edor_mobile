// lib/domain/repositories/ai_matching_repository.dart
import 'package:fpdart/fpdart.dart';
import '../entities/ai_match.dart';
import '../../core/errors/failures.dart';

abstract class AIMatchingRepository {
  Future<Either<Failure, List<AIMatch>>> generateMatches({
    required String serviceRequestId,
    int? maxResults,
    double? minScore,
    double? maxDistance,
    List<String>? preferredSkills,
    String? sortBy,
    required String token,
  });
  
  Future<Either<Failure, List<AIMatch>>> getMatchesForRequest({
    required String serviceRequestId,
    required String token,
  });
}
