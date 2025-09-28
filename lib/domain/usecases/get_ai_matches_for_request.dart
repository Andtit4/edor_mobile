// lib/domain/usecases/get_ai_matches_for_request.dart
import 'package:fpdart/fpdart.dart';
import '../entities/ai_match.dart';
import '../repositories/ai_matching_repository.dart';
import '../../core/errors/failures.dart';

class GetAIMatchesForRequest {
  final AIMatchingRepository _repository;

  GetAIMatchesForRequest(this._repository);

  Future<Either<Failure, List<AIMatch>>> call({
    required String serviceRequestId,
    required String token,
  }) async {
    return await _repository.getMatchesForRequest(
      serviceRequestId: serviceRequestId,
      token: token,
    );
  }
}
