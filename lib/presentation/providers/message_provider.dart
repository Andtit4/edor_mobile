import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/message_repository.dart';
import '../../data/repositories_impl/message_repository_impl.dart';
import 'auth_provider.dart';

// Repository Provider
final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  final localDataSource = ref.watch(localDataSourceProvider);
  return MessageRepositoryImpl(localDataSource: localDataSource);
});

// Messages State
class MessagesState {
  final List<Conversation> conversations;
  final Map<String, List<Message>> messagesByConversation;
  final bool isLoading;
  final String? error;
  final bool isSendingMessage;

  const MessagesState({
    this.conversations = const [],
    this.messagesByConversation = const {},
    this.isLoading = false,
    this.error,
    this.isSendingMessage = false,
  });

  MessagesState copyWith({
    List<Conversation>? conversations,
    Map<String, List<Message>>? messagesByConversation,
    bool? isLoading,
    String? error,
    bool? isSendingMessage,
  }) {
    return MessagesState(
      conversations: conversations ?? this.conversations,
      messagesByConversation:
          messagesByConversation ?? this.messagesByConversation,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
    );
  }
}

// Messages Notifier
class MessagesNotifier extends StateNotifier<MessagesState> {
  final MessageRepository _repository;

  MessagesNotifier(this._repository) : super(const MessagesState()) {
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    state = state.copyWith(isLoading: true);

    final result = await _repository.getConversations();
    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (conversations) {
        // Créer la map des messages par conversation
        final Map<String, List<Message>> messagesByConversation = {};
        for (final conversation in conversations) {
          messagesByConversation[conversation.id] = conversation.messages;
        }

        state = state.copyWith(
          isLoading: false,
          conversations: conversations,
          messagesByConversation: messagesByConversation,
        );
      },
    );
  }

  Future<void> loadMessages(String conversationId) async {
    final result = await _repository.getMessages(conversationId);
    result.fold((failure) => state = state.copyWith(error: failure.message), (
      messages,
    ) {
      final updatedMessagesMap = Map<String, List<Message>>.from(
        state.messagesByConversation,
      );
      updatedMessagesMap[conversationId] = messages;

      state = state.copyWith(messagesByConversation: updatedMessagesMap);
    });
  }

  Future<void> sendMessage({
    required String conversationId,
    required String content,
    MessageType type = MessageType.text,
  }) async {
    state = state.copyWith(isSendingMessage: true);

    final result = await _repository.sendMessage(
      conversationId: conversationId,
      content: content,
      type: type,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(
            isSendingMessage: false,
            error: failure.message,
          ),
      (message) {
        // Ajouter le message à la liste existante
        final currentMessages =
            state.messagesByConversation[conversationId] ?? [];
        final updatedMessages = [...currentMessages, message];

        final updatedMessagesMap = Map<String, List<Message>>.from(
          state.messagesByConversation,
        );
        updatedMessagesMap[conversationId] = updatedMessages;

        // Mettre à jour la conversation avec le dernier message
        final updatedConversations =
            state.conversations.map((conv) {
              if (conv.id == conversationId) {
                return conv.copyWith(
                  lastMessage: content,
                  lastMessageTime: DateTime.now(),
                );
              }
              return conv;
            }).toList();

        state = state.copyWith(
          isSendingMessage: false,
          conversations: updatedConversations,
          messagesByConversation: updatedMessagesMap,
        );
      },
    );
  }

  Future<void> createConversation({
    required String prestataireId,
    required String initialMessage,
  }) async {
    state = state.copyWith(isLoading: true);

    final result = await _repository.createConversation(
      prestataireId: prestataireId,
      initialMessage: initialMessage,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (conversation) {
        final updatedConversations = [...state.conversations, conversation];
        final updatedMessagesMap = Map<String, List<Message>>.from(
          state.messagesByConversation,
        );
        updatedMessagesMap[conversation.id] = conversation.messages;

        state = state.copyWith(
          isLoading: false,
          conversations: updatedConversations,
          messagesByConversation: updatedMessagesMap,
        );
      },
    );
  }

  Future<void> markMessageAsRead(String messageId) async {
    await _repository.markMessageAsRead(messageId);
    // Pour le MVP, on ne met pas à jour l'état local
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<void> refresh() async {
    await _loadConversations();
  }
}

// Messages Provider
final messagesProvider = StateNotifierProvider<MessagesNotifier, MessagesState>(
  (ref) {
    final repository = ref.watch(messageRepositoryProvider);
    return MessagesNotifier(repository);
  },
);

// Individual Conversation Provider
final conversationProvider = Provider.family<Conversation?, String>((
  ref,
  conversationId,
) {
  final conversations = ref.watch(messagesProvider).conversations;
  try {
    return conversations.firstWhere((conv) => conv.id == conversationId);
  } catch (e) {
    return null;
  }
});

// Messages for Conversation Provider
final messagesForConversationProvider = Provider.family<List<Message>, String>((
  ref,
  conversationId,
) {
  final messagesMap = ref.watch(messagesProvider).messagesByConversation;
  return messagesMap[conversationId] ?? [];
});

// Unread Messages Count Provider
final unreadMessagesCountProvider = Provider<int>((ref) {
  final conversations = ref.watch(messagesProvider).conversations;
  return conversations.fold<int>(0, (sum, conv) => sum + conv.unreadCount);
});
