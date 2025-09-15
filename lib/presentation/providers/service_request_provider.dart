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
  final List<ServiceRequest> requests; // Changé de serviceRequests à requests
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
      error: error,
    );
  }
}

class ServiceRequestNotifier extends StateNotifier<ServiceRequestState> {
  final ServiceRequestRemoteDataSource _remoteDataSource;

  ServiceRequestNotifier(this._remoteDataSource) : super(ServiceRequestState());

  Future<void> loadRequests() async { // Changé de loadAllServiceRequests à loadRequests
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

  Future<void> acceptRequest(String requestId) async {
    // Implémentation pour accepter une demande
    print('Accepting request: $requestId');
  }

  Future<void> completeRequest(String requestId) async {
    // Implémentation pour marquer une demande comme terminée
    print('Completing request: $requestId');
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}