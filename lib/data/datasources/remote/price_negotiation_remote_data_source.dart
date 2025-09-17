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
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.post(
      Uri.parse('$baseUrl/price-negotiations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'serviceRequestId': serviceRequestId,
        'proposedPrice': proposedPrice,
        'message': message,
        'isFromPrestataire': isFromPrestataire,
        'parentNegotiationId': parentNegotiationId,
      }),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return PriceNegotiationModel.fromJson(data).toEntity();
    } else {
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
}
