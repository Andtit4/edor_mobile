import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../entities/conversation.dart';
import '../entities/message.dart';

abstract class MessageRepository {
  Future<Either<Failure, List<Conversation>>> getConversations();

  Future<Either<Failure, Conversation>> getConversation(String conversationId);

  Future<Either<Failure, List<Message>>> getMessages(String conversationId);

  Future<Either<Failure, Message>> sendMessage({
    required String conversationId,
    required String content,
    required MessageType type,
  });

  Future<Either<Failure, void>> markMessageAsRead(String messageId);

  Future<Either<Failure, Conversation>> createConversation({
    required String prestataireId,
    required String initialMessage,
  });
}
