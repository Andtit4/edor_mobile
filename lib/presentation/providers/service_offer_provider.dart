import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/service_offer.dart';

class ServiceOfferState {
  final List<ServiceOffer> offers;
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
      error: error ?? this.error,
    );
  }
}

class ServiceOfferNotifier extends StateNotifier<ServiceOfferState> {
  ServiceOfferNotifier() : super(ServiceOfferState());

  Future<void> loadOffers() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Mock data - à remplacer par un vrai service
      final mockOffers = [
        ServiceOffer(
          id: 'offer_1',
          title: 'Services de plomberie professionnels',
          description: 'Plombier expérimenté avec 10 ans d\'expérience. Réparations, installations, dépannages d\'urgence. Disponible 7j/7.',
          category: 'Plomberie',
          prestataireId: 'prest_1',
          prestataireName: 'Jean Plombier',
          prestatairePhone: '+33 6 11 22 33 44',
          location: 'Paris et région parisienne',
          price: 60.0,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          status: 'available',
          rating: 4.8,
          reviewCount: 127,
          experience: '10 ans d\'expérience',
          availability: '7j/7, 8h-20h',
        ),
        ServiceOffer(
          id: 'offer_2',
          title: 'Électricien qualifié - Tous travaux',
          description: 'Électricien qualifié pour tous types de travaux : installations, réparations, mises aux normes. Certifié et assuré.',
          category: 'Électricité',
          prestataireId: 'prest_2',
          prestataireName: 'Marc Électricien',
          prestatairePhone: '+33 6 22 33 44 55',
          location: 'Lyon et environs',
          price: 70.0,
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
          status: 'available',
          rating: 4.9,
          reviewCount: 89,
          experience: '15 ans d\'expérience',
          availability: 'Lun-Ven 8h-18h',
        ),
        ServiceOffer(
          id: 'offer_3',
          title: 'Peintre en bâtiment - Finitions soignées',
          description: 'Peintre professionnel spécialisé dans les finitions intérieures et extérieures. Travail soigné et respect des délais.',
          category: 'Peinture',
          prestataireId: 'prest_3',
          prestataireName: 'Paul Peintre',
          prestatairePhone: '+33 6 33 44 55 66',
          location: 'Marseille et région',
          price: 45.0,
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
          status: 'available',
          rating: 4.7,
          reviewCount: 156,
          experience: '8 ans d\'expérience',
          availability: 'Mar-Sam 9h-17h',
        ),
      ];

      state = state.copyWith(
        offers: mockOffers,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> contactPrestataire(String offerId) async {
    // Mock implementation - dans un vrai projet, vous feriez un appel API
    // Pour l'instant, on simule juste un succès
  }
}

final serviceOfferProvider = StateNotifierProvider<ServiceOfferNotifier, ServiceOfferState>((ref) {
  return ServiceOfferNotifier();
});