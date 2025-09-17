import 'package:freezed_annotation/freezed_annotation.dart';
import 'message.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

@freezed
class Conversation with _$Conversation {
  const factory Conversation({
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
    String? lastMessage,
    DateTime? lastMessageTime,
    @Default([]) List<Message> messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
}
