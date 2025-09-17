import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

enum MessageType { text, image, system }

@freezed
class Message with _$Message {
  const factory Message({
    required String id,
    required String conversationId,
    String? senderUserId,
    String? senderPrestataireId,
    required String senderType, // 'client' ou 'prestataire'
    required String content,
    required MessageType type,
    @Default(false) bool isRead,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}
