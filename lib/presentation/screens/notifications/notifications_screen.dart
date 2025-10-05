import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/notification_badge.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  // Liste de notifications simulées (à remplacer par de vraies données)
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Nouvelle demande de service',
      'body': 'Jean Dupont a publié une nouvelle demande de ménage à Paris',
      'type': 'new_service_request',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
      'isRead': false,
      'data': {
        'serviceRequestId': 'req_123',
        'category': 'menage',
        'clientName': 'Jean Dupont',
      },
    },
    {
      'id': '2',
      'title': 'Service accepté',
      'body': 'Marie Martin a accepté votre demande de plomberie',
      'type': 'service_accepted',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      'isRead': true,
      'data': {
        'serviceRequestId': 'req_456',
        'prestataireName': 'Marie Martin',
      },
    },
    {
      'id': '3',
      'title': 'Service terminé',
      'body': 'Pierre Durand a terminé votre service d\'électricité',
      'type': 'service_completed',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      'isRead': true,
      'data': {
        'serviceRequestId': 'req_789',
        'prestataireName': 'Pierre Durand',
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationProvider);
    final unreadCount = _notifications.where((n) => !n['isRead']).length;

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: AppColors.lightGray,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.borderColor.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.purple,
              size: 18,
            ),
          ),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Text(
              'Notifications',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.purple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  unreadCount.toString(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
        centerTitle: false,
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'Tout marquer comme lu',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.purple,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Section de test (à supprimer en production)
          if (notificationState.isInitialized) ...[
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.borderColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Test de notifications',
                    style: AppTextStyles.h4.copyWith(
                      color: AppColors.purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _sendTestNotification('menage'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.purple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Test Ménage'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _sendTestNotification('plomberie'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.purple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Test Plomberie'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          
          // Liste des notifications
          Expanded(
            child: NotificationList(
              notifications: _notifications,
              onNotificationTap: _handleNotificationTap,
              onNotificationDismiss: _dismissNotification,
            ),
          ),
        ],
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    // Marquer comme lu
    setState(() {
      notification['isRead'] = true;
    });

    // Naviguer selon le type de notification
    final type = notification['type'];
    final data = notification['data'] as Map<String, dynamic>?;

    switch (type) {
      case 'new_service_request':
        final serviceRequestId = data?['serviceRequestId'];
        if (serviceRequestId != null) {
          // TODO: Naviguer vers la page de détails de la demande
          _showSnackBar('Navigation vers la demande: $serviceRequestId');
        }
        break;
      case 'service_accepted':
        // TODO: Naviguer vers la page de conversation
        _showSnackBar('Navigation vers la conversation');
        break;
      case 'service_completed':
        // TODO: Naviguer vers la page d'évaluation
        _showSnackBar('Navigation vers l\'évaluation');
        break;
      default:
        _showSnackBar('Notification tapée: ${notification['title']}');
    }
  }

  void _dismissNotification(String notificationId) {
    setState(() {
      _notifications.removeWhere((n) => n['id'] == notificationId);
    });
  }

  void _sendTestNotification(String category) {
    ref.read(notificationProvider.notifier).sendNotificationToCategory(
      category: category,
      title: 'Test de notification - $category',
      body: 'Ceci est une notification de test pour la catégorie $category',
      data: {
        'type': 'test_notification',
        'category': category,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    
    _showSnackBar('Notification de test envoyée pour $category');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.purple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}




