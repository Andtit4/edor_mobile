import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/prestataire.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/prestataire_repository.dart';
import '../../data/repositories_impl/prestataire_repository_impl.dart';
import 'auth_provider.dart';

// Repository Provider
final prestataireRepositoryProvider = Provider<PrestataireRepository>((ref) {
  final localDataSource = ref.watch(localDataSourceProvider);
  return PrestataireRepositoryImpl(localDataSource: localDataSource);
});

// Prestataires State
class PrestatairesState {
  final List<Prestataire> prestataires;
  final List<Prestataire> filteredPrestataires;
  final List<Category> categories;
  final List<Prestataire> favorites;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final String? selectedCategoryId;

  const PrestatairesState({
    this.prestataires = const [],
    this.filteredPrestataires = const [],
    this.categories = const [],
    this.favorites = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.selectedCategoryId,
  });

  PrestatairesState copyWith({
    List<Prestataire>? prestataires,
    List<Prestataire>? filteredPrestataires,
    List<Category>? categories,
    List<Prestataire>? favorites,
    bool? isLoading,
    String? error,
    String? searchQuery,
    String? selectedCategoryId,
  }) {
    return PrestatairesState(
      prestataires: prestataires ?? this.prestataires,
      filteredPrestataires: filteredPrestataires ?? this.filteredPrestataires,
      categories: categories ?? this.categories,
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }
}

// Prestataires Notifier
class PrestatairesNotifier extends StateNotifier<PrestatairesState> {
  final PrestataireRepository _repository;

  PrestatairesNotifier(this._repository) : super(const PrestatairesState()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    state = state.copyWith(isLoading: true);

    // Charger prestataires et catégories en parallèle
    final prestataireResult = await _repository.getAllPrestataires();
    final categoriesResult = await _repository.getCategories();
    final favoritesResult = await _repository.getFavoritePrestataires();

    prestataireResult.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (prestataires) {
        categoriesResult.fold(
          (failure) =>
              state = state.copyWith(isLoading: false, error: failure.message),
          (categories) {
            favoritesResult.fold(
              (failure) =>
                  state = state.copyWith(
                    isLoading: false,
                    prestataires: prestataires,
                    filteredPrestataires: prestataires,
                    categories: categories,
                    error: failure.message,
                  ),
              (favorites) =>
                  state = state.copyWith(
                    isLoading: false,
                    prestataires: prestataires,
                    filteredPrestataires: prestataires,
                    categories: categories,
                    favorites: favorites,
                  ),
            );
          },
        );
      },
    );
  }

  void searchPrestataires(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  void filterByCategory(String? categoryId) {
    state = state.copyWith(selectedCategoryId: categoryId);
    _applyFilters();
  }

  void _applyFilters() {
    List<Prestataire> filtered = state.prestataires;

    // Filtrer par catégorie
    if (state.selectedCategoryId != null &&
        state.selectedCategoryId!.isNotEmpty) {
      final category = state.categories.firstWhere(
        (c) => c.id == state.selectedCategoryId,
        orElse: () => state.categories.first,
      );
      filtered =
          filtered
              .where(
                (p) => p.category.toLowerCase() == category.name.toLowerCase(),
              )
              .toList();
    }

    // Filtrer par recherche
    if (state.searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (p) =>
                    p.name.toLowerCase().contains(
                      state.searchQuery.toLowerCase(),
                    ) ||
                    p.category.toLowerCase().contains(
                      state.searchQuery.toLowerCase(),
                    ) ||
                    p.skills.any(
                      (skill) => skill.toLowerCase().contains(
                        state.searchQuery.toLowerCase(),
                      ),
                    ),
              )
              .toList();
    }

    state = state.copyWith(filteredPrestataires: filtered);
  }

  Future<void> toggleFavorite(String prestataireId) async {
    final result = await _repository.toggleFavorite(prestataireId);
    result.fold((failure) => state = state.copyWith(error: failure.message), (
      _,
    ) async {
      // Recharger les favoris
      final favoritesResult = await _repository.getFavoritePrestataires();
      favoritesResult.fold(
        (failure) => state = state.copyWith(error: failure.message),
        (favorites) => state = state.copyWith(favorites: favorites),
      );
    });
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<void> refresh() async {
    await _loadInitialData();
  }
}

// Prestataires Provider
final prestatairesProvider =
    StateNotifierProvider<PrestatairesNotifier, PrestatairesState>((ref) {
      final repository = ref.watch(prestataireRepositoryProvider);
      return PrestatairesNotifier(repository);
    });

// Individual Prestataire Provider
final prestataireProvider = FutureProvider.family<Prestataire?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(prestataireRepositoryProvider);
  final result = await repository.getPrestataireById(id);
  return result.fold((failure) => null, (prestataire) => prestataire);
});

// Convenient providers
final categoriesProvider = Provider<List<Category>>((ref) {
  return ref.watch(prestatairesProvider).categories;
});

final favoritesProvider = Provider<List<Prestataire>>((ref) {
  return ref.watch(prestatairesProvider).favorites;
});

final filteredPrestatairesProvider = Provider<List<Prestataire>>((ref) {
  return ref.watch(prestatairesProvider).filteredPrestataires;
});
