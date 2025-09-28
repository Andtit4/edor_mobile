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
import '../../widgets/phone_field.dart';

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
  String _fullPhoneNumber = '';
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
      _firstNameController.text = currentUser.firstName;
      _lastNameController.text = currentUser.lastName;
      _emailController.text = currentUser.email;
      _phoneController.text = currentUser.phone;
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
        phone: _fullPhoneNumber.isNotEmpty ? _fullPhoneNumber : _phoneController.text.trim(),
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final authState = ref.watch(authProvider);
    final currentUser = authState.user;

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: AppColors.lightGray,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            width: 40,
            height: 40,
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
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.purple,
              size: 18,
            ),
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: _isLoading ? null : _saveProfile,
              style: TextButton.styleFrom(
                backgroundColor: _isLoading ? Colors.grey[300] : AppColors.purple,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Sauvegarder',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: _isLoading ? Colors.grey[600] : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: screenHeight * 0.02),
                
                // Header style Profil
                _buildProfileStyleHeader(currentUser),
                
                SizedBox(height: screenHeight * 0.025),
                
                // Section Photo de profil
                _buildProfileStyleSection(
                  title: 'Photo de profil',
                  items: [
                    _buildProfileImageSection(),
                  ],
                ),
                
                SizedBox(height: screenHeight * 0.02),
                
                // Section Informations personnelles
                _buildProfileStyleSection(
                  title: 'Informations personnelles',
                  items: [
                    _buildProfileStyleTextField(
                      label: 'Prénom',
                      controller: _firstNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Le prénom est requis';
                        }
                        return null;
                      },
                    ),
                    _buildProfileStyleTextField(
                      label: 'Nom',
                      controller: _lastNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Le nom est requis';
                        }
                        return null;
                      },
                    ),
                    _buildProfileStyleTextField(
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
                    _buildPhoneField(),
                  ],
                ),
                
                SizedBox(height: screenHeight * 0.02),
                
                // Section Type de compte
                _buildProfileStyleSection(
                  title: 'Type de compte',
                  items: [
                    _buildRoleSelection(),
                  ],
                ),
                
                SizedBox(height: screenHeight * 0.02),
                
                // Section Informations supplémentaires
                _buildProfileStyleSection(
                  title: 'Informations\n supplémentaires',
                  items: [
                    _buildProfileStyleTextField(
                      label: 'Bio',
                      controller: _bioController,
                      maxLines: 3,
                      hint: 'Parlez-nous de vous...',
                    ),
                    _buildProfileStyleTextField(
                      label: 'Adresse',
                      controller: _addressController,
                      hint: '123 rue de la Paix',
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildProfileStyleTextField(
                            label: 'Ville',
                            controller: _cityController,
                            hint: 'Paris',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildProfileStyleTextField(
                            label: 'Code postal',
                            controller: _postalCodeController,
                            hint: '75001',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                SizedBox(height: screenHeight * 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construit le header style Profil
  Widget _buildProfileStyleHeader(currentUser) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.purple.withOpacity(0.1),
            AppColors.purple.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.purple.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.purple.withOpacity(0.2),
                  AppColors.purple.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.purple.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.edit_outlined,
              color: AppColors.purple,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Modifier le profil',
                  style: AppTextStyles.h4.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mettez à jour vos informations personnelles',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Construit une section style Profil
  Widget _buildProfileStyleSection({
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.borderColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: AppColors.purple.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header de la section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.purple.withOpacity(0.05),
                  AppColors.purple.withOpacity(0.02),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.settings_outlined,
                    color: AppColors.purple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: AppTextStyles.h5.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          
          // Items de la section
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: items,
            ),
          ),
        ],
      ),
    );
  }

  /// Construit la section de photo de profil
  Widget _buildProfileImageSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Photo de profil
          Center(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.lightGray,
                      border: Border.all(
                        color: AppColors.purple.withOpacity(0.3),
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
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.purple,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.purple.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
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
          ),
          
          const SizedBox(height: 16),
          
          // Indicateur d'upload
          Consumer(
            builder: (context, ref, child) {
              final uploadState = ref.watch(uploadProvider);
              if (uploadState.isUploading) {
                return Column(
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.purple),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Upload en cours...',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Appuyez pour changer la photo',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  /// Construit un champ de texte style Profil
  Widget _buildProfileStyleTextField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? hint,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary.withOpacity(0.7),
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(16),
        ),
        style: AppTextStyles.bodyMedium.copyWith(
          color: Colors.black,
          fontSize: 15,
        ),
      ),
    );
  }

  /// Construit le champ téléphone style Profil
  Widget _buildPhoneField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: PhoneField(
        controller: _phoneController,
        label: 'Téléphone',
        hint: 'Entrez votre numéro de téléphone',
        validator: (phone) {
          if (phone == null || phone.number.isEmpty) {
            return 'Le téléphone est requis';
          }
          return null;
        },
        onChanged: (phone) {
          _fullPhoneNumber = phone.completeNumber;
        },
      ),
    );
  }

  /// Construit la sélection de rôle style Profil
  Widget _buildRoleSelection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildProfileStyleRoleCard(
              UserRole.client,
              'Client',
              'Je cherche des services',
              Icons.person_outline,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildProfileStyleRoleCard(
              UserRole.prestataire,
              'Prestataire',
              'Je propose des services',
              Icons.build_outlined,
            ),
          ),
        ],
      ),
    );
  }

  /// Construit une carte de rôle style Profil
  Widget _buildProfileStyleRoleCard(UserRole role, String title, String subtitle, IconData icon) {
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
          color: isSelected ? AppColors.purple.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.purple : AppColors.borderColor.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.purple : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? AppColors.purple : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    final authState = ref.read(authProvider);
    final currentUser = authState.user;
    
    // Si une nouvelle image est sélectionnée, l'afficher
    if (_selectedImage != null) {
      return FutureBuilder<Uint8List?>(
        future: _getImageBytes(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Image.memory(
              snapshot.data!,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            );
          } else if (snapshot.hasError) {
            return const Icon(
              Icons.error,
              size: 50,
              color: AppColors.error,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.purple),
              ),
            );
          }
        },
      );
    }
    
    // Sinon, afficher l'image actuelle de l'utilisateur
    if (currentUser?.profileImage != null && currentUser!.profileImage!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: currentUser.profileImage!,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.purple),
          ),
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.person,
          size: 50,
          color: AppColors.textSecondary,
        ),
      );
    }
    
    // Image par défaut
    return const Icon(
      Icons.person,
      size: 50,
      color: AppColors.textSecondary,
    );
  }

  Future<Uint8List?> _getImageBytes() async {
    if (_selectedImage == null) return null;
    
    try {
      return await _selectedImage!.readAsBytes();
    } catch (e) {
      print('Erreur lors de la lecture de l\'image: $e');
      return null;
    }
  }

}