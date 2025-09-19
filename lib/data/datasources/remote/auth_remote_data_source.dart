// lib/data/datasources/remote/auth_remote_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/errors/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../../../core/config/app_config.dart';
import '../../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required UserRole role,
    String? category,
    String? location,
    String? description,
    double? pricePerHour,
    List<String>? skills,
  });
  Future<User> getCurrentUser(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final NetworkInfo networkInfo;

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
      Uri.parse('${AppConfig.apiBaseUrl}/auth/login'),
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
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required UserRole role,
    String? category,
    String? location,
    String? description,
    double? pricePerHour,
    List<String>? skills,
  }) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    print('=== API CALL: REGISTER ===');
    print('URL: ${AppConfig.apiBaseUrl}/auth/register');
    print('Email: $email');
    print('Role: $role');

    final response = await client.post(
      Uri.parse('${AppConfig.apiBaseUrl}/auth/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'role': role.name,
        'category': category,
        'location': location,
        'description': description,
        'pricePerHour': pricePerHour,
        'skills': skills,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      print('Parsed user data: ${data['user']}');
      print('Parsed token: ${data['token']}');
      return data;
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  @override
  Future<User> getCurrentUser(String token) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.get(
      Uri.parse('${AppConfig.apiBaseUrl}/auth/profile'),
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