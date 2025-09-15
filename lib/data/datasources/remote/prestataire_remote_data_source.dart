// lib/data/datasources/remote/prestataire_remote_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/errors/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../../../domain/entities/prestataire.dart';

abstract class PrestataireRemoteDataSource {
  Future<List<Prestataire>> getAllPrestataires();
  Future<List<Prestataire>> getPrestatairesByCategory(String category);
  Future<Prestataire> getPrestataireById(String id);
}

class PrestataireRemoteDataSourceImpl implements PrestataireRemoteDataSource {
  final http.Client client;
  final NetworkInfo networkInfo;
  static const String baseUrl = 'http://localhost:3000';

  PrestataireRemoteDataSourceImpl({
    required this.client,
    required this.networkInfo,
  });

  @override
  Future<List<Prestataire>> getAllPrestataires() async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/prestataires'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Prestataire.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  @override
  Future<List<Prestataire>> getPrestatairesByCategory(String category) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/prestataires/category/$category'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Prestataire.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  @override
  Future<Prestataire> getPrestataireById(String id) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/prestataires/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Prestataire.fromJson(data);
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }
}