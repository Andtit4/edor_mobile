import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/errors/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../../../domain/entities/review.dart';
import '../../../data/models/review_model.dart';

abstract class ReviewRemoteDataSource {
  Future<Review> createReview({
    required String serviceRequestId,
    required String prestataireId,
    required int rating,
    String? comment,
    required String token,
  });

  Future<List<Review>> getPrestataireReviews({
    required String prestataireId,
    required String token,
  });

  Future<double> getPrestataireAverageRating({
    required String prestataireId,
    required String token,
  });

  Future<int> getPrestataireReviewsCount({
    required String prestataireId,
    required String token,
  });
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final http.Client client;
  final NetworkInfo networkInfo;
  static const String baseUrl = 'http://localhost:3000';

  ReviewRemoteDataSourceImpl({
    required this.client,
    required this.networkInfo,
  });

  @override
  Future<Review> createReview({
    required String serviceRequestId,
    required String prestataireId,
    required int rating,
    String? comment,
    required String token,
  }) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final requestBody = {
      'serviceRequestId': serviceRequestId,
      'prestataireId': prestataireId,
      'rating': rating,
      'comment': comment,
    };

    final response = await client.post(
      Uri.parse('$baseUrl/reviews'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(requestBody),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return ReviewModel.fromJson(data).toEntity();
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  @override
  Future<List<Review>> getPrestataireReviews({
    required String prestataireId,
    required String token,
  }) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/reviews/prestataire/$prestataireId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ReviewModel.fromJson(json).toEntity()).toList();
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  @override
  Future<double> getPrestataireAverageRating({
    required String prestataireId,
    required String token,
  }) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/reviews/prestataire/$prestataireId/average'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data as num).toDouble();
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  @override
  Future<int> getPrestataireReviewsCount({
    required String prestataireId,
    required String token,
  }) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/reviews/prestataire/$prestataireId/count'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data as int;
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }
}
