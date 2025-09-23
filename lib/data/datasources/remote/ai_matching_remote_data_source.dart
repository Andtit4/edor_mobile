// lib/data/datasources/remote/ai_matching_remote_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/errors/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../../../core/config/app_config.dart';
import '../../../domain/entities/ai_match.dart';
import '../../models/ai_match_model.dart';

abstract class AIMatchingRemoteDataSource {
  Future<List<AIMatch>> generateMatches({
    required String serviceRequestId,
    int? maxResults,
    double? minScore,
    double? maxDistance,
    List<String>? preferredSkills,
    String? sortBy,
    required String token,
  });
  
  Future<List<AIMatch>> getMatchesForRequest({
    required String serviceRequestId,
    required String token,
  });
}

class AIMatchingRemoteDataSourceImpl implements AIMatchingRemoteDataSource {
  final http.Client client;
  final NetworkInfo networkInfo;

  AIMatchingRemoteDataSourceImpl({
    required this.client,
    required this.networkInfo,
  });

  @override
  Future<List<AIMatch>> generateMatches({
    required String serviceRequestId,
    int? maxResults,
    double? minScore,
    double? maxDistance,
    List<String>? preferredSkills,
    String? sortBy,
    required String token,
  }) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final requestBody = {
      'serviceRequestId': serviceRequestId,
      if (maxResults != null) 'maxResults': maxResults,
      if (minScore != null) 'minScore': minScore,
      if (maxDistance != null) 'maxDistance': maxDistance,
      if (preferredSkills != null) 'preferredSkills': preferredSkills,
      if (sortBy != null) 'sortBy': sortBy,
    };

    final response = await client.post(
      Uri.parse('${AppConfig.apiBaseUrl}/ai-matching/generate-matches'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((json) => AIMatchModel.fromJson(json).toEntity())
          .toList();
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  @override
  Future<List<AIMatch>> getMatchesForRequest({
    required String serviceRequestId,
    required String token,
  }) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.get(
      Uri.parse('${AppConfig.apiBaseUrl}/ai-matching/matches/$serviceRequestId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((json) => AIMatchModel.fromJson(json).toEntity())
          .toList();
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }
}
