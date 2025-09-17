// lib/data/models/conversation_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import 'message_model.dart';

part 'conversation_model.freezed.dart';
part 'conversation_model.g.dart';

@freezed
class ConversationModel with _$ConversationModel {
  const factory ConversationModel({
    required String id,
    required String clientId,
    required String prestataireId,
    String? serviceRequestId,
    @Default(true) bool isActive,
    @Default(0) int unreadCount,
    String? lastMessageId,
    // Informations des utilisateurs (pour l'affichage)
    String? clientName,
    String? prestataireName,
    String? clientAvatar,
    String? prestataireAvatar,
    String? lastMessageContent,
    DateTime? lastMessageTime,
    @Default([]) List<MessageModel> messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ConversationModel;

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);
}

// Extension pour convertir en entité
extension ConversationModelExtension on ConversationModel {
  Conversation toEntity() {
    return Conversation(
      id: id,
      clientId: clientId,
      prestataireId: prestataireId,
      serviceRequestId: serviceRequestId,
      isActive: isActive,
      unreadCount: unreadCount,
      lastMessageId: lastMessageId,
      clientName: clientName,
      prestataireName: prestataireName,
      clientAvatar: clientAvatar,
      prestataireAvatar: prestataireAvatar,
      lastMessageContent: lastMessageContent,
      lastMessageTime: lastMessageTime,
      messages: messages.map((m) => m.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}


