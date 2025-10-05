import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../providers/auth_provider.dart';
import '../../providers/service_categories_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/service_categories.dart';
import '../../../domain/entities/service_category.dart';
import '../../../domain/entities/user.dart';
import '../../router/app_routes.dart';
import '../../../core/services/simple_google_auth_service.dart';
import '../../../core/services/firebase_notification_service.dart';

class PrestataireRegistrationScreen extends ConsumerStatefulWidget {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;
  final bool isGoogleAuth;
  final Map<String, dynamic>? googleData;

  const PrestataireRegistrationScreen({
    super.key,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.isGoogleAuth = false,
    this.googleData,
  });

  @override
  ConsumerState<PrestataireRegistrationScreen> createState() => _PrestataireRegistrationScreenState();
}

class _PrestataireRegistrationScreenState extends ConsumerState<PrestataireRegistrationScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _skillsController = TextEditingController();

  ServiceCategory? _selectedCategory;
  List<String> _skills = [];
  bool _isLoading = false;
  bool _isGettingLocation = false;
  Position? _currentPosition;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _descriptionController.dispose();
    _skillsController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Méthode pour obtenir la localisation GPS
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      // Vérifier les permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showLocationError('Les permissions de localisation sont refusées');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showLocationError('Les permissions de localisation sont définitivement refusées');
        return;
      }

      // Obtenir la position actuelle
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
      });

      // Convertir les coordonnées en adresse
      await _getAddressFromCoordinates(position.latitude, position.longitude);

    } catch (e) {
      _showLocationError('Erreur lors de la récupération de la localisation: $e');
    } finally {
      setState(() {
        _isGettingLocation = false;
      });
    }
  }

  // Méthode pour convertir les coordonnées en adresse
  Future<void> _getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        
        // Construire l'adresse complète
        String address = '';
        if (place.locality != null && place.locality!.isNotEmpty) {
          address += place.locality!;
        }
        if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
          if (address.isNotEmpty) address += ', ';
          address += place.administrativeArea!;
        }
        if (place.country != null && place.country!.isNotEmpty) {
          if (address.isNotEmpty) address += ', ';
          address += place.country!;
        }

        setState(() {
          _locationController.text = address;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Localisation détectée: $address'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      }
    } catch (e) {
      _showLocationError('Erreur lors de la conversion des coordonnées: $e');
    }
  }

  // Méthode pour afficher les erreurs de localisation
  void _showLocationError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Future<void> _registerPrestataire() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Veuillez sélectionner un type de prestation'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.isGoogleAuth && widget.googleData != null) {
        // Pour l'authentification Google, utiliser la synchronisation avec le backend
        final backendResponse = await SimpleGoogleAuthService.syncWithBackend(
          widget.googleData!,
          UserRole.prestataire,
          additionalData: {
            'category': _selectedCategory!.name,
            'location': _locationController.text.trim(),
            'description': _descriptionController.text.trim(),
            'skills': _skills,
          },
        );
        
        if (backendResponse != null) {
          final user = User.fromJson(backendResponse['user']);
          final token = backendResponse['token'] as String;
          
          // Mettre à jour l'état d'authentification
          ref.read(authProvider.notifier).state = ref.read(authProvider.notifier).state.copyWith(
            isLoading: false,
            user: user,
            isAuthenticated: true,
            token: token,
            error: null,
          );
          
          // Synchroniser le token FCM avec le backend
          print('🔔 Synchronisation FCM pour Google Auth prestataire...');
          await FirebaseNotificationService().syncTokenWithBackend(token);
        } else {
          throw Exception('Erreur lors de la synchronisation avec le serveur');
        }
      } else {
        // Utiliser l'API d'inscription normale avec les données du prestataire
        await ref.read(authProvider.notifier).register(
          email: widget.email,
          password: widget.password,
          firstName: widget.firstName,
          lastName: widget.lastName,
          phone: widget.phone,
          role: UserRole.prestataire,
          category: _selectedCategory!.name,
          location: _locationController.text.trim(),
          description: _descriptionController.text.trim(),
          skills: _skills,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'inscription: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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

  void _addSkill() {
    final skill = _skillsController.text.trim();
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
        _skillsController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _skills.remove(skill);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final categoriesState = ref.watch(serviceCategoriesProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated && !next.isLoading) {
        context.go(AppRoutes.home);
      } else if (next.error != null && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    });

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
        title: Text(
          widget.isGoogleAuth ? 'Finaliser votre profil' : 'Inscription Prestataire',
          style: AppTextStyles.h3.copyWith(
            color: AppColors.purple,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    
                    // Header style Profil
                    _buildProfileStyleHeader(),
                    
                    SizedBox(height: screenHeight * 0.025),
                    
                    // Section Catégorie de service
                    _buildProfileStyleSection(
                      title: 'Catégorie de service',
                      items: [
                        _buildCategorySelection(categoriesState),
                      ],
                    ),
                    
                    SizedBox(height: screenHeight * 0.02),
                    
                    // Section Localisation
                    _buildProfileStyleSection(
                      title: 'Localisation',
                      items: [
                        _buildLocationField(),
                      ],
                    ),
                    
                    SizedBox(height: screenHeight * 0.02),
                    
                    // Section Description
                    _buildProfileStyleSection(
                      title: 'Description',
                      items: [
                        _buildDescriptionField(),
                      ],
                    ),
                    
                    SizedBox(height: screenHeight * 0.02),
                    
                    // Section Compétences
                    _buildProfileStyleSection(
                      title: 'Compétences',
                      items: [
                        _buildSkillsInput(),
                      ],
                    ),
                    
                    SizedBox(height: screenHeight * 0.03),
                    
                    // Bouton d'inscription
                    _buildRegisterButton(authState),
                    
                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Construit le header style Profil
  Widget _buildProfileStyleHeader() {
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
              Icons.work_outline,
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
                  widget.isGoogleAuth 
                    ? 'Finaliser votre profil prestataire'
                    : 'Inscription Prestataire',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.isGoogleAuth 
                    ? 'Complétez votre profil pour commencer à recevoir des demandes'
                    : 'Sélectionnez votre domaine d\'expertise et décrivez vos services',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Construit une section style profil
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
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.category_outlined,
                    color: AppColors.purple,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          // Contenu de la section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: items,
            ),
          ),
        ],
      ),
    );
  }

  /// Construit la sélection de catégorie
  Widget _buildCategorySelection(ServiceCategoriesState categoriesState) {
    if (categoriesState.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(color: AppColors.purple),
        ),
      );
    }

    if (categoriesState.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'Erreur: ${categoriesState.error}',
            style: const TextStyle(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.8,
      ),
      itemCount: categoriesState.categories.length,
      itemBuilder: (context, index) {
        final category = categoriesState.categories[index];
        final isSelected = _selectedCategory?.id == category.id;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCategory = category;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.purple.withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected ? AppColors.purple : AppColors.borderColor.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: AppColors.purple.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getIconData(category.icon),
                  color: isSelected ? AppColors.purple : AppColors.activityText,
                  size: 30,
                ),
                const SizedBox(height: 8),
                Text(
                  category.name,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: isSelected ? AppColors.purple : AppColors.activityText,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'plumbing': return Icons.plumbing;
      case 'electrical_services': return Icons.electrical_services;
      case 'build': return Icons.build;
      case 'cleaning_services': return Icons.cleaning_services;
      case 'grass': return Icons.grass;
      case 'directions_car': return Icons.directions_car;
      case 'restaurant': return Icons.restaurant;
      case 'face': return Icons.face;
      default: return Icons.work;
    }
  }

  /// Construit le champ de localisation avec GPS
  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _locationController,
                style: AppTextStyles.bodyMedium.copyWith(fontSize: 14, color: AppColors.activityText),
                decoration: InputDecoration(
                  hintText: 'Votre localisation...',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.purple, width: 2),
                  ),
                  contentPadding: const EdgeInsets.all(18),
                  prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.purple),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La localisation est requise';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.purpleGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.purple.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _isGettingLocation ? null : _getCurrentLocation,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _isGettingLocation
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.my_location, color: Colors.white, size: 24),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Appuyez sur l\'icône GPS pour détecter automatiquement votre position',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  /// Construit le champ de description
  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 4,
      keyboardType: TextInputType.multiline,
      style: AppTextStyles.bodyMedium.copyWith(fontSize: 14, color: AppColors.activityText),
      decoration: InputDecoration(
        hintText: 'Décrivez vos services, votre expérience, vos spécialités...',
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.purple, width: 2),
        ),
        contentPadding: const EdgeInsets.all(18),
        prefixIcon: const Icon(Icons.description_outlined, color: AppColors.purple),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'La description est requise';
        }
        if (value.length < 20) {
          return 'La description doit contenir au moins 20 caractères';
        }
        return null;
      },
    );
  }

  /// Construit l'input des compétences
  Widget _buildSkillsInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _skillsController,
                style: AppTextStyles.bodyMedium.copyWith(fontSize: 14, color: AppColors.activityText),
                decoration: InputDecoration(
                  hintText: 'Ajouter une compétence...',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.purple, width: 2),
                  ),
                  contentPadding: const EdgeInsets.all(18),
                  prefixIcon: const Icon(Icons.star_outline, color: AppColors.purple),
                ),
                onFieldSubmitted: (_) => _addSkill(),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.purpleGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.purple.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _addSkill,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(Icons.add, color: Colors.white, size: 24),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        if (_skills.isNotEmpty)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _skills.map((skill) {
              return Chip(
                label: Text(skill, style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
                backgroundColor: AppColors.purple,
                deleteIcon: const Icon(Icons.close, size: 18, color: Colors.white),
                onDeleted: () => _removeSkill(skill),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              );
            }).toList(),
          ),
        const SizedBox(height: 8),
        Text(
          'Ajoutez vos compétences spécifiques (optionnel)',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  /// Construit le bouton d'inscription
  Widget _buildRegisterButton(AuthState authState) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: AppColors.purpleGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _isLoading ? null : _registerPrestataire,
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    widget.isGoogleAuth ? 'Finaliser l\'inscription' : 'Créer mon compte',
                    style: AppTextStyles.buttonMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}