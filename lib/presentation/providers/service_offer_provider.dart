// lib/presentation/providers/service_offer_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote/service_offer_remote_data_source.dart';
import '../../domain/entities/service_offer.dart';
import '../../core/network/network_info.dart';
import '../../core/errors/failures.dart';

final serviceOfferRemoteDataSourceProvider = Provider<ServiceOfferRemoteDataSource>((ref) {
  return ServiceOfferRemoteDataSourceImpl(
    client: ref.read(httpClientProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

final serviceOfferProvider = StateNotifierProvider<ServiceOfferNotifier, ServiceOfferState>((ref) {
  return ServiceOfferNotifier(ref.read(serviceOfferRemoteDataSourceProvider));
});

class ServiceOfferState {
  final List<ServiceOffer> offers; // Changé de serviceOffers à offers
  final bool isLoading;
  final String? error;

  ServiceOfferState({
    this.offers = const [],
    this.isLoading = false,
    this.error,
  });

  ServiceOfferState copyWith({
    List<ServiceOffer>? offers,
    bool? isLoading,
    String? error,
  }) {
    return ServiceOfferState(
      offers: offers ?? this.offers,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ServiceOfferNotifier extends StateNotifier<ServiceOfferState> {
  final ServiceOfferRemoteDataSource _remoteDataSource;

  ServiceOfferNotifier(this._remoteDataSource) : super(ServiceOfferState());

  Future<void> loadOffers() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final serviceOffers = await _remoteDataSource.getAllServiceOffers();
      state = state.copyWith(
        offers: serviceOffers,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Ajouter cette méthode
  Future<void> loadMyOffers(String token) async {
    print('=== LOAD MY OFFERS ===');
    print('Token: ${token.substring(0, 20)}...');
    
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final serviceOffers = await _remoteDataSource.getMyServiceOffers(token);
      print('Received ${serviceOffers.length} offers');
      for (var offer in serviceOffers) {
        print('Offer: ${offer.title} - ${offer.status}');
      }
      
      state = state.copyWith(
        offers: serviceOffers,
        isLoading: false,
      );
    } catch (e) {
      print('Error loading my offers: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadOffersByCategory(String category) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final serviceOffers = await _remoteDataSource.getServiceOffersByCategory(category);
      state = state.copyWith(
        offers: serviceOffers,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<ServiceOffer?> getOfferById(String id) async {
    try {
      return await _remoteDataSource.getServiceOfferById(id);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  Future<void> contactPrestataire(String offerId) async {
    // Implémentation pour contacter le prestataire
    // Pour l'instant, on peut juste afficher un message
    print('Contacting prestataire for offer: $offerId');
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}