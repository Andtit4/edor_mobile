import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/service_category.dart';
import '../../domain/repositories/service_categories_repository.dart';
import '../../data/repositories/service_categories_repository.dart';

// État des catégories de services
class ServiceCategoriesState {
  final List<ServiceCategory> categories;
  final bool isLoading;
  final String? error;
  final ServiceCategory? selectedCategory;

  const ServiceCategoriesState({
    this.categories = const [],
    this.isLoading = false,
    this.error,
    this.selectedCategory,
  });

  ServiceCategoriesState copyWith({
    List<ServiceCategory>? categories,
    bool? isLoading,
    String? error,
    ServiceCategory? selectedCategory,
  }) {
    return ServiceCategoriesState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

// Provider pour l'état des catégories
final serviceCategoriesProvider = StateNotifierProvider<ServiceCategoriesNotifier, ServiceCategoriesState>((ref) {
  return ServiceCategoriesNotifier(ref.read(serviceCategoriesRepositoryProvider));
});

// Notifier pour gérer les catégories
class ServiceCategoriesNotifier extends StateNotifier<ServiceCategoriesState> {
  final ServiceCategoriesRepository _repository;

  ServiceCategoriesNotifier(this._repository) : super(const ServiceCategoriesState()) {
    loadCategories();
  }

  // Charger toutes les catégories
  Future<void> loadCategories() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final result = await _repository.getCategories();
      result.fold(
        (failure) {
          state = state.copyWith(
            isLoading: false,
            error: failure.message,
          );
        },
        (categories) {
          state = state.copyWith(
            isLoading: false,
            categories: categories,
            error: null,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur inattendue: $e',
      );
    }
  }

  // Sélectionner une catégorie
  void selectCategory(ServiceCategory category) {
    state = state.copyWith(selectedCategory: category);
  }

  // Désélectionner la catégorie
  void clearSelection() {
    state = state.copyWith(selectedCategory: null);
  }

  // Obtenir une catégorie par ID
  ServiceCategory? getCategoryById(String id) {
    try {
      return state.categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  // Obtenir les catégories actives
  List<ServiceCategory> get activeCategories {
    return state.categories.where((category) => category.isActive).toList();
  }

  // Rechercher des catégories
  List<ServiceCategory> searchCategories(String query) {
    if (query.isEmpty) return state.categories;
    
    return state.categories.where((category) {
      return category.name.toLowerCase().contains(query.toLowerCase()) ||
             category.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
