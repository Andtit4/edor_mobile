// lib/presentation/providers/prestataire_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote/prestataire_remote_data_source.dart';
import '../../domain/entities/prestataire.dart';
import '../../core/network/network_info.dart';

final prestataireRemoteDataSourceProvider = Provider<PrestataireRemoteDataSource>((ref) {
  return PrestataireRemoteDataSourceImpl(
    client: ref.read(httpClientProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

// Provider pour un prestataire spécifique
final prestataireProvider = StateNotifierProvider.family<PrestataireNotifier, PrestataireState, String>((ref, prestataireId) {
  return PrestataireNotifier(ref.read(prestataireRemoteDataSourceProvider), prestataireId);
});

// Provider pour la liste des prestataires
final prestatairesProvider = StateNotifierProvider<PrestatairesNotifier, PrestatairesState>((ref) {
  return PrestatairesNotifier(ref.read(prestataireRemoteDataSourceProvider));
});

class PrestataireState {
  final Prestataire? prestataire;
  final bool isLoading;
  final String? error;

  PrestataireState({
    this.prestataire,
    this.isLoading = false,
    this.error,
  });

  PrestataireState copyWith({
    Prestataire? prestataire,
    bool? isLoading,
    String? error,
  }) {
    return PrestataireState(
      prestataire: prestataire ?? this.prestataire,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class PrestatairesState {
  final List<Prestataire> prestataires;
  final bool isLoading;
  final String? error;

  PrestatairesState({
    this.prestataires = const [],
    this.isLoading = false,
    this.error,
  });

  PrestatairesState copyWith({
    List<Prestataire>? prestataires,
    bool? isLoading,
    String? error,
  }) {
    return PrestatairesState(
      prestataires: prestataires ?? this.prestataires,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class PrestataireNotifier extends StateNotifier<PrestataireState> {
  final PrestataireRemoteDataSource _remoteDataSource;
  final String _prestataireId;

  PrestataireNotifier(this._remoteDataSource, this._prestataireId) : super(PrestataireState()) {
    loadPrestataire();
  }

  Future<void> loadPrestataire() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final prestataire = await _remoteDataSource.getPrestataireById(_prestataireId);
      state = state.copyWith(
        prestataire: prestataire,
        isLoading: false,
      );
    } catch (e) {
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

class PrestatairesNotifier extends StateNotifier<PrestatairesState> {
  final PrestataireRemoteDataSource _remoteDataSource;

  PrestatairesNotifier(this._remoteDataSource) : super(PrestatairesState());

  Future<void> loadPrestataires() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      print('[DEBUG] Chargement des prestataires...');
      final prestataires = await _remoteDataSource.getAllPrestataires();
      print('[DEBUG] Prestataires chargés: ${prestataires.length}');
      state = state.copyWith(
        prestataires: prestataires,
        isLoading: false,
      );
    } catch (e) {
      print('[ERROR] Erreur lors du chargement des prestataires: $e');
      print('[ERROR] Stack trace: ${StackTrace.current}');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadPrestatairesByCategory(String category) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final prestataires = await _remoteDataSource.getPrestatairesByCategory(category);
      state = state.copyWith(
        prestataires: prestataires,
        isLoading: false,
      );
    } catch (e) {
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