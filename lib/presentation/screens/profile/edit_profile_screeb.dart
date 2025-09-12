import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/user.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nickNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser != null) {
      _nameController.text = currentUser.name;
      _emailController.text = currentUser.email;
      _phoneController.text = currentUser.phone ?? '';
      _nickNameController.text = currentUser.name.split(' ').last; // Utiliser le nom de famille comme surnom
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nickNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2001, 5, 18),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.purple,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.activityText,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _dateOfBirthController.text = "${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}";
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Simuler la sauvegarde
        await Future.delayed(const Duration(seconds: 1));
        
        // Dans une vraie app, on ferait un appel API ici
        // await ref.read(authProvider.notifier).updateProfile(...)
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating profile: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppColors.activityCardShadow,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.activityText,
                        size: 18,
                      ),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'EDIT PROFILE',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.activityText,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Profile Picture
                      Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.purple.withOpacity(0.1),
                              border: Border.all(
                                color: AppColors.borderColor,
                                width: 3,
                              ),
                            ),
                            child: currentUser?.avatar != null
                                ? ClipOval(
                                    child: Image.network(
                                      currentUser!.avatar!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return _buildAvatarFallback(currentUser.name);
                                      },
                                    ),
                                  )
                                : _buildAvatarFallback(currentUser?.name ?? 'S'),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Change photo - Coming soon')),
                                );
                              },
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.gray700,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Form Fields
                      _buildFormField(
                        label: 'Name',
                        controller: _nameController,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      _buildFormField(
                        label: 'Nick Name',
                        controller: _nickNameController,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter your nick name';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      _buildFormField(
                        label: 'Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter your email';
                          }
                          if (!value!.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        suffixWidget: Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Email verification - Coming soon')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.activityButton,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Verify',
                              style: AppTextStyles.buttonSmall.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      _buildFormField(
                        label: 'Phone Number',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      _buildFormField(
                        label: 'Date of birth',
                        controller: _dateOfBirthController,
                        readOnly: true,
                        onTap: _selectDateOfBirth,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please select your date of birth';
                          }
                          return null;
                        },
                        suffixIcon: Icons.calendar_today_outlined,
                      ),

                      const SizedBox(height: 40),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  'Save Changes',
                                  style: AppTextStyles.buttonLarge.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 100), // Space for bottom navigation
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarFallback(String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'S',
        style: AppTextStyles.h1.copyWith(
          color: AppColors.purple,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
    Widget? suffixWidget,
    IconData? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.activityText,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          validator: validator,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.activityText,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.purple, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            suffixIcon: suffixIcon != null
                ? Icon(
                    suffixIcon,
                    color: AppColors.activityTextSecondary,
                    size: 20,
                  )
                : null,
            suffix: suffixWidget,
          ),
        ),
      ],
    );
  }
}