// lib/presentation/providers/ai_matching_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/ai_match.dart';
import '../../domain/repositories/ai_matching_repository.dart';
import '../../domain/usecases/generate_ai_matches.dart';
import '../../domain/usecases/get_ai_matches_for_request.dart';
import '../../data/repositories_impl/ai_matching_repository_impl.dart';
import '../../data/datasources/remote/ai_matching_remote_data_source.dart';
import '../../core/network/network_info.dart';
import 'package:http/http.dart' as http;

part 'ai_matching_provider.freezed.dart';

// Providers pour les dépendances
final aiMatchingRemoteDataSourceProvider = Provider<AIMatchingRemoteDataSource>((ref) {
  return AIMatchingRemoteDataSourceImpl(
    client: http.Client(),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final aiMatchingRepositoryProvider = Provider<AIMatchingRepository>((ref) {
  return AIMatchingRepositoryImpl(
    ref.watch(aiMatchingRemoteDataSourceProvider),
  );
});

final generateAIMatchesProvider = Provider<GenerateAIMatches>((ref) {
  return GenerateAIMatches(ref.watch(aiMatchingRepositoryProvider));
});

final getAIMatchesForRequestProvider = Provider<GetAIMatchesForRequest>((ref) {
  return GetAIMatchesForRequest(ref.watch(aiMatchingRepositoryProvider));
});

// État du matching IA
@freezed
class AIMatchingState with _$AIMatchingState {
  const factory AIMatchingState({
    @Default([]) List<AIMatch> matches,
    @Default(false) bool isLoading,
    @Default(false) bool isGenerating,
    String? error,
    String? currentServiceRequestId,
  }) = _AIMatchingState;
}

// Provider principal pour l'état du matching
final aiMatchingProvider = StateNotifierProvider<AIMatchingNotifier, AIMatchingState>((ref) {
  return AIMatchingNotifier(
    ref.watch(generateAIMatchesProvider),
    ref.watch(getAIMatchesForRequestProvider),
  );
});

class AIMatchingNotifier extends StateNotifier<AIMatchingState> {
  final GenerateAIMatches _generateAIMatches;
  final GetAIMatchesForRequest _getAIMatchesForRequest;

  AIMatchingNotifier(this._generateAIMatches, this._getAIMatchesForRequest)
      : super(const AIMatchingState());

  /// Génère de nouveaux matches IA pour une demande de service
  Future<void> generateMatches({
    required String serviceRequestId,
    int? maxResults,
    double? minScore,
    double? maxDistance,
    List<String>? preferredSkills,
    String? sortBy,
    required String token,
  }) async {
    print('🔍 AI Matching Provider - generateMatches called');
    print('🔍 ServiceRequestId: $serviceRequestId');
    print('🔍 Token length: ${token.length}');
    
    state = state.copyWith(
      isGenerating: true,
      error: null,
      currentServiceRequestId: serviceRequestId,
    );

    print('🔍 Calling _generateAIMatches use case...');
    final result = await _generateAIMatches(
      serviceRequestId: serviceRequestId,
      maxResults: maxResults,
      minScore: minScore,
      maxDistance: maxDistance,
      preferredSkills: preferredSkills,
      sortBy: sortBy,
      token: token,
    );

    print('🔍 Use case result received');
    result.fold(
      (failure) {
        print('❌ Failure: ${failure.message}');
        state = state.copyWith(
          isGenerating: false,
          error: failure.message,
        );
      },
      (matches) {
        print('✅ Success: ${matches.length} matches generated');
        state = state.copyWith(
          matches: matches,
          isGenerating: false,
          error: null,
        );
      },
    );
  }

  /// Récupère les matches existants pour une demande
  Future<void> getMatchesForRequest({
    required String serviceRequestId,
    required String token,
  }) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      currentServiceRequestId: serviceRequestId,
    );

    final result = await _getAIMatchesForRequest(
      serviceRequestId: serviceRequestId,
      token: token,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (matches) => state = state.copyWith(
        matches: matches,
        isLoading: false,
        error: null,
      ),
    );
  }

  /// Filtre les matches par score minimum
  void filterByMinScore(double minScore) {
    final filteredMatches = state.matches
        .where((match) => match.compatibilityScore >= minScore)
        .toList();
    
    state = state.copyWith(matches: filteredMatches);
  }

  /// Trie les matches par critère
  void sortMatches(String sortBy) {
    List<AIMatch> sortedMatches = List.from(state.matches);
    
    switch (sortBy) {
      case 'compatibility':
        sortedMatches.sort((a, b) => b.compatibilityScore.compareTo(a.compatibilityScore));
        break;
      case 'distance':
        sortedMatches.sort((a, b) {
          final distanceA = a.distance ?? double.infinity;
          final distanceB = b.distance ?? double.infinity;
          return distanceA.compareTo(distanceB);
        });
        break;
      case 'rating':
        sortedMatches.sort((a, b) {
          final ratingA = a.prestataire?.rating ?? 0.0;
          final ratingB = b.prestataire?.rating ?? 0.0;
          return ratingB.compareTo(ratingA);
        });
        break;
      case 'price':
        sortedMatches.sort((a, b) {
          final priceA = a.estimatedPrice ?? double.infinity;
          final priceB = b.estimatedPrice ?? double.infinity;
          return priceA.compareTo(priceB);
        });
        break;
    }
    
    state = state.copyWith(matches: sortedMatches);
  }

  /// Efface l'état actuel
  void clearState() {
    state = const AIMatchingState();
  }

  /// Efface les erreurs
  void clearError() {
    state = state.copyWith(error: null);
  }
}
