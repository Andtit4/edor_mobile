import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/user.dart';
import '../../router/app_routes.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  UserRole _selectedRole = UserRole.client;

  // Nouvelles variables pour les prestataires
  String? _selectedCategory;
  String? _selectedLocation;
  String _description = '';
  double _pricePerHour = 0.0;
  List<String> _skills = [];
  final TextEditingController _skillsController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _skillsController.dispose(); // Ajouter cette ligne
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(authProvider.notifier).register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim(),
        role: _selectedRole,
        category: _selectedCategory,
        location: _selectedLocation,
        description: _description,
        pricePerHour: _pricePerHour,
        skills: _skills,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    ref.listen<AuthState>(authProvider, (previous, next) {
      print('🔵 RegisterScreen - AuthState changed:');
      print('   Previous: isAuthenticated=${previous?.isAuthenticated}, isLoading=${previous?.isLoading}');
      print('   Next: isAuthenticated=${next.isAuthenticated}, isLoading=${next.isLoading}');
      print('   Error: ${next.error}');
      
      if (next.isAuthenticated && !next.isLoading) {
        print('✅ RegisterScreen - User authenticated, redirecting to home');
        context.go(AppRoutes.home);
      } else if (next.error != null && !next.isLoading) {
        print('🔴 RegisterScreen - Error: ${next.error}');
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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06, // 6% de la largeur
                      vertical: 20,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Espace flexible pour centrer le contenu
                          SizedBox(height: screenHeight * 0.03),
                          
                          // Logo animé
                          _buildAnimatedLogo(),
                          
                          SizedBox(height: screenHeight * 0.025),
                          
                          // Titre avec gradient
                          _buildGradientTitle(),
                          
                          SizedBox(height: screenHeight * 0.01),
                          
                          // Sous-titre
                          _buildSubtitle(),
                          
                          SizedBox(height: screenHeight * 0.035),
                          
                          // Container principal avec glassmorphism
                          _buildMainContainer(authState),
                          
                          SizedBox(height: screenHeight * 0.02),
                          
                          // Lien vers la connexion
                          _buildLoginLink(),
                          
                          // Espace flexible pour pousser le contenu vers le haut
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Nouveaux widgets améliorés
  Widget _buildAnimatedLogo() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.purple.withOpacity(0.1),
                  AppColors.purple.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: AppColors.purple.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.purple.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 20,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_add_alt_1_outlined,
              size: 45,
              color: AppColors.purple,
            ),
          ),
        );
      },
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
        'Créer un compte',
        style: AppTextStyles.h2.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 28,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Rejoignez notre communauté de services',
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondary,
        fontSize: 16,
        height: 1.4,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMainContainer(AuthState authState) {
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
          // Section inscription rapide
          _buildQuickSignupSection(),
          
          const SizedBox(height: 28),
          
          // Divider stylisé
          _buildEnhancedDivider(),
          
          const SizedBox(height: 28),
          
          // Sélection de rôle
          _buildRoleSelection(),
          
          const SizedBox(height: 28),
          
          // Informations personnelles
          _buildPersonalInfoSection(),
          
          const SizedBox(height: 28),
          
          // Bouton d'inscription
          _buildEnhancedRegisterButton(authState),
        ],
      ),
    );
  }

  Widget _buildQuickSignupSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Inscription rapide',
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildEnhancedSocialButton(
              icon: Icons.g_mobiledata,
              color: const Color(0xFFDB4437),
              onTap: () {
                ref.read(authProvider.notifier).signInWithGoogle(role: _selectedRole, context: context);
              },
            ),
            
          ],
        ),
      ],
    );
  }

  Widget _buildEnhancedDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.borderColor,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'OU',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.borderColor,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type de compte',
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildEnhancedRoleCard(
                UserRole.client,
                'Client',
                'Je cherche des services',
                Icons.person_outline,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildEnhancedRoleCard(
                UserRole.prestataire,
                'Prestataire',
                'Je propose mes services',
                Icons.build_outlined,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informations personnelles',
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 20),
        
        // Prénom et Nom
        Row(
          children: [
            Expanded(
              child: _buildEnhancedTextField(
                controller: _firstNameController,
                label: 'Prénom',
                hint: 'Votre prénom',
                prefixIcon: Icons.person_outline,
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
              child: _buildEnhancedTextField(
                controller: _lastNameController,
                label: 'Nom',
                hint: 'Votre nom',
                prefixIcon: Icons.person_outline,
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

        const SizedBox(height: 20),

        // Email
        _buildEnhancedTextField(
          controller: _emailController,
          label: 'Email',
          hint: 'votre@email.com',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
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

        const SizedBox(height: 20),

        // Téléphone
        _buildEnhancedTextField(
          controller: _phoneController,
          label: 'Téléphone',
          hint: 'Votre numéro',
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Le téléphone est requis';
            }
            return null;
          },
        ),

        const SizedBox(height: 20),

        // Mot de passe
        _buildEnhancedTextField(
          controller: _passwordController,
          label: 'Mot de passe',
          hint: 'Minimum 6 caractères',
          obscureText: _obscurePassword,
          prefixIcon: Icons.lock_outline,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: AppColors.textSecondary,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Le mot de passe est requis';
            }
            if (value.length < 6) {
              return 'Le mot de passe doit contenir au moins 6 caractères';
            }
            return null;
          },
        ),

        const SizedBox(height: 20),

        // Confirmation mot de passe
        _buildEnhancedTextField(
          controller: _confirmPasswordController,
          label: 'Confirmer le mot de passe',
          hint: 'Répétez votre mot de passe',
          obscureText: _obscureConfirmPassword,
          prefixIcon: Icons.lock_outline,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: AppColors.textSecondary,
            ),
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'La confirmation est requise';
            }
            if (value != _passwordController.text) {
              return 'Les mots de passe ne correspondent pas';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildEnhancedRegisterButton(AuthState authState) {
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
          onTap: authState.isLoading ? null : _register,
          child: Container(
            alignment: Alignment.center,
            child: authState.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Créer mon compte',
                    style: AppTextStyles.buttonLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Vous avez déjà un compte ? ',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
          TextButton(
            onPressed: () => context.go(AppRoutes.login),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            child: Text(
              'Se connecter',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.purple,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedTextField({
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

  Widget _buildEnhancedRoleCard(UserRole role, String title, String subtitle, IconData icon) {
    final isSelected = _selectedRole == role;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
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
          children: [
            
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.labelLarge.copyWith(
                color: isSelected ? AppColors.purple : Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * .7,
        height: MediaQuery.of(context).size.height * .08,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
        child: Icon(
          icon,
          color: color,
          size: 26,
        ),
      ),
    );
  }

}