// lib/data/datasources/remote/price_negotiation_remote_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/errors/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../../../domain/entities/price_negotiation.dart';
import '../../../data/models/price_negotiation_model.dart';

abstract class PriceNegotiationRemoteDataSource {
  Future<PriceNegotiation> createNegotiation({
    required String serviceRequestId,
    required double proposedPrice,
    String? message,
    bool? isFromPrestataire,
    String? parentNegotiationId,
    required String token,
  });
  
  Future<List<PriceNegotiation>> getNegotiationsByServiceRequest({
    required String serviceRequestId,
    required String token,
  });
  
  Future<PriceNegotiation> getNegotiationById({
    required String id,
    required String token,
  });
  
  Future<PriceNegotiation> updateNegotiationStatus({
    required String id,
    required String status,
    required String token,
  });
  
  Future<void> deleteNegotiation({
    required String id,
    required String token,
  });

  Future<List<PriceNegotiation>> getClientNegotiations({
    required String clientId,
    required String token,
  });

  Future<PriceNegotiation> acceptNegotiation({
    required String id,
    required String token,
  });
}

class PriceNegotiationRemoteDataSourceImpl implements PriceNegotiationRemoteDataSource {
  final http.Client client;
  final NetworkInfo networkInfo;
  static const String baseUrl = 'http://localhost:3000';

  PriceNegotiationRemoteDataSourceImpl({
    required this.client,
    required this.networkInfo,
  });

  @override
  Future<PriceNegotiation> createNegotiation({
    required String serviceRequestId,
    required double proposedPrice,
    String? message,
    bool? isFromPrestataire,
    String? parentNegotiationId,
    required String token,
  }) async {
    print('=== CREATE NEGOTIATION DATA SOURCE ===');
    print('Service Request ID: $serviceRequestId');
    print('Proposed Price: $proposedPrice');
    print('Message: $message');
    print('Is From Prestataire: $isFromPrestataire');
    print('Parent Negotiation ID: $parentNegotiationId');
    print('Token: ${token.substring(0, 20)}...');
    
    if (!await networkInfo.isConnected) {
      print('ERROR: No internet connection');
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final requestBody = {
      'serviceRequestId': serviceRequestId,
      'proposedPrice': proposedPrice,
      'message': message,
      'isFromPrestataire': isFromPrestataire,
      'parentNegotiationId': parentNegotiationId,
    };
    
    print('Request body: $requestBody');
    print('Sending POST to: $baseUrl/price-negotiations');

    final response = await client.post(
      Uri.parse('$baseUrl/price-negotiations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(requestBody),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      print('Parsed data: $data');
      return PriceNegotiationModel.fromJson(data).toEntity();
    } else {
      print('ERROR: Server returned ${response.statusCode}');
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  @override
  Future<List<PriceNegotiation>> getNegotiationsByServiceRequest({
    required String serviceRequestId,
    required String token,
  }) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/price-negotiations/service-request/$serviceRequestId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PriceNegotiationModel.fromJson(json).toEntity()).toList();
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  @override
  Future<PriceNegotiation> getNegotiationById({
    required String id,
    required String token,
  }) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/price-negotiations/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return PriceNegotiationModel.fromJson(data).toEntity();
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  @override
  Future<PriceNegotiation> updateNegotiationStatus({
    required String id,
    required String status,
    required String token,
  }) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.put(
      Uri.parse('$baseUrl/price-negotiations/$id/status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'status': status}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return PriceNegotiationModel.fromJson(data).toEntity();
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteNegotiation({
    required String id,
    required String token,
  }) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.delete(
      Uri.parse('$baseUrl/price-negotiations/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  @override
  Future<List<PriceNegotiation>> getClientNegotiations({
    required String clientId,
    required String token,
  }) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/price-negotiations/client/$clientId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PriceNegotiationModel.fromJson(json).toEntity()).toList();
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  @override
  Future<PriceNegotiation> acceptNegotiation({
    required String id,
    required String token,
  }) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.put(
      Uri.parse('$baseUrl/price-negotiations/$id/accept'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return PriceNegotiationModel.fromJson(data).toEntity();
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }
}
