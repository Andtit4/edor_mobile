import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
          style: AppTextStyles.h3.copyWith(
            color: AppColors.activityText,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Chat Screen - En développement'),
      ),
    );
  }
}