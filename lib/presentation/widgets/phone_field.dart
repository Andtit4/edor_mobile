// lib/presentation/widgets/phone_field.dart
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final String? Function(PhoneNumber?)? validator;
  final void Function(PhoneNumber)? onChanged;
  final bool enabled;
  final bool readOnly;

  const PhoneField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
        ],
        IntlPhoneField(
          controller: controller,
          initialCountryCode: 'TG', // Togo par défaut
          onChanged: onChanged,
          enabled: enabled,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hint ?? 'Entrez votre numéro de téléphone',
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey[500],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: const Color(0xFF8B5CF6),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          style: AppTextStyles.bodyMedium.copyWith(
            color: const Color(0xFF1F2937),
          ),
          dropdownTextStyle: AppTextStyles.bodyMedium.copyWith(
            color: const Color(0xFF1F2937),
          ),
          searchText: 'Rechercher un pays',
          invalidNumberMessage: 'Numéro de téléphone invalide',
          validator: validator,
          flagsButtonPadding: const EdgeInsets.only(left: 8),
          dropdownIcon: const Icon(
            Icons.arrow_drop_down,
            color: const Color(0xFF8B5CF6),
          ),
        ),
      ],
    );
  }
}

class CompactPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(PhoneNumber?)? validator;
  final void Function(PhoneNumber)? onChanged;
  final bool enabled;
  final bool readOnly;

  const CompactPhoneField({
    super.key,
    required this.controller,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: controller,
      initialCountryCode: 'TG', // Togo par défaut
      onChanged: onChanged,
      enabled: enabled,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: 'Téléphone',
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: Colors.grey[500],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: const Color(0xFF8B5CF6),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
      style: AppTextStyles.bodyMedium.copyWith(
        color: const Color(0xFF1F2937),
      ),
      dropdownTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: const Color(0xFF1F2937),
      ),
      searchText: 'Rechercher un pays',
      invalidNumberMessage: 'Numéro invalide',
      validator: validator,
      flagsButtonPadding: const EdgeInsets.only(left: 8),
      dropdownIcon: const Icon(
        Icons.arrow_drop_down,
        color: const Color(0xFF8B5CF6),
        size: 20,
      ),
    );
  }
}
