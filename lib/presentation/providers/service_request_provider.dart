// lib/presentation/providers/service_request_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote/service_request_remote_data_source.dart';
import '../../domain/entities/service_request.dart';
import '../../core/network/network_info.dart';
import '../../core/errors/failures.dart';

final serviceRequestRemoteDataSourceProvider = Provider<ServiceRequestRemoteDataSource>((ref) {
  return ServiceRequestRemoteDataSourceImpl(
    client: ref.read(httpClientProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

final serviceRequestProvider = StateNotifierProvider<ServiceRequestNotifier, ServiceRequestState>((ref) {
  return ServiceRequestNotifier(ref.read(serviceRequestRemoteDataSourceProvider));
});

class ServiceRequestState {
  final List<ServiceRequest> allRequests; // Toutes les demandes
  final List<ServiceRequest> myRequests; // Mes demandes
  final List<ServiceRequest> assignedRequests; // Demandes assignées (pour prestataires)
  final bool isLoading;
  final String? error;
  final bool isCreating;

  ServiceRequestState({
    this.allRequests = const [],
    this.myRequests = const [],
    this.assignedRequests = const [],
    this.isLoading = false,
    this.error,
    this.isCreating = false,
  });

  ServiceRequestState copyWith({
    List<ServiceRequest>? allRequests,
    List<ServiceRequest>? myRequests,
    List<ServiceRequest>? assignedRequests,
    bool? isLoading,
    String? error,
    bool? isCreating,
  }) {
    return ServiceRequestState(
      allRequests: allRequests ?? this.allRequests,
      myRequests: myRequests ?? this.myRequests,
      assignedRequests: assignedRequests ?? this.assignedRequests,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isCreating: isCreating ?? this.isCreating,
    );
  }
}

class ServiceRequestNotifier extends StateNotifier<ServiceRequestState> {
  final ServiceRequestRemoteDataSource _remoteDataSource;

  ServiceRequestNotifier(this._remoteDataSource) : super(ServiceRequestState());

  Future<void> loadAllRequests() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final serviceRequests = await _remoteDataSource.getAllServiceRequests();
      state = state.copyWith(
        allRequests: serviceRequests,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMyRequests(String token) async {
    print('=== LOAD MY REQUESTS ===');
    print('Token: ${token.substring(0, 20)}...');
    
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final serviceRequests = await _remoteDataSource.getMyServiceRequests(token);
      print('Received ${serviceRequests.length} requests');
      for (var request in serviceRequests) {
        print('Request: ${request.title} - ${request.status}');
      }
      
      state = state.copyWith(
        myRequests: serviceRequests,
        isLoading: false,
      );
    } catch (e) {
      print('Error loading my requests: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadAssignedRequests(String token) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final serviceRequests = await _remoteDataSource.getAssignedServiceRequests(token);
      state = state.copyWith(
        assignedRequests: serviceRequests,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<ServiceRequest?> createRequest({
    required String title,
    required String description,
    required String category,
    required String clientName,
    required String clientPhone,
    required String location,
    double? latitude,
    double? longitude,
    required double budget,
    required DateTime deadline,
    String? notes,
    required String token,
  }) async {
    state = state.copyWith(isCreating: true, error: null);
    
    try {
      final newRequest = await _remoteDataSource.createServiceRequest(
        title,
        description,
        category,
        clientName,
        clientPhone,
        location,
        latitude,
        longitude,
        budget,
        deadline,
        notes,
        token,
      );
      
      // Ajouter la nouvelle demande à la liste des demandes de l'utilisateur
      state = state.copyWith(
        myRequests: [newRequest, ...state.myRequests], // ✅ Utiliser myRequests
        isCreating: false,
      );
      
      return newRequest;
    } catch (e) {
      state = state.copyWith(
        isCreating: false,
        error: e.toString(),
      );
      return null;
    }
  }

  Future<void> updateRequest(String id, Map<String, dynamic> data, String token) async {
    try {
      final updatedRequest = await _remoteDataSource.updateServiceRequest(id, data, token);
      
      // Mettre à jour la demande dans toutes les listes
      final updatedAllRequests = state.allRequests.map((request) {
        return request.id == id ? updatedRequest : request;
      }).toList();
      
      final updatedMyRequests = state.myRequests.map((request) {
        return request.id == id ? updatedRequest : request;
      }).toList();
      
      final updatedAssignedRequests = state.assignedRequests.map((request) {
        return request.id == id ? updatedRequest : request;
      }).toList();
      
      state = state.copyWith(
        allRequests: updatedAllRequests,
        myRequests: updatedMyRequests,
        assignedRequests: updatedAssignedRequests,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateServiceRequest(String id, Map<String, dynamic> data, String token) async {
    return updateRequest(id, data, token);
  }

  Future<void> deleteRequest(String id, String token) async {
    try {
      await _remoteDataSource.deleteServiceRequest(id, token);
      
      // Supprimer la demande de toutes les listes
      final updatedAllRequests = state.allRequests.where((request) => request.id != id).toList();
      final updatedMyRequests = state.myRequests.where((request) => request.id != id).toList();
      final updatedAssignedRequests = state.assignedRequests.where((request) => request.id != id).toList();
      
      state = state.copyWith(
        allRequests: updatedAllRequests,
        myRequests: updatedMyRequests,
        assignedRequests: updatedAssignedRequests,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> acceptRequest(String id, String token) async {
    try {
      final updatedRequest = await _remoteDataSource.updateServiceRequest(
        id, 
        {'status': 'accepted'}, 
        token
      );
      
      // Mettre à jour la demande dans toutes les listes
      final updatedAllRequests = state.allRequests.map((request) {
        return request.id == id ? updatedRequest : request;
      }).toList();
      
      final updatedMyRequests = state.myRequests.map((request) {
        return request.id == id ? updatedRequest : request;
      }).toList();
      
      final updatedAssignedRequests = state.assignedRequests.map((request) {
        return request.id == id ? updatedRequest : request;
      }).toList();
      
      state = state.copyWith(
        allRequests: updatedAllRequests,
        myRequests: updatedMyRequests,
        assignedRequests: updatedAssignedRequests,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> completeRequest(String id, String token) async {
    try {
      final updatedRequest = await _remoteDataSource.updateServiceRequest(
        id, 
        {'status': 'completed'}, 
        token
      );
      
      // Mettre à jour la demande dans toutes les listes
      final updatedAllRequests = state.allRequests.map((request) {
        return request.id == id ? updatedRequest : request;
      }).toList();
      
      final updatedMyRequests = state.myRequests.map((request) {
        return request.id == id ? updatedRequest : request;
      }).toList();
      
      final updatedAssignedRequests = state.assignedRequests.map((request) {
        return request.id == id ? updatedRequest : request;
      }).toList();
      
      state = state.copyWith(
        allRequests: updatedAllRequests,
        myRequests: updatedMyRequests,
        assignedRequests: updatedAssignedRequests,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> assignPrestataire(String id, String prestataireId, String prestataireName, String token) async {
    try {
      final updatedRequest = await _remoteDataSource.assignPrestataire(id, prestataireId, prestataireName, token);
      
      // Mettre à jour la demande dans toutes les listes
      final updatedAllRequests = state.allRequests.map((request) {
        return request.id == id ? updatedRequest : request;
      }).toList();
      
      final updatedMyRequests = state.myRequests.map((request) {
        return request.id == id ? updatedRequest : request;
      }).toList();
      
      final updatedAssignedRequests = state.assignedRequests.map((request) {
        return request.id == id ? updatedRequest : request;
      }).toList();
      
      state = state.copyWith(
        allRequests: updatedAllRequests,
        myRequests: updatedMyRequests,
        assignedRequests: updatedAssignedRequests,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<Map<String, dynamic>?> completeServiceRequest({
    required String id,
    required DateTime completionDate,
    String? completionNotes,
    required int rating,
    String? reviewComment,
    required String token,
  }) async {
    try {
      final result = await _remoteDataSource.completeServiceRequest(
        id: id,
        completionDate: completionDate,
        completionNotes: completionNotes,
        rating: rating,
        reviewComment: reviewComment,
        token: token,
      );

      // Recharger les demandes pour avoir les données mises à jour
      await loadMyRequests(token);
      await loadAllRequests();

      return result;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}