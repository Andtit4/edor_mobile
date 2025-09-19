import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/auth_provider.dart';
import '../../providers/upload_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/user.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  
  bool _isLoading = false;
  UserRole _selectedRole = UserRole.client;
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    final authState = ref.read(authProvider);
    final currentUser = authState.user;
    if (currentUser != null) {
      _firstNameController.text = currentUser.firstName ?? '';
      _lastNameController.text = currentUser.lastName ?? '';
      _emailController.text = currentUser.email ?? '';
      _phoneController.text = currentUser.phone ?? '';
      _bioController.text = currentUser.bio ?? '';
      _addressController.text = currentUser.address ?? '';
      _cityController.text = currentUser.city ?? '';
      _postalCodeController.text = currentUser.postalCode ?? '';
      _selectedRole = currentUser.role;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        print('Image sélectionnée: ${image.name}, path: ${image.path}');
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      print('Erreur lors de la sélection de l\'image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la sélection de l\'image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _uploadProfileImage() async {
    if (_selectedImage == null) return;

    final authState = ref.read(authProvider);
    final token = authState.token;
    
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vous devez être connecté pour uploader une image'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final uploadNotifier = ref.read(uploadProvider.notifier);
    final imageUrl = await uploadNotifier.uploadProfileImage(_selectedImage!, token);
    
    print('=== UPLOAD RESULT ===');
    print('Image URL returned: $imageUrl');
    print('==================');
    
    if (imageUrl != null && mounted) {
      print('=== UPDATING PROFILE IMAGE ===');
      print('Image URL to update: $imageUrl');
      
      // Mettre à jour l'utilisateur dans le provider auth
      final authNotifier = ref.read(authProvider.notifier);
      await authNotifier.updateProfileImage(imageUrl);
      
      // Vérifier que l'utilisateur a été mis à jour
      final updatedAuthState = ref.read(authProvider);
      print('Updated user profileImage: ${updatedAuthState.user?.profileImage}');
      print('===============================');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Photo de profil mise à jour avec succès'),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (mounted) {
      final uploadState = ref.read(uploadProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(uploadState.error ?? 'Erreur lors de l\'upload'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Upload de l'image si une nouvelle image est sélectionnée
      if (_selectedImage != null) {
        await _uploadProfileImage();
      }
      
      // Mettre à jour le profil utilisateur
      final authNotifier = ref.read(authProvider.notifier);
      await authNotifier.updateProfile(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        bio: _bioController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        role: _selectedRole,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil mis à jour avec succès'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Modifier le profil',
          style: AppTextStyles.h4.copyWith(
            color: AppColors.activityText,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.activityText),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: Text(
              'Sauvegarder',
              style: AppTextStyles.buttonMedium.copyWith(
                color: _isLoading ? AppColors.gray400 : AppColors.primaryBlue,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo de profil
              Center(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.gray200,
                          border: Border.all(
                            color: AppColors.primaryBlue,
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: _buildProfileImage(),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryBlue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Indicateur d'upload
              Consumer(
                builder: (context, ref, child) {
                  final uploadState = ref.watch(uploadProvider);
                  if (uploadState.isUploading) {
                    return const Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 8),
                          Text('Upload en cours...'),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              
              const SizedBox(height: 30),
              
              // Informations personnelles
              Text(
                'Informations personnelles',
                style: AppTextStyles.h5.copyWith(
                  color: AppColors.activityText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Prénom',
                      controller: _firstNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Le prénom est requis';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      label: 'Nom',
                      controller: _lastNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Le nom est requis';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'L\'email est requis';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Format d\'email invalide';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'Téléphone',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le téléphone est requis';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Type de compte
              Text(
                'Type de compte',
                style: AppTextStyles.h5.copyWith(
                  color: AppColors.activityText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: _buildRoleCard(
                      UserRole.client,
                      'Client',
                      'Je cherche des services',
                      Icons.person,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildRoleCard(
                      UserRole.prestataire,
                      'Prestataire',
                      'Je propose des services',
                      Icons.build,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Informations supplémentaires
              Text(
                'Informations supplémentaires',
                style: AppTextStyles.h5.copyWith(
                  color: AppColors.activityText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'Bio',
                controller: _bioController,
                maxLines: 3,
                hint: 'Parlez-nous de vous...',
              ),
              
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'Adresse',
                controller: _addressController,
                hint: '123 rue de la Paix',
              ),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomTextField(
                      label: 'Ville',
                      controller: _cityController,
                      hint: 'Paris',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      label: 'Code postal',
                      controller: _postalCodeController,
                      hint: '75001',
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Bouton de sauvegarde
              CustomButton(
                text: 'Sauvegarder les modifications',
                onPressed: _isLoading ? null : _saveProfile,
                isLoading: _isLoading,
                size: ButtonSize.large,
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    final authState = ref.read(authProvider);
    final currentUser = authState.user;
    
    // Si une nouvelle image est sélectionnée, l'afficher
    if (_selectedImage != null) {
      // Pour Flutter Web, nous utilisons une approche différente
      return FutureBuilder<Uint8List?>(
        future: _getImageBytes(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Image.memory(
              snapshot.data!,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            );
          } else if (snapshot.hasError) {
            return const Icon(
              Icons.error,
              size: 60,
              color: AppColors.error,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    }
    
    // Sinon, afficher l'image actuelle de l'utilisateur
    if (currentUser?.profileImage != null && currentUser!.profileImage!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: currentUser.profileImage!,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.person,
          size: 60,
          color: AppColors.gray400,
        ),
      );
    }
    
    // Image par défaut
    return const Icon(
      Icons.person,
      size: 60,
      color: AppColors.gray400,
    );
  }

  Future<Uint8List?> _getImageBytes() async {
    if (_selectedImage == null) return null;
    
    try {
      // XFile.readAsBytes() fonctionne sur toutes les plateformes
      return await _selectedImage!.readAsBytes();
    } catch (e) {
      print('Erreur lors de la lecture de l\'image: $e');
      return null;
    }
  }

  Widget _buildRoleCard(UserRole role, String title, String subtitle, IconData icon) {
    final isSelected = _selectedRole == role;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue.withOpacity(0.1) : AppColors.surfaceLight,
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.borderColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryBlue : AppColors.gray400,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.labelLarge.copyWith(
                color: isSelected ? AppColors.primaryBlue : AppColors.activityText,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}