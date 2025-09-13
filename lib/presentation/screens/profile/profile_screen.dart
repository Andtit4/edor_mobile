import 'package:edor/presentation/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: Text(
                  'PROFILE SETTING',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.activityText,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              // Profile Information Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppColors.activityCardShadow,
                ),
                child: Row(
                  children: [
                    // Profile Picture
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.purple.withOpacity(0.1),
                        border: Border.all(
                          color: AppColors.borderColor,
                          width: 2,
                        ),
                      ),
                      child: currentUser?.email != null
                          ? ClipOval(
                              child: Image.network(
                                currentUser!.email!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildAvatarFallback(currentUser.firstName);
                                },
                              ),
                            )
                          : _buildAvatarFallback(currentUser?.firstName ?? 'U'),
                    ),
                    const SizedBox(width: 16),
                    
                    // User Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentUser?.firstName ?? 'Scarlett Davis',
                            style: AppTextStyles.h5.copyWith(
                              color: AppColors.activityText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currentUser?.email ?? 'Scarlettdavis@gmail.com',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.activityTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // General Settings
              _buildSettingsSection(
                title: 'General',
                items: [
                  _buildSettingsItem(
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    subtitle: 'Change profile picture, number, E-mail',
                    onTap: () {
                      context.push(AppRoutes.editProfile);
                    },
                  ),
                  _buildSettingsItem(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    subtitle: 'Update and strengthen account security',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Change Password - Coming soon')),
                      );
                    },
                  ),
                  _buildSettingsItem(
                    icon: Icons.shield_outlined,
                    title: 'Terms of Use',
                    subtitle: 'Protect your account now',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Terms of Use - Coming soon')),
                      );
                    },
                  ),
                  _buildSettingsItem(
                    icon: Icons.credit_card_outlined,
                    title: 'Add Card',
                    subtitle: 'Securely add payment method',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Add Card - Coming soon')),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Preferences Settings
              _buildSettingsSection(
                title: 'Preferences',
                items: [
                  _buildSettingsItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notification',
                    subtitle: 'Customize your notification preferences',
                    trailing: Switch(
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                      activeColor: AppColors.activityButton,
                    ),
                  ),
                  _buildSettingsItem(
                    icon: Icons.help_outline,
                    title: 'FAQ',
                    subtitle: 'Securely add payment method',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('FAQ - Coming soon')),
                      );
                    },
                  ),
                  _buildSettingsItem(
                    icon: Icons.logout,
                    title: 'Log Out',
                    subtitle: 'Securely log out of Account',
                    titleColor: Colors.pink,
                    iconColor: Colors.pink,
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 100), // Space for bottom navigation
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarFallback(String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'U',
        style: AppTextStyles.h4.copyWith(
          color: AppColors.purple,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              title,
              style: AppTextStyles.h6.copyWith(
                color: AppColors.activityTextSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppColors.activityCardShadow,
            ),
            child: Column(
              children: items,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? titleColor,
    Color? iconColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.activityButton).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? AppColors.activityButton,
                  size: 20,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.buttonMedium.copyWith(
                        color: titleColor ?? AppColors.activityText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.activityTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Trailing widget or arrow
              if (trailing != null)
                trailing
              else if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.activityTextSecondary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Log Out',
          style: AppTextStyles.h5.copyWith(
            color: AppColors.activityText,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.activityTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.activityTextSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authProvider.notifier).logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Log Out',
              style: AppTextStyles.buttonMedium.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}