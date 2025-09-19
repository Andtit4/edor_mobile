// lib/data/datasources/remote/prestataire_remote_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/errors/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../../../core/config/app_config.dart';
import '../../../domain/entities/prestataire.dart';

abstract class PrestataireRemoteDataSource {
  Future<List<Prestataire>> getAllPrestataires();
  Future<List<Prestataire>> getPrestatairesByCategory(String category);
  Future<Prestataire> getPrestataireById(String id);
}

class PrestataireRemoteDataSourceImpl implements PrestataireRemoteDataSource {
  final http.Client client;
  final NetworkInfo networkInfo;

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
      Uri.parse('${AppConfig.apiBaseUrl}/prestataires'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('[DEBUG] Réponse du serveur reçue pour getAllPrestataires');
      final List<dynamic> data = json.decode(response.body);
      print('[DEBUG] Nombre d\'éléments reçus: ${data.length}');
      
      if (data.isNotEmpty) {
        print('[DEBUG] Premier élément: ${data.first}');
      }
      
      final List<Prestataire> prestataires = [];
      for (int i = 0; i < data.length; i++) {
        try {
          print('[DEBUG] Parsing prestataire $i: ${data[i]}');
          final prestataire = Prestataire.fromJson(data[i]);
          prestataires.add(prestataire);
          print('[DEBUG] Prestataire $i parsé avec succès');
        } catch (e) {
          print('[ERROR] Erreur lors du parsing du prestataire $i: $e');
          print('[ERROR] Données: ${data[i]}');
          rethrow;
        }
      }
      
      return prestataires;
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
      Uri.parse('${AppConfig.apiBaseUrl}/prestataires/category/$category'),
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
      Uri.parse('${AppConfig.apiBaseUrl}/prestataires/$id'),
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