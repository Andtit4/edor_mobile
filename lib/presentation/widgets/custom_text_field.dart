import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final TextInputAction? textInputAction;
  final void Function()? onTap;
  final bool readOnly;
  final FieldSize size;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.textInputAction,
    this.onTap,
    this.readOnly = false,
    this.size = FieldSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: _getLabelStyle(),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          maxLines: maxLines,
          maxLength: maxLength,
          enabled: enabled,
          textInputAction: textInputAction,
          onTap: onTap,
          readOnly: readOnly,
          style: _getTextStyle(),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: _getHintStyle(),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            counterText: maxLength != null ? null : '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_getBorderRadius()),
              borderSide: BorderSide(
                color: AppColors.borderColor,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_getBorderRadius()),
              borderSide: BorderSide(
                color: AppColors.borderColor,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_getBorderRadius()),
              borderSide: BorderSide(
                color: AppColors.primaryBlue,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_getBorderRadius()),
              borderSide: BorderSide(
                color: AppColors.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_getBorderRadius()),
              borderSide: BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_getBorderRadius()),
              borderSide: BorderSide(
                color: AppColors.gray300,
                width: 1,
              ),
            ),
            filled: true,
            fillColor: enabled ? AppColors.backgroundLight : AppColors.gray100,
            contentPadding: _getPadding(),
          ),
        ),
      ],
    );
  }

  TextStyle _getLabelStyle() {
    switch (size) {
      case FieldSize.small:
        return AppTextStyles.labelSmall.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.activityText,
        );
      case FieldSize.medium:
        return AppTextStyles.labelMedium.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.activityText,
        );
      case FieldSize.large:
        return AppTextStyles.labelLarge.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.activityText,
        );
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case FieldSize.small:
        return AppTextStyles.bodySmall;
      case FieldSize.medium:
        return AppTextStyles.bodyMedium;
      case FieldSize.large:
        return AppTextStyles.bodyLarge;
    }
  }

  TextStyle _getHintStyle() {
    switch (size) {
      case FieldSize.small:
        return AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        );
      case FieldSize.medium:
        return AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        );
      case FieldSize.large:
        return AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textSecondary,
        );
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case FieldSize.small:
        return 8;
      case FieldSize.medium:
        return 12;
      case FieldSize.large:
        return 16;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case FieldSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 10);
      case FieldSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 14);
      case FieldSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 18);
    }
  }
}

enum FieldSize { small, medium, large }
