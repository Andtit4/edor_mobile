import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class RoleSelectionDialog extends StatelessWidget {
  final String email;
  final String firstName;
  final String lastName;
  final String? profileImage;
  final Function(UserRole) onRoleSelected;

  const RoleSelectionDialog({
    Key? key,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.profileImage,
    required this.onRoleSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Photo de profil
            if (profileImage != null)
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(profileImage!),
              )
            else
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primaryBlue,
                child: Text(
                  '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}',
                  style: AppTextStyles.h4.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Nom complet
            Text(
              '$firstName $lastName',
              style: AppTextStyles.h4.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.activityText,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            // Email
            Text(
              email,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 24),
            
            // Titre
            Text(
              'Choisissez votre rôle',
              style: AppTextStyles.h5.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.activityText,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Bouton Client
            _buildRoleButton(
              context: context,
              title: 'Client',
              subtitle: 'Rechercher des services',
              icon: Icons.person,
              color: AppColors.primaryBlue,
              onTap: () {
                onRoleSelected(UserRole.client);
              },
            ),
            
            const SizedBox(height: 12),
            
            // Bouton Prestataire
            _buildRoleButton(
              context: context,
              title: 'Prestataire',
              subtitle: 'Offrir des services',
              icon: Icons.work,
              color: AppColors.secondaryGreen,
              onTap: () {
                onRoleSelected(UserRole.prestataire);
              },
            ),
            
            const SizedBox(height: 16),
            
            // Bouton Annuler
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Annuler',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.05),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.h6.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.activityText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
