// lib/presentation/screens/chat/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/message_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/entities/conversation.dart';
import '../../../domain/entities/user.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String conversationId;
  
  const ChatScreen({
    super.key,
    required this.conversationId,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMessages() {
    final authState = ref.read(authProvider);
    final token = authState.token;
    
    if (token != null) {
      ref.read(messagesProvider.notifier).loadMessages(widget.conversationId, token);
    }
  }

  void _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    final authState = ref.read(authProvider);
    final token = authState.token;
    
    if (token == null) return;

    _messageController.clear();

    await ref.read(messagesProvider.notifier).sendMessage(
      conversationId: widget.conversationId,
      content: content,
      token: token,
    );

    // Faire défiler vers le bas
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final conversation = ref.watch(conversationProvider(widget.conversationId));
    final messages = ref.watch(messagesForConversationProvider(widget.conversationId));
    final authState = ref.watch(authProvider);
    final currentUser = authState.user;

    if (conversation == null) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Conversation'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Déterminer le nom de l'autre utilisateur
    print('=== CHAT SCREEN DEBUG (CORRECT FILE) ===');
    print('Current user role: ${currentUser?.role}');
    print('Prestataire name: ${conversation.prestataireName}');
    print('Client name: ${conversation.clientName}');
    
    final otherUserName = currentUser?.role == UserRole.client 
        ? conversation.prestataireName ?? 'Prestataire'
        : conversation.clientName ?? 'Client';
    
    print('Selected name: $otherUserName');
    print('=========================================');

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF8B5CF6).withOpacity(0.1),
              child: Text(
                otherUserName.isNotEmpty ? otherUserName[0].toUpperCase() : 'U',
                style: const TextStyle(
                  color: Color(0xFF8B5CF6),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherUserName,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'En ligne',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // TODO: Implémenter le menu
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Liste des messages
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun message',
          style: AppTextStyles.h3.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Envoyez votre premier message',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return _buildMessageBubble(message, currentUser);
                    },
                  ),
          ),
          
          // Zone de saisie
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Tapez votre message...',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.grey[500],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Color(0xFF8B5CF6)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B5CF6),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message, currentUser) {
    final isMe = message.senderType == 'client' && 
        message.senderUserId == currentUser?.id;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF8B5CF6).withOpacity(0.1),
              child: Text(
                message.senderType == 'client' ? 'C' : 'P',
                style: const TextStyle(
                  color: Color(0xFF8B5CF6),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFF8B5CF6) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isMe ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('HH:mm').format(message.createdAt ?? DateTime.now()),
                    style: AppTextStyles.caption.copyWith(
                      color: isMe ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF8B5CF6).withOpacity(0.1),
              child: Text(
                currentUser?.firstName?.isNotEmpty == true 
                    ? currentUser!.firstName![0].toUpperCase() 
                    : 'U',
                style: const TextStyle(
                  color: Color(0xFF8B5CF6),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}