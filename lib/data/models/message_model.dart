// lib/data/models/message_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/message.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String id,
    required String conversationId,
    String? senderUserId,
    String? senderPrestataireId,
    required String senderType,
    required String content,
    required MessageType type,
    @Default(false) bool isRead,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}

// Extension pour convertir en entité
extension MessageModelExtension on MessageModel {
  Message toEntity() {
    return Message(
      id: id,
      conversationId: conversationId,
      senderUserId: senderUserId,
      senderPrestataireId: senderPrestataireId,
      senderType: senderType,
      content: content,
      type: type,
      isRead: isRead,
      imageUrl: imageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

