import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/message_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../core/theme/app_text_styles.dart';

class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesState = ref.watch(messagesProvider);
    final authState = ref.watch(authProvider);
    final currentUser = authState.user;

    // Charger les conversations au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = authState.token;
      if (token != null) {
        ref.read(messagesProvider.notifier).loadConversations(token);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Messages',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.black,
            ),
            onPressed: () {
              final token = authState.token;
              if (token != null) {
                ref.read(messagesProvider.notifier).refresh(token);
              }
            },
          ),
        ],
      ),
      body: messagesState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : messagesState.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Erreur de chargement',
                        style: AppTextStyles.h3.copyWith(
                          color: Colors.red[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        messagesState.error!,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.red[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          final token = authState.token;
                          if (token != null) {
                            ref.read(messagesProvider.notifier).loadConversations(token);
                          }
                        },
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : messagesState.conversations.isEmpty
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
                            'Aucune conversation',
                            style: AppTextStyles.h3.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Commencez une conversation avec un prestataire',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: messagesState.conversations.length,
                      itemBuilder: (context, index) {
                        final conversation = messagesState.conversations[index];
                        return _buildConversationCard(context, conversation, currentUser);
                      },
                    ),
    );
  }

  Widget _buildConversationCard(BuildContext context, conversation, currentUser) {
    // Déterminer le nom de l'autre utilisateur
    final otherUserName = currentUser?.role == 'client' 
        ? conversation.prestataireName ?? 'Prestataire'
        : conversation.clientName ?? 'Client';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: const Color(0xFF8B5CF6).withOpacity(0.1),
          child: Text(
            otherUserName.isNotEmpty ? otherUserName[0].toUpperCase() : 'U',
            style: const TextStyle(
              color: Color(0xFF8B5CF6),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          otherUserName,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          conversation.lastMessage ?? 'Aucun message',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.grey[600],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (conversation.lastMessageTime != null)
              Text(
                DateFormat('HH:mm').format(conversation.lastMessageTime!),
                style: AppTextStyles.caption.copyWith(
                  color: Colors.grey[500],
                ),
              ),
            if (conversation.unreadCount > 0) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: const BoxDecoration(
                  color: Color(0xFF8B5CF6),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  conversation.unreadCount.toString(),
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        onTap: () {
          context.push('/messages/chat/${conversation.id}');
        },
      ),
    );
  }
}