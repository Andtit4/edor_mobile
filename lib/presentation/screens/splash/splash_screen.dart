import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../router/app_routes.dart';
import '../../../core/theme/app_colors.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _progressController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      _scaleController.forward();
      _fadeController.forward();
      
      // Démarrer la barre de progression après 800ms
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        _progressController.forward();
      }
      
      // Navigation automatique après 3 secondes au total
      await Future.delayed(const Duration(milliseconds: 2200));
      if (mounted) {
        _navigateNext();
      }
    }
  }

  void _navigateNext() {
    final authState = ref.read(authProvider);
    
    if (authState.isAuthenticated) {
      context.go(AppRoutes.home);
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                const Spacer(flex: 2),
                
                // Logo principal avec animations
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(35),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, -5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.handyman_rounded,
                            size: 70,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Nom de l'app
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.white, Colors.white70],
                    ).createShader(bounds),
                    child: Text(
                      'EDOR',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                        fontSize: 48,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Slogan
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Votre partenaire services',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white.withOpacity(0.85),
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // Zone de chargement moderne
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      // Barre de progression linéaire stylée
                      Container(
                        width: double.infinity,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 
                                         _progressAnimation.value * 0.85,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Colors.white,
                                        Colors.white70,
                                        Colors.white54,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Texte de chargement
                      AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          final messages = [
                            'Initialisation...',
                            'Chargement des services...',
                            'Configuration de l\'interface...',
                            'Finalisation...',
                          ];
                          
                          final index = (_progressAnimation.value * 
                                        (messages.length - 1)).round();
                          
                          return TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 300),
                            tween: Tween(begin: 0.0, end: 1.0),
                            builder: (context, opacity, child) {
                              return Opacity(
                                opacity: opacity,
                                child: Text(
                                  messages[index.clamp(0, messages.length - 1)],
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.7),
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      // Indicateur de progression en pourcentage
                      AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          final percentage = (_progressAnimation.value * 100).round();
                          return Text(
                            '$percentage%',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white.withOpacity(0.5),
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
