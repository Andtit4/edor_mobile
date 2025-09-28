// lib/domain/usecases/generate_ai_matches.dart
import 'package:fpdart/fpdart.dart';
import '../entities/ai_match.dart';
import '../repositories/ai_matching_repository.dart';
import '../../core/errors/failures.dart';

class GenerateAIMatches {
  final AIMatchingRepository _repository;

  GenerateAIMatches(this._repository);

  Future<Either<Failure, List<AIMatch>>> call({
    required String serviceRequestId,
    int? maxResults,
    double? minScore,
    double? maxDistance,
    List<String>? preferredSkills,
    String? sortBy,
    required String token,
  }) async {
    return await _repository.generateMatches(
      serviceRequestId: serviceRequestId,
      maxResults: maxResults,
      minScore: minScore,
      maxDistance: maxDistance,
      preferredSkills: preferredSkills,
      sortBy: sortBy,
      token: token,
    );
  }
}
