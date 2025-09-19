// lib/data/datasources/remote/service_request_remote_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/errors/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../../../core/config/app_config.dart';
import '../../../domain/entities/service_request.dart';
import '../../../data/models/service_request_model.dart'; // Ajouter cet import

abstract class ServiceRequestRemoteDataSource {
  Future<List<ServiceRequest>> getAllServiceRequests();
  Future<List<ServiceRequest>> getMyServiceRequests(String token);
  Future<List<ServiceRequest>> getAssignedServiceRequests(String token);
  Future<ServiceRequest> getServiceRequestById(String id);
  Future<ServiceRequest> createServiceRequest(
    String title,
    String description,
    String category,
    String clientName,
    String clientPhone,
    String location,
    double? latitude,
    double? longitude,
    double budget,
    DateTime deadline,
    String? notes,
    String token,
  );
  Future<ServiceRequest> updateServiceRequest(String id, Map<String, dynamic> data, String token);
  Future<void> deleteServiceRequest(String id, String token);
  Future<ServiceRequest> assignPrestataire(String id, String prestataireId, String prestataireName, String token);
  Future<Map<String, dynamic>> completeServiceRequest({
    required String id,
    required DateTime completionDate,
    String? completionNotes,
    required int rating,
    String? reviewComment,
    required String token,
  });
}

class ServiceRequestRemoteDataSourceImpl implements ServiceRequestRemoteDataSource {
  final http.Client client;
  final NetworkInfo networkInfo;

  ServiceRequestRemoteDataSourceImpl({
    required this.client,
    required this.networkInfo,
  });

  @override
  Future<List<ServiceRequest>> getAllServiceRequests() async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.get(
      Uri.parse('${AppConfig.apiBaseUrl}/service-requests'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ServiceRequestModel.fromJson(json).toEntity()).toList();
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  @override
  Future<List<ServiceRequest>> getMyServiceRequests(String token) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    print('=== API CALL: GET MY REQUESTS ===');
    print('URL: ${AppConfig.apiBaseUrl}/service-requests/my-requests');
    print('Token: ${token.substring(0, 20)}...');

    final response = await client.get(
      Uri.parse('${AppConfig.apiBaseUrl}/service-requests/my-requests'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('Parsed ${data.length} requests from API');
      return data.map((json) => ServiceRequestModel.fromJson(json).toEntity()).toList();
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  @override
  Future<List<ServiceRequest>> getAssignedServiceRequests(String token) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.get(
      Uri.parse('${AppConfig.apiBaseUrl}/service-requests/assigned-to-me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ServiceRequestModel.fromJson(json).toEntity()).toList();
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  @override
  Future<ServiceRequest> getServiceRequestById(String id) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.get(
      Uri.parse('${AppConfig.apiBaseUrl}/service-requests/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ServiceRequestModel.fromJson(data).toEntity();
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  @override
  Future<ServiceRequest> createServiceRequest(
    String title,
    String description,
    String category,
    String clientName,
    String clientPhone,
    String location,
    double? latitude,
    double? longitude,
    double budget,
    DateTime deadline,
    String? notes,
    String token,
  ) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    print('=== API CALL: CREATE SERVICE REQUEST ===');
    print('URL: ${AppConfig.apiBaseUrl}/service-requests');
    print('Token: ${token.substring(0, 20)}...');

    final response = await client.post(
      Uri.parse('${AppConfig.apiBaseUrl}/service-requests'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'title': title,
        'description': description,
        'category': category,
        'clientName': clientName,
        'clientPhone': clientPhone,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'budget': budget,
        'deadline': deadline.toIso8601String(),
        'notes': notes,
      }),
    );

    print('Create service request response status: ${response.statusCode}');
    print('Create service request response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return ServiceRequestModel.fromJson(data).toEntity();
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  @override
  Future<ServiceRequest> updateServiceRequest(String id, Map<String, dynamic> data, String token) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.put(
      Uri.parse('${AppConfig.apiBaseUrl}/service-requests/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return ServiceRequestModel.fromJson(responseData).toEntity();
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteServiceRequest(String id, String token) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.delete(
      Uri.parse('${AppConfig.apiBaseUrl}/service-requests/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  @override
  Future<ServiceRequest> assignPrestataire(String id, String prestataireId, String prestataireName, String token) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.put(
      Uri.parse('${AppConfig.apiBaseUrl}/service-requests/$id/assign'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'prestataireId': prestataireId,
        'prestataireName': prestataireName,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ServiceRequestModel.fromJson(data).toEntity();
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> completeServiceRequest({
    required String id,
    required DateTime completionDate,
    String? completionNotes,
    required int rating,
    String? reviewComment,
    required String token,
  }) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.put(
      Uri.parse('${AppConfig.apiBaseUrl}/service-requests/$id/complete'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'completionDate': completionDate.toIso8601String().split('T')[0], // Format YYYY-MM-DD
        'completionNotes': completionNotes,
        'rating': rating,
        'reviewComment': reviewComment,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }
}