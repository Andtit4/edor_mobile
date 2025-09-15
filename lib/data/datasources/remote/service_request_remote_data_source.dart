// lib/data/datasources/remote/service_request_remote_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/errors/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../../../domain/entities/service_request.dart';

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
    double budget,
    DateTime deadline,
    String? notes,
    String token,
  );
  Future<ServiceRequest> updateServiceRequest(String id, Map<String, dynamic> data, String token);
  Future<void> deleteServiceRequest(String id, String token);
  Future<ServiceRequest> assignPrestataire(String requestId, String prestataireId, String prestataireName, String token);
}

class ServiceRequestRemoteDataSourceImpl implements ServiceRequestRemoteDataSource {
  final http.Client client;
  final NetworkInfo networkInfo;
  static const String baseUrl = 'http://localhost:3000';

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
      Uri.parse('$baseUrl/service-requests'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ServiceRequest.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  @override
  Future<List<ServiceRequest>> getMyServiceRequests(String token) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/service-requests/my-requests'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ServiceRequest.fromJson(json)).toList();
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
      Uri.parse('$baseUrl/service-requests/assigned-to-me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ServiceRequest.fromJson(json)).toList();
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
      Uri.parse('$baseUrl/service-requests/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ServiceRequest.fromJson(data);
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
    double budget,
    DateTime deadline,
    String? notes,
    String token,
  ) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.post(
      Uri.parse('$baseUrl/service-requests'),
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
        'budget': budget,
        'deadline': deadline.toIso8601String(),
        if (notes != null) 'notes': notes,
      }),
    );

    print('Create service request response status: ${response.statusCode}');
    print('Create service request response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return ServiceRequest.fromJson(data);
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode} - ${response.body}');
    }
  }

  @override
  Future<ServiceRequest> updateServiceRequest(String id, Map<String, dynamic> data, String token) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.put(
      Uri.parse('$baseUrl/service-requests/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return ServiceRequest.fromJson(responseData);
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
      Uri.parse('$baseUrl/service-requests/$id'),
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
  Future<ServiceRequest> assignPrestataire(String requestId, String prestataireId, String prestataireName, String token) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.put(
      Uri.parse('$baseUrl/service-requests/$requestId/assign'),
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
      return ServiceRequest.fromJson(data);
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }
}