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
  final List<ServiceRequest> requests;
  final bool isLoading;
  final String? error;
  final bool isCreating;

  ServiceRequestState({
    this.requests = const [],
    this.isLoading = false,
    this.error,
    this.isCreating = false,
  });

  ServiceRequestState copyWith({
    List<ServiceRequest>? requests,
    bool? isLoading,
    String? error,
    bool? isCreating,
  }) {
    return ServiceRequestState(
      requests: requests ?? this.requests,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isCreating: isCreating ?? this.isCreating,
    );
  }
}

class ServiceRequestNotifier extends StateNotifier<ServiceRequestState> {
  final ServiceRequestRemoteDataSource _remoteDataSource;

  ServiceRequestNotifier(this._remoteDataSource) : super(ServiceRequestState());

  Future<void> loadRequests() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final serviceRequests = await _remoteDataSource.getAllServiceRequests();
      state = state.copyWith(
        requests: serviceRequests,
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
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final serviceRequests = await _remoteDataSource.getMyServiceRequests(token);
      state = state.copyWith(
        requests: serviceRequests,
        isLoading: false,
      );
    } catch (e) {
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
        requests: serviceRequests,
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
        budget,
        deadline,
        notes,
        token,
      );
      
      // Ajouter la nouvelle demande à la liste
      state = state.copyWith(
        requests: [newRequest, ...state.requests],
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
      
      // Mettre à jour la demande dans la liste
      final updatedRequests = state.requests.map((request) {
        return request.id == id ? updatedRequest : request;
      }).toList();
      
      state = state.copyWith(requests: updatedRequests);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteRequest(String id, String token) async {
    try {
      await _remoteDataSource.deleteServiceRequest(id, token);
      
      // Supprimer la demande de la liste
      final updatedRequests = state.requests.where((request) => request.id != id).toList();
      state = state.copyWith(requests: updatedRequests);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> acceptRequest(String requestId, String prestataireId, String prestataireName, String token) async {
    try {
      final updatedRequest = await _remoteDataSource.assignPrestataire(requestId, prestataireId, prestataireName, token);
      
      // Mettre à jour la demande dans la liste
      final updatedRequests = state.requests.map((request) {
        return request.id == requestId ? updatedRequest : request;
      }).toList();
      
      state = state.copyWith(requests: updatedRequests);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> completeRequest(String requestId, String token) async {
    try {
      await _remoteDataSource.updateServiceRequest(requestId, {'status': 'completed'}, token);
      
      // Mettre à jour la demande dans la liste
      final updatedRequests = state.requests.map((request) {
        if (request.id == requestId) {
          return request.copyWith(status: 'completed');
        }
        return request;
      }).toList();
      
      state = state.copyWith(requests: updatedRequests);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}