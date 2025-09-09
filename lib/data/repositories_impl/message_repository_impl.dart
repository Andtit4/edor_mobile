import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/message_repository.dart';
import '../datasources/local/local_data_source.dart';

class MessageRepositoryImpl implements MessageRepository {
  final LocalDataSource localDataSource;

  MessageRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Conversation>>> getConversations() async {
    try {
      final conversationsList = await localDataSource.loadAssetJson(
        'assets/mock/conversations.json',
      );
      final conversations =
          (conversationsList as List<dynamic>)
              .map(
                (json) => Conversation.fromJson(json as Map<String, dynamic>),
              )
              .toList();

      return Right(conversations);
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Conversation>> getConversation(
    String conversationId,
  ) async {
    try {
      final result = await getConversations();
      return result.fold((failure) => Left(failure), (conversations) {
        final conversation = conversations.firstWhere(
          (c) => c.id == conversationId,
          orElse:
              () =>
                  throw const CacheException(
                    message: 'Conversation non trouvée',
                  ),
        );
        return Right(conversation);
      });
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages(
    String conversationId,
  ) async {
    try {
      final result = await getConversation(conversationId);
      return result.fold(
        (failure) => Left(failure),
        (conversation) => Right(conversation.messages),
      );
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage({
    required String conversationId,
    required String content,
    required MessageType type,
  }) async {
    try {
      // Pour le MVP, créer un nouveau message temporaire
      final newMessage = Message(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        conversationId: conversationId,
        senderId: 'current_user', // Récupérer depuis le cache plus tard
        content: content,
        type: type,
        isRead: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Dans une vraie implémentation, on sauvegarderait en cache ou enverrait au serveur
      return Right(newMessage);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markMessageAsRead(String messageId) async {
    try {
      // Pour le MVP, simuler la mise à jour
      await Future.delayed(const Duration(milliseconds: 100));
      return const Right(null);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Conversation>> createConversation({
    required String prestataireId,
    required String initialMessage,
  }) async {
    try {
      // Pour le MVP, créer une nouvelle conversation temporaire
      final newConversation = Conversation(
        id: 'conv_${DateTime.now().millisecondsSinceEpoch}',
        clientId: 'current_user',
        prestataireId: prestataireId,
        clientName: 'Utilisateur actuel',
        prestataireName: 'Prestataire',
        lastMessage: initialMessage,
        lastMessageTime: DateTime.now(),
        unreadCount: 0,
        messages: [
          Message(
            id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
            conversationId: 'conv_${DateTime.now().millisecondsSinceEpoch}',
            senderId: 'current_user',
            content: initialMessage,
            type: MessageType.text,
            isRead: false,
            createdAt: DateTime.now(),
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      return Right(newConversation);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}
