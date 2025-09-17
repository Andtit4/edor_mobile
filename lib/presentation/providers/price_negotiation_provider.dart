// lib/presentation/providers/price_negotiation_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/price_negotiation.dart';
import '../../data/datasources/remote/price_negotiation_remote_data_source.dart';
import '../../core/network/network_info.dart';
import 'package:http/http.dart' as http;

// Data Source Provider
final priceNegotiationRemoteDataSourceProvider = Provider<PriceNegotiationRemoteDataSource>((ref) {
  return PriceNegotiationRemoteDataSourceImpl(
    client: http.Client(),
    networkInfo: ref.read(networkInfoProvider),
  );
});

// Price Negotiation State
class PriceNegotiationState {
  final List<PriceNegotiation> negotiations;
  final bool isLoading;
  final String? error;

  const PriceNegotiationState({
    this.negotiations = const [],
    this.isLoading = false,
    this.error,
  });

  PriceNegotiationState copyWith({
    List<PriceNegotiation>? negotiations,
    bool? isLoading,
    String? error,
  }) {
    return PriceNegotiationState(
      negotiations: negotiations ?? this.negotiations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Price Negotiation Notifier
class PriceNegotiationNotifier extends StateNotifier<PriceNegotiationState> {
  final PriceNegotiationRemoteDataSource _remoteDataSource;

  PriceNegotiationNotifier(this._remoteDataSource) : super(const PriceNegotiationState());

  Future<void> loadNegotiationsByServiceRequest({
    required String serviceRequestId,
    required String token,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final negotiations = await _remoteDataSource.getNegotiationsByServiceRequest(
        serviceRequestId: serviceRequestId,
        token: token,
      );
      
      state = state.copyWith(
        isLoading: false,
        negotiations: negotiations,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<PriceNegotiation?> createNegotiation({
    required String serviceRequestId,
    required double proposedPrice,
    String? message,
    bool? isFromPrestataire,
    String? parentNegotiationId,
    required String token,
  }) async {
    try {
      final negotiation = await _remoteDataSource.createNegotiation(
        serviceRequestId: serviceRequestId,
        proposedPrice: proposedPrice,
        message: message,
        isFromPrestataire: isFromPrestataire,
        parentNegotiationId: parentNegotiationId,
        token: token,
      );
      
      // Ajouter la négociation à la liste
      final updatedNegotiations = [...state.negotiations, negotiation];
      state = state.copyWith(negotiations: updatedNegotiations);
      
      return negotiation;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  Future<bool> updateNegotiationStatus({
    required String id,
    required String status,
    required String token,
  }) async {
    try {
      final updatedNegotiation = await _remoteDataSource.updateNegotiationStatus(
        id: id,
        status: status,
        token: token,
      );
      
      // Mettre à jour la négociation dans la liste
      final updatedNegotiations = state.negotiations.map((negotiation) {
        if (negotiation.id == id) {
          return updatedNegotiation;
        }
        return negotiation;
      }).toList();
      
      state = state.copyWith(negotiations: updatedNegotiations);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> deleteNegotiation({
    required String id,
    required String token,
  }) async {
    try {
      await _remoteDataSource.deleteNegotiation(id: id, token: token);
      
      // Supprimer la négociation de la liste
      final updatedNegotiations = state.negotiations.where((negotiation) => negotiation.id != id).toList();
      state = state.copyWith(negotiations: updatedNegotiations);
      
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Price Negotiation Provider
final priceNegotiationProvider = StateNotifierProvider<PriceNegotiationNotifier, PriceNegotiationState>(
  (ref) {
    final remoteDataSource = ref.watch(priceNegotiationRemoteDataSourceProvider);
    return PriceNegotiationNotifier(remoteDataSource);
  },
);
