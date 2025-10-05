import 'package:flutter/material.dart';
import '../../core/constants/service_categories.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Widget pour sélectionner une catégorie de service
class CategorySelector extends StatelessWidget {
  final String? selectedCategoryId;
  final Function(String?) onChanged;
  final String? label;
  final bool showAllCategories;
  final List<String>? allowedCategories;

  const CategorySelector({
    super.key,
    required this.selectedCategoryId,
    required this.onChanged,
    this.label,
    this.showAllCategories = true,
    this.allowedCategories,
  });

  @override
  Widget build(BuildContext context) {
    final categories = _getAvailableCategories();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.activityText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
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
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCategoryId,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              hint: Text(
                'Sélectionnez une catégorie',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              items: categories.map((categoryId) {
                final categoryName = ServiceCategories.idToName(categoryId) ?? categoryId;
                return DropdownMenuItem(
                  value: categoryId,
                  child: Text(
                    categoryName,
                    style: AppTextStyles.bodyMedium,
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  List<String> _getAvailableCategories() {
    if (allowedCategories != null) {
      return allowedCategories!;
    }
    
    if (showAllCategories) {
      return ServiceCategories.categoryIds;
    }
    
    return ServiceCategories.mainCategories.map((cat) => cat.id).toList();
  }
}

/// Widget pour afficher une catégorie sous forme de chip
class CategoryChip extends StatelessWidget {
  final String categoryId;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool showIcon;

  const CategoryChip({
    super.key,
    required this.categoryId,
    this.isSelected = false,
    this.onTap,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final categoryInfo = ServiceCategories.getCategoryById(categoryId);
    if (categoryInfo == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
            ? AppColors.purple 
            : AppColors.purple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
              ? AppColors.purple 
              : AppColors.purple.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              Icon(
                _getIconData(categoryInfo.icon),
                size: 16,
                color: isSelected ? Colors.white : AppColors.purple,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              categoryInfo.name,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? Colors.white : AppColors.purple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'plumbing':
        return Icons.plumbing;
      case 'electrical_services':
        return Icons.electrical_services;
      case 'build':
        return Icons.build;
      case 'cleaning_services':
        return Icons.cleaning_services;
      case 'grass':
        return Icons.grass;
      case 'directions_car':
        return Icons.directions_car;
      case 'restaurant':
        return Icons.restaurant;
      case 'face':
        return Icons.face;
      case 'format_paint':
        return Icons.format_paint;
      case 'ac_unit':
        return Icons.ac_unit;
      case 'security':
        return Icons.security;
      case 'more_horiz':
        return Icons.more_horiz;
      default:
        return Icons.category;
    }
  }
}

/// Widget pour afficher une grille de catégories
class CategoryGrid extends StatelessWidget {
  final String? selectedCategoryId;
  final Function(String?) onCategorySelected;
  final bool showAllCategories;
  final List<String>? allowedCategories;

  const CategoryGrid({
    super.key,
    this.selectedCategoryId,
    required this.onCategorySelected,
    this.showAllCategories = true,
    this.allowedCategories,
  });

  @override
  Widget build(BuildContext context) {
    final categories = _getAvailableCategories();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((categoryId) {
        return CategoryChip(
          categoryId: categoryId,
          isSelected: selectedCategoryId == categoryId,
          onTap: () => onCategorySelected(
            selectedCategoryId == categoryId ? null : categoryId,
          ),
        );
      }).toList(),
    );
  }

  List<String> _getAvailableCategories() {
    if (allowedCategories != null) {
      return allowedCategories!;
    }
    
    if (showAllCategories) {
      return ServiceCategories.categoryIds;
    }
    
    return ServiceCategories.mainCategories.map((cat) => cat.id).toList();
  }
}

/// Widget pour afficher les informations d'une catégorie
class CategoryInfoCard extends StatelessWidget {
  final String categoryId;
  final VoidCallback? onTap;

  const CategoryInfoCard({
    super.key,
    required this.categoryId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final categoryInfo = ServiceCategories.getCategoryById(categoryId);
    if (categoryInfo == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getIconData(categoryInfo.icon),
                color: AppColors.purple,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoryInfo.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.activityText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    categoryInfo.description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'plumbing':
        return Icons.plumbing;
      case 'electrical_services':
        return Icons.electrical_services;
      case 'build':
        return Icons.build;
      case 'cleaning_services':
        return Icons.cleaning_services;
      case 'grass':
        return Icons.grass;
      case 'directions_car':
        return Icons.directions_car;
      case 'restaurant':
        return Icons.restaurant;
      case 'face':
        return Icons.face;
      case 'format_paint':
        return Icons.format_paint;
      case 'ac_unit':
        return Icons.ac_unit;
      case 'security':
        return Icons.security;
      case 'more_horiz':
        return Icons.more_horiz;
      default:
        return Icons.category;
    }
  }
}




