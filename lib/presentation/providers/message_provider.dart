import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../data/datasources/remote/message_remote_data_source.dart';
import '../../core/network/network_info.dart';
import 'auth_provider.dart';

// Data Source Provider
final messageRemoteDataSourceProvider = Provider<MessageRemoteDataSource>((ref) {
  return MessageRemoteDataSourceImpl(
    client: ref.read(httpClientProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

// Messages State
class MessagesState {
  final List<Conversation> conversations;
  final Map<String, List<Message>> messagesByConversation;
  final bool isLoading;
  final String? error;
  final bool isSendingMessage;
  final int unreadCount;

  const MessagesState({
    this.conversations = const [],
    this.messagesByConversation = const {},
    this.isLoading = false,
    this.error,
    this.isSendingMessage = false,
    this.unreadCount = 0,
  });

  MessagesState copyWith({
    List<Conversation>? conversations,
    Map<String, List<Message>>? messagesByConversation,
    bool? isLoading,
    String? error,
    bool? isSendingMessage,
    int? unreadCount,
  }) {
    return MessagesState(
      conversations: conversations ?? this.conversations,
      messagesByConversation:
          messagesByConversation ?? this.messagesByConversation,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

// Messages Notifier
class MessagesNotifier extends StateNotifier<MessagesState> {
  final MessageRemoteDataSource _remoteDataSource;

  MessagesNotifier(this._remoteDataSource) : super(const MessagesState());

  Future<void> loadConversations(String token) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final conversations = await _remoteDataSource.getConversations(token);
      
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
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMessages(String conversationId, String token) async {
    try {
      final messages = await _remoteDataSource.getMessages(conversationId, token);
      
      final updatedMessagesMap = Map<String, List<Message>>.from(
        state.messagesByConversation,
      );
      updatedMessagesMap[conversationId] = messages;

      state = state.copyWith(messagesByConversation: updatedMessagesMap);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> sendMessage({
    required String conversationId,
    required String content,
    required String token,
    MessageType type = MessageType.text,
  }) async {
    state = state.copyWith(isSendingMessage: true, error: null);

    try {
      final message = await _remoteDataSource.sendMessage(conversationId, content, token);
      
      // Ajouter le message à la liste existante
      final currentMessages = state.messagesByConversation[conversationId] ?? [];
      final updatedMessages = [...currentMessages, message];

      final updatedMessagesMap = Map<String, List<Message>>.from(
        state.messagesByConversation,
      );
      updatedMessagesMap[conversationId] = updatedMessages;

      state = state.copyWith(
        isSendingMessage: false,
        messagesByConversation: updatedMessagesMap,
      );
    } catch (e) {
      state = state.copyWith(
        isSendingMessage: false,
        error: e.toString(),
      );
    }
  }

  Future<Conversation?> createConversation({
    required String prestataireId,
    required String token,
    String? serviceRequestId,
  }) async {
    try {
      print('=== MESSAGE PROVIDER - CREATE CONVERSATION ===');
      print('Prestataire ID: $prestataireId');
      print('Token: ${token.substring(0, 20)}...');
      print('Service Request ID: $serviceRequestId');
      
      final conversation = await _remoteDataSource.createConversation(
        prestataireId, 
        token, 
        serviceRequestId: serviceRequestId,
      );
      
      print('Conversation received from API: ${conversation?.id}');
      
      // Ajouter la conversation à la liste
      final updatedConversations = [...state.conversations, conversation];
      state = state.copyWith(conversations: updatedConversations);
      
      print('Conversation added to state');
      print('===============================================');
      
      return conversation;
    } catch (e) {
      print('ERROR in createConversation: $e');
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  Future<void> markMessagesAsRead(String conversationId, String token) async {
    try {
      await _remoteDataSource.markMessagesAsRead(conversationId, token);
      
      // Mettre à jour l'état local
      final updatedConversations = state.conversations.map((conv) {
        if (conv.id == conversationId) {
          return conv.copyWith(unreadCount: 0);
        }
        return conv;
      }).toList();
      
      state = state.copyWith(conversations: updatedConversations);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> loadUnreadCount(String token) async {
    try {
      final count = await _remoteDataSource.getUnreadCount(token);
      state = state.copyWith(unreadCount: count);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<void> refresh(String token) async {
    await loadConversations(token);
    await loadUnreadCount(token);
  }
}

// Messages Provider
final messagesProvider = StateNotifierProvider<MessagesNotifier, MessagesState>(
  (ref) {
    final remoteDataSource = ref.watch(messageRemoteDataSourceProvider);
    return MessagesNotifier(remoteDataSource);
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
  return ref.watch(messagesProvider).unreadCount;
});