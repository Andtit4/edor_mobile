import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../providers/auth_provider.dart';
import '../../providers/service_categories_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/service_category.dart';
import '../../../domain/entities/user.dart';
import '../../router/app_routes.dart';
import '../../../core/services/simple_google_auth_service.dart';

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
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
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
          category: _selectedCategory!.name, // Nom de la catégorie sélectionnée
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.purple),
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
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
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
                      // Titre avec gradient
                      _buildGradientTitle(),
                      
                      const SizedBox(height: 20),
                      
                      // Sous-titre
                      _buildSubtitle(),
                      
                      const SizedBox(height: 30),
                      
                      // Container principal
                      _buildMainContainer(categoriesState),
                      
                      const SizedBox(height: 30),
                      
                      // Bouton d'inscription
                      _buildRegisterButton(authState),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientTitle() {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          AppColors.purple,
          AppColors.purple.withOpacity(0.8),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        'Complétez votre profil',
        style: AppTextStyles.h2.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 24,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      widget.isGoogleAuth 
        ? 'Complétez votre profil prestataire pour commencer à recevoir des demandes'
        : 'Sélectionnez votre domaine d\'expertise et décrivez vos services',
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondary,
        fontSize: 16,
        height: 1.4,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMainContainer(ServiceCategoriesState categoriesState) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppColors.purple.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.8),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sélection du type de prestation
          _buildServiceTypeSelection(categoriesState),
          
          const SizedBox(height: 28),
          
          // Localisation
          _buildLocationField(),
          
          const SizedBox(height: 20),
          
          // Description
          _buildDescriptionField(),
          
          const SizedBox(height: 20),
          
          // Tarif horaire
          _buildPriceField(),
          
          const SizedBox(height: 20),
          
          // Compétences
          _buildSkillsSection(),
        ],
      ),
    );
  }

  Widget _buildServiceTypeSelection(ServiceCategoriesState categoriesState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type de prestation *',
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        
        if (categoriesState.isLoading)
          const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.purple),
            ),
          )
        else if (categoriesState.error != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.error.withOpacity(0.3)),
            ),
            child: Text(
              categoriesState.error!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.error,
              ),
            ),
          )
        else
          _buildCategoriesGrid(categoriesState.categories),
      ],
    );
  }

  Widget _buildCategoriesGrid(List<ServiceCategory> categories) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = _selectedCategory?.id == category.id;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCategory = category;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        AppColors.purple.withOpacity(0.1),
                        AppColors.purple.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : Colors.white,
              border: Border.all(
                color: isSelected ? AppColors.purple : AppColors.borderColor.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: AppColors.purple.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColors.purpleGradient : null,
                    color: isSelected ? null : AppColors.lightGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIconForCategory(category.icon),
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  category.name,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: isSelected ? AppColors.purple : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${category.prestataireCount} prestataires',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getIconForCategory(String iconName) {
    switch (iconName) {
      case 'build':
        return Icons.build;
      case 'cleaning_services':
        return Icons.cleaning_services;
      case 'grass':
        return Icons.grass;
      case 'restaurant':
        return Icons.restaurant;
      case 'directions_car':
        return Icons.directions_car;
      case 'electrical_services':
        return Icons.electrical_services;
      case 'plumbing':
        return Icons.plumbing;
      case 'face':
        return Icons.face;
      default:
        return Icons.work;
    }
  }

  Widget _buildLocationField() {
    return _buildTextField(
      controller: _locationController,
      label: 'Localisation *',
      hint: 'Ville, région où vous travaillez',
      prefixIcon: Icons.location_on_outlined,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'La localisation est requise';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description de vos services *',
          style: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _descriptionController,
          maxLines: 4,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'La description est requise';
            }
            if (value.length < 20) {
              return 'La description doit contenir au moins 20 caractères';
            }
            return null;
          },
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 14,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: 'Décrivez vos services, votre expérience, vos spécialités...',
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: AppColors.borderColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: AppColors.borderColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: AppColors.purple,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.all(18),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceField() {
    return _buildTextField(
      controller: _priceController,
      label: 'Tarif horaire (optionnel)',
      hint: 'Ex: 25.00',
      prefixIcon: Icons.euro_outlined,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final price = double.tryParse(value);
          if (price == null || price < 0) {
            return 'Veuillez entrer un prix valide';
          }
        }
        return null;
      },
    );
  }

  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Compétences (optionnel)',
          style: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        
        // Champ pour ajouter une compétence
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _skillsController,
                decoration: InputDecoration(
                  hintText: 'Ajouter une compétence',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: AppColors.borderColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: AppColors.borderColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: AppColors.purple,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(18),
                ),
                onFieldSubmitted: (_) => _addSkill(),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.purpleGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: _addSkill,
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Liste des compétences
        if (_skills.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _skills.map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: AppColors.purpleGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      skill,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _removeSkill(skill),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    IconData? prefixIcon,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 14,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            prefixIcon: prefixIcon != null
                ? Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: AppColors.purpleGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.purple.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      prefixIcon,
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                : null,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: AppColors.borderColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: AppColors.borderColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: AppColors.purple,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton(AuthState authState) {
    return Container(
      height: 58,
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
          onTap: (_isLoading || authState.isLoading) ? null : _registerPrestataire,
          child: Container(
            alignment: Alignment.center,
            child: (_isLoading || authState.isLoading)
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Créer mon compte prestataire',
                    style: AppTextStyles.buttonLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
