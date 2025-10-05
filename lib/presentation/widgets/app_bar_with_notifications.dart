import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../router/app_routes.dart';
import 'notification_badge.dart';

class AppBarWithNotifications extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showNotificationButton;
  final int notificationCount;

  const AppBarWithNotifications({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showNotificationButton = true,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: AppColors.lightGray,
      elevation: 0,
      leading: leading,
      title: Text(
        title,
        style: AppTextStyles.h3.copyWith(
          color: AppColors.purple,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      actions: [
        if (showNotificationButton) ...[
          NotificationButton(
            notificationCount: notificationCount,
            onTap: () => context.pushNamed(AppRoutes.notificationsName),
          ),
          const SizedBox(width: 8),
        ],
        if (actions != null) ...actions!,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// AppBar personnalisé pour la page d'accueil
class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const HomeAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: AppColors.lightGray,
      elevation: 0,
      title: Text(
        title,
        style: AppTextStyles.h3.copyWith(
          color: AppColors.purple,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      actions: [
        NotificationButton(
          notificationCount: 3, // TODO: Récupérer le vrai nombre depuis le provider
          onTap: () => context.pushNamed(AppRoutes.notificationsName),
        ),
        const SizedBox(width: 8),
        if (actions != null) ...actions!,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}




