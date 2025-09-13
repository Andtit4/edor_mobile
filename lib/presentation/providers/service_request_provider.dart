import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/service_request.dart';

class ServiceRequestState {
  final List<ServiceRequest> requests;
  final bool isLoading;
  final String? error;

  ServiceRequestState({
    this.requests = const [],
    this.isLoading = false,
    this.error,
  });

  ServiceRequestState copyWith({
    List<ServiceRequest>? requests,
    bool? isLoading,
    String? error,
  }) {
    return ServiceRequestState(
      requests: requests ?? this.requests,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ServiceRequestNotifier extends StateNotifier<ServiceRequestState> {
  ServiceRequestNotifier() : super(ServiceRequestState());

  Future<void> loadRequests() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Mock data - à remplacer par un vrai service
      final mockRequests = [
        ServiceRequest(
          id: 'req_1',
          title: 'Réparation de robinet qui fuit',
          description: 'J\'ai un robinet dans ma cuisine qui fuit constamment. J\'ai besoin d\'un plombier pour le réparer rapidement.',
          category: 'Plomberie',
          clientId: 'user_1',
          clientName: 'Marie Dubois',
          clientPhone: '+33 6 12 34 56 78',
          location: 'Paris 15ème',
          budget: 80.0,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          deadline: DateTime.now().add(const Duration(days: 5)),
          status: 'pending',
          notes: 'Urgent, eau qui coule partout',
        ),
        ServiceRequest(
          id: 'req_2',
          title: 'Installation de prises électriques',
          description: 'Besoin d\'installer 3 nouvelles prises électriques dans le salon. Câblage déjà préparé.',
          category: 'Électricité',
          clientId: 'user_2',
          clientName: 'Pierre Martin',
          clientPhone: '+33 6 98 76 54 32',
          location: 'Lyon 3ème',
          budget: 150.0,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          deadline: DateTime.now().add(const Duration(days: 10)),
          status: 'pending',
          notes: 'Prévoir certificat de conformité',
        ),
        ServiceRequest(
          id: 'req_3',
          title: 'Peinture d\'une chambre',
          description: 'Peinture complète d\'une chambre de 12m². Murs et plafond. Couleur choisie : blanc cassé.',
          category: 'Peinture',
          clientId: 'user_3',
          clientName: 'Sophie Leroy',
          clientPhone: '+33 6 55 44 33 22',
          location: 'Marseille 8ème',
          budget: 200.0,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          deadline: DateTime.now().add(const Duration(days: 15)),
          status: 'in_progress',
          assignedPrestataireId: 'prest_1',
          prestataireName: 'Jean Plombier',
          notes: 'Matériel fourni par le client',
        ),
      ];

      state = state.copyWith(
        requests: mockRequests,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> acceptRequest(String requestId) async {
    // Mock implementation
    final updatedRequests = state.requests.map((request) {
      if (request.id == requestId) {
        return request.copyWith(
          status: 'in_progress',
          assignedPrestataireId: 'current_prestataire',
          prestataireName: 'Vous',
        );
      }
      return request;
    }).toList();

    state = state.copyWith(requests: updatedRequests);
  }

  Future<void> completeRequest(String requestId) async {
    // Mock implementation
    final updatedRequests = state.requests.map((request) {
      if (request.id == requestId) {
        return request.copyWith(status: 'completed');
      }
      return request;
    }).toList();

    state = state.copyWith(requests: updatedRequests);
  }
}

final serviceRequestProvider = StateNotifierProvider<ServiceRequestNotifier, ServiceRequestState>((ref) {
  return ServiceRequestNotifier();
});
