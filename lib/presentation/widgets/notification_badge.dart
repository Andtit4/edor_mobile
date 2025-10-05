import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Widget pour afficher un badge de notification
class NotificationBadge extends ConsumerWidget {
  final int count;
  final Widget child;
  final bool showZero;
  final Color? badgeColor;
  final Color? textColor;

  const NotificationBadge({
    super.key,
    required this.count,
    required this.child,
    this.showZero = false,
    this.badgeColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shouldShow = showZero || count > 0;
    
    if (!shouldShow) {
      return child;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          right: -8,
          top: -8,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: badgeColor ?? AppColors.purple,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: (badgeColor ?? AppColors.purple).withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            constraints: const BoxConstraints(
              minWidth: 20,
              minHeight: 20,
            ),
            child: Text(
              count > 99 ? '99+' : count.toString(),
              style: AppTextStyles.bodySmall.copyWith(
                color: textColor ?? Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget pour afficher une liste de notifications
class NotificationList extends ConsumerWidget {
  final List<Map<String, dynamic>> notifications;
  final Function(Map<String, dynamic>)? onNotificationTap;
  final Function(String)? onNotificationDismiss;

  const NotificationList({
    super.key,
    required this.notifications,
    this.onNotificationTap,
    this.onNotificationDismiss,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationItem(context, notification);
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune notification',
            style: AppTextStyles.h4.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vous recevrez des notifications quand il y aura de l\'activité',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, Map<String, dynamic> notification) {
    final title = notification['title'] ?? 'Notification';
    final body = notification['body'] ?? '';
    final timestamp = notification['timestamp'];
    final type = notification['type'] ?? 'general';
    final isRead = notification['isRead'] ?? false;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : AppColors.purple.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRead 
            ? AppColors.borderColor.withOpacity(0.3)
            : AppColors.purple.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onNotificationTap?.call(notification),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNotificationIcon(type),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
                          color: AppColors.activityText,
                        ),
                      ),
                      if (body.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          body,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.3,
                          ),
                        ),
                      ],
                      if (timestamp != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _formatTimestamp(timestamp),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (!isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.purple,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(String type) {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case 'new_service_request':
        iconData = Icons.work_outline;
        iconColor = AppColors.purple;
        break;
      case 'service_accepted':
        iconData = Icons.check_circle_outline;
        iconColor = Colors.green;
        break;
      case 'service_completed':
        iconData = Icons.done_all;
        iconColor = Colors.blue;
        break;
      case 'service_cancelled':
        iconData = Icons.cancel_outlined;
        iconColor = Colors.orange;
        break;
      case 'service_started':
        iconData = Icons.play_circle_outline;
        iconColor = Colors.blue;
        break;
      default:
        iconData = Icons.notifications_outlined;
        iconColor = AppColors.textSecondary;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 20,
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'À l\'instant';
      } else if (difference.inMinutes < 60) {
        return 'Il y a ${difference.inMinutes} min';
      } else if (difference.inHours < 24) {
        return 'Il y a ${difference.inHours} h';
      } else if (difference.inDays < 7) {
        return 'Il y a ${difference.inDays} j';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      return 'Date inconnue';
    }
  }
}

/// Widget pour afficher un bouton de notification avec badge
class NotificationButton extends ConsumerWidget {
  final int notificationCount;
  final VoidCallback? onTap;
  final Color? iconColor;

  const NotificationButton({
    super.key,
    required this.notificationCount,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NotificationBadge(
      count: notificationCount,
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          Icons.notifications_outlined,
          color: iconColor ?? AppColors.activityText,
        ),
      ),
    );
  }
}




