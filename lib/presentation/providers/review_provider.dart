import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/review.dart';
import '../../data/datasources/remote/review_remote_data_source.dart';
import '../../core/network/network_info.dart';
import 'package:http/http.dart' as http;

// Data Source Provider
final reviewRemoteDataSourceProvider = Provider<ReviewRemoteDataSource>((ref) {
  return ReviewRemoteDataSourceImpl(
    client: http.Client(),
    networkInfo: ref.read(networkInfoProvider),
  );
});

// Review State
class ReviewState {
  final List<Review> reviews;
  final bool isLoading;
  final String? error;

  const ReviewState({
    this.reviews = const [],
    this.isLoading = false,
    this.error,
  });

  ReviewState copyWith({
    List<Review>? reviews,
    bool? isLoading,
    String? error,
  }) {
    return ReviewState(
      reviews: reviews ?? this.reviews,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Review Notifier
class ReviewNotifier extends StateNotifier<ReviewState> {
  final ReviewRemoteDataSource _remoteDataSource;

  ReviewNotifier(this._remoteDataSource) : super(const ReviewState());

  Future<void> loadPrestataireReviews({
    required String prestataireId,
    required String token,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final reviews = await _remoteDataSource.getPrestataireReviews(
        prestataireId: prestataireId,
        token: token,
      );

      state = state.copyWith(
        isLoading: false,
        reviews: reviews,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<Review?> createReview({
    required String serviceRequestId,
    required String prestataireId,
    required int rating,
    String? comment,
    required String token,
  }) async {
    try {
      final review = await _remoteDataSource.createReview(
        serviceRequestId: serviceRequestId,
        prestataireId: prestataireId,
        rating: rating,
        comment: comment,
        token: token,
      );

      final updatedReviews = [...state.reviews, review];
      state = state.copyWith(reviews: updatedReviews);

      return review;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  Future<double> getPrestataireAverageRating({
    required String prestataireId,
    required String token,
  }) async {
    try {
      return await _remoteDataSource.getPrestataireAverageRating(
        prestataireId: prestataireId,
        token: token,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return 0.0;
    }
  }

  Future<int> getPrestataireReviewsCount({
    required String prestataireId,
    required String token,
  }) async {
    try {
      return await _remoteDataSource.getPrestataireReviewsCount(
        prestataireId: prestataireId,
        token: token,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return 0;
    }
  }
}

// Review Provider
final reviewProvider = StateNotifierProvider<ReviewNotifier, ReviewState>(
  (ref) {
    final remoteDataSource = ref.watch(reviewRemoteDataSourceProvider);
    return ReviewNotifier(remoteDataSource);
  },
);
