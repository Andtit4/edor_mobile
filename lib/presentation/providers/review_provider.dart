import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote/review_remote_data_source.dart';
import '../../domain/entities/review.dart';
import '../../core/network/network_info.dart';

final reviewRemoteDataSourceProvider = Provider<ReviewRemoteDataSource>((ref) {
  return ReviewRemoteDataSourceImpl(
    client: ref.read(httpClientProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

// Provider pour les reviews d'un prestataire
final prestataireReviewsProvider = StateNotifierProvider.family<PrestataireReviewsNotifier, PrestataireReviewsState, String>((ref, prestataireId) {
  return PrestataireReviewsNotifier(ref.read(reviewRemoteDataSourceProvider), prestataireId);
});

class PrestataireReviewsState {
  final List<Review> reviews;
  final bool isLoading;
  final String? error;

  PrestataireReviewsState({
    this.reviews = const [],
    this.isLoading = false,
    this.error,
  });

  PrestataireReviewsState copyWith({
    List<Review>? reviews,
    bool? isLoading,
    String? error,
  }) {
    return PrestataireReviewsState(
      reviews: reviews ?? this.reviews,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class PrestataireReviewsNotifier extends StateNotifier<PrestataireReviewsState> {
  final ReviewRemoteDataSource _remoteDataSource;
  final String _prestataireId;

  PrestataireReviewsNotifier(this._remoteDataSource, this._prestataireId) : super(PrestataireReviewsState()) {
    loadReviews();
  }

  Future<void> loadReviews() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final reviews = await _remoteDataSource.getReviewsByPrestataire(_prestataireId);
      print('DEBUG: Reviews reçues dans le provider: ${reviews.length} reviews');
      for (var review in reviews) {
        print('DEBUG: Provider Review - clientName: ${review.clientName}, comment: ${review.comment}, rating: ${review.rating}');
      }
      state = state.copyWith(
        reviews: reviews,
        isLoading: false,
      );
    } catch (e) {
      print('DEBUG: Erreur dans le provider: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}