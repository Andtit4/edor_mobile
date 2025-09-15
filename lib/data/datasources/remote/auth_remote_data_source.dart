// lib/data/datasources/remote/auth_remote_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/errors/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
    required UserRole role,
  });
  Future<User> getCurrentUser(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final NetworkInfo networkInfo;
  static const String baseUrl = 'http://localhost:3000';

  AuthRemoteDataSourceImpl({
    required this.client,
    required this.networkInfo,
  });

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    print('Login response status: ${response.statusCode}');
    print('Login response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final data = json.decode(response.body);
        final user = User.fromJson(data['user']); // Utiliser directement User
        
        return {
          'user': user,
          'token': data['token'],
        };
      } catch (e) {
        print('Error parsing login response: $e');
        throw ServerException(message: 'Erreur lors du parsing de la réponse: $e');
      }
    } else if (response.statusCode == 401) {
      throw const UnauthorizedException(message: 'Email ou mot de passe incorrect');
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode} - ${response.body}');
    }
  }

  @override
  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'email': email,
        'password': password,
        'role': role.name,
      }),
    );

    print('Register response status: ${response.statusCode}');
    print('Register response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final data = json.decode(response.body);
        final user = User.fromJson(data['user']); // Utiliser directement User
        
        return {
          'user': user,
          'token': data['token'],
        };
      } catch (e) {
        print('Error parsing register response: $e');
        throw ServerException(message: 'Erreur lors du parsing de la réponse: $e');
      }
    } else if (response.statusCode == 409) {
      throw const ConflictException(message: 'Un utilisateur avec cet email existe déjà');
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode} - ${response.body}');
    }
  }

  @override
  Future<User> getCurrentUser(String token) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/auth/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data); // Utiliser directement User
    } else if (response.statusCode == 401) {
      throw const UnauthorizedException(message: 'Token invalide');
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }
}