import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';
import '../../core/theme/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.primaryBlue : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.gray300,
            width: 1,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône
            Icon(
              _getIconData(category.icon),
              size: 28,
              color: isSelected ? Colors.white : AppColors.primaryBlue,
            ),

            const SizedBox(height: 8),

            // Nom de la catégorie
            Text(
              category.name,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color:
                    isSelected
                        ? Colors.white
                        : Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // Nombre de prestataires
            Text(
              '${category.prestataireCount}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color:
                    isSelected
                        ? Colors.white.withOpacity(0.8)
                        : AppColors.gray600,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'build':
        return Icons.build_rounded;
      case 'cleaning_services':
        return Icons.cleaning_services_rounded;
      case 'grass':
        return Icons.grass_rounded;
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'directions_car':
        return Icons.directions_car_rounded;
      case 'electrical_services':
        return Icons.electrical_services_rounded;
      case 'plumbing':
        return Icons.plumbing_rounded;
      case 'face':
        return Icons.face_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}
