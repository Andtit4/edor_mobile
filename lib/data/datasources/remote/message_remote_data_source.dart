// lib/data/datasources/remote/message_remote_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/errors/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/entities/conversation.dart';
import '../../../data/models/message_model.dart';
import '../../../data/models/conversation_model.dart';

abstract class MessageRemoteDataSource {
  Future<List<Conversation>> getConversations(String token);
  Future<Conversation> getConversationById(String id, String token);
  Future<List<Message>> getMessages(String conversationId, String token);
  Future<Message> sendMessage(String conversationId, String content, String token);
  Future<Conversation> createConversation(String prestataireId, String token, {String? serviceRequestId});
  Future<void> markMessagesAsRead(String conversationId, String token);
  Future<int> getUnreadCount(String token);
}

class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  final http.Client client;
  final NetworkInfo networkInfo;
  static const String baseUrl = 'http://localhost:3000';

  MessageRemoteDataSourceImpl({
    required this.client,
    required this.networkInfo,
  });

  @override
  Future<List<Conversation>> getConversations(String token) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/messages/conversations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final conversations = data.map((json) => ConversationModel.fromJson(json).toEntity()).toList();
      return conversations;
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  @override
  Future<Conversation> getConversationById(String id, String token) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/messages/conversations/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ConversationModel.fromJson(data).toEntity();
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  @override
  Future<List<Message>> getMessages(String conversationId, String token) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/messages/conversations/$conversationId/messages'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => MessageModel.fromJson(json).toEntity()).toList();
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  @override
  Future<Message> sendMessage(String conversationId, String content, String token) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.post(
      Uri.parse('$baseUrl/messages/conversations/$conversationId/messages'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'content': content,
        'type': 'text',
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return MessageModel.fromJson(data).toEntity();
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  @override
  Future<Conversation> createConversation(String prestataireId, String token, {String? serviceRequestId}) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.post(
      Uri.parse('$baseUrl/messages/conversations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'prestataireId': prestataireId,
        if (serviceRequestId != null) 'serviceRequestId': serviceRequestId,
      }),
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        throw ServerException(message: 'Timeout: La requête a pris trop de temps');
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return ConversationModel.fromJson(data).toEntity();
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }

  @override
  Future<void> markMessagesAsRead(String conversationId, String token) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.post(
      Uri.parse('$baseUrl/messages/conversations/$conversationId/read'),
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
  Future<int> getUnreadCount(String token) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/messages/unread-count'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['unreadCount'] ?? 0;
    } else {
      throw ServerException(message: 'Erreur du serveur: ${response.statusCode}');
    }
  }
}

