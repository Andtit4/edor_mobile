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
      final conversationsData = await localDataSource.loadAssetJson(
        'assets/mock/conversations.json',
      );
      
      // Gérer les deux cas : array direct ou object avec array
      List<dynamic> conversationsList;
      if (conversationsData is List) {
        conversationsList = conversationsData;
      } else if (conversationsData is Map<String, dynamic>) {
        conversationsList = conversationsData['conversations'] as List<dynamic>? ?? [];
      } else {
        throw const CacheException(message: 'Format de données invalide');
      }
      
      final conversations = conversationsList
          .map((json) => Conversation.fromJson(json as Map<String, dynamic>))
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
          orElse: () =>
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
      // Pour le MVP, créer un message temporaire
      final message = Message(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        conversationId: conversationId,
        senderId: 'current_user',
        content: content,
        type: type,
        isRead: false,
        createdAt: DateTime.now(),
      );

      return Right(message);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markMessageAsRead(String messageId) async {
    try {
      // Pour le MVP, on simule juste le marquage comme lu
      // Dans une vraie app, on ferait une requête API ou on mettrait à jour la base de données locale
      
      // Récupérer toutes les conversations
      final result = await getConversations();
      return result.fold(
        (failure) => Left(failure),
        (conversations) {
          // Chercher le message dans toutes les conversations
          for (final conversation in conversations) {
            final messageIndex = conversation.messages.indexWhere(
              (msg) => msg.id == messageId,
            );
            
            if (messageIndex != -1) {
              // Message trouvé - dans une vraie app, on le marquerait comme lu
              // Pour le MVP, on retourne juste un succès
              return const Right(null);
            }
          }
          
          // Message non trouvé
          return const Left(
            Failure.cache(message: 'Message non trouvé'),
          );
        },
      );
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