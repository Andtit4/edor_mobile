import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/errors/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../../../core/config/app_config.dart';
import '../../../domain/entities/review.dart';

abstract class ReviewRemoteDataSource {
  Future<List<Review>> getReviewsByPrestataire(String prestataireId);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final http.Client client;
  final NetworkInfo networkInfo;

  ReviewRemoteDataSourceImpl({
    required this.client,
    required this.networkInfo,
  });

  @override
  Future<List<Review>> getReviewsByPrestataire(String prestataireId) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.get(
      Uri.parse('${AppConfig.apiBaseUrl}/reviews/prestataire/$prestataireId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('DEBUG: Reviews reçues du serveur: ${data.length} reviews');
      for (var review in data) {
        print('DEBUG: Review - clientName: ${review['clientName']}, comment: ${review['comment']}, rating: ${review['rating']}');
      }
      return data.map((json) => Review.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }
}