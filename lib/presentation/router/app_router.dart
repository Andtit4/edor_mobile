import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/prestataire_detail/prestataire_detail_screen.dart';
import '../screens/reservation/reservation_screen.dart';
import '../screens/messages/messages_screen.dart';
import '../screens/messages/chat_screen.dart';
import '../screens/profile/profile_screen.dart';
import 'app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isLoading = authState.isLoading;

      // Pendant le chargement, rester sur splash
      if (isLoading) {
        return AppRoutes.splash;
      }

      // Routes publiques (accessibles sans authentification)
      final publicRoutes = [
        AppRoutes.splash,
        AppRoutes.login,
        AppRoutes.register,
      ];

      final isPublicRoute = publicRoutes.contains(state.matchedLocation);

      // Si non authentifié et sur une route privée, rediriger vers login
      if (!isAuthenticated && !isPublicRoute) {
        return AppRoutes.login;
      }

      // Si authentifié et sur splash ou login, rediriger vers home
      if (isAuthenticated &&
          (state.matchedLocation == AppRoutes.splash ||
              state.matchedLocation == AppRoutes.login)) {
        return AppRoutes.home;
      }

      return null; // Pas de redirection
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splashName,
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth Routes
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.loginName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: AppRoutes.registerName,
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main App Routes
      ShellRoute(
        builder: (context, state, child) {
          return MainWrapper(child: child);
        },
        routes: [
          // Home
          GoRoute(
            path: AppRoutes.home,
            name: AppRoutes.homeName,
            builder: (context, state) => const HomeScreen(),
          ),

          // Messages
          GoRoute(
            path: AppRoutes.messages,
            name: AppRoutes.messagesName,
            builder: (context, state) => const MessagesScreen(),
            routes: [
              // Chat
              GoRoute(
                path: 'chat/:conversationId',
                name: AppRoutes.chatName,
                builder: (context, state) {
                  final conversationId =
                      state.pathParameters['conversationId']!;
                  return ChatScreen(conversationId: conversationId);
                },
              ),
            ],
          ),

          // Profile
          GoRoute(
            path: AppRoutes.profile,
            name: AppRoutes.profileName,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Prestataire Detail (Full Screen)
      GoRoute(
        path: '${AppRoutes.prestataireDetail}/:prestataireId',
        name: AppRoutes.prestataireDetailName,
        builder: (context, state) {
          final prestataireId = state.pathParameters['prestataireId']!;
          return PrestataireDetailScreen(prestataireId: prestataireId);
        },
      ),

      // Reservation (Full Screen)
      GoRoute(
        path: '${AppRoutes.reservation}/:prestataireId',
        name: AppRoutes.reservationName,
        builder: (context, state) {
          final prestataireId = state.pathParameters['prestataireId']!;
          return ReservationScreen(prestataireId: prestataireId);
        },
      ),
    ],
    errorBuilder:
        (context, state) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Page non trouvée',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'La page que vous cherchez n\'existe pas.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go(AppRoutes.home),
                  child: const Text('Retour à l\'accueil'),
                ),
              ],
            ),
          ),
        ),
  );
});

// Wrapper pour les routes principales avec bottom navigation moderne
class MainWrapper extends ConsumerWidget {
  final Widget child;

  const MainWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context: context,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Home',
                  isActive: _getCurrentIndex(context) == 0,
                  onTap: () => context.go(AppRoutes.home),
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.work_outline,
                  activeIcon: Icons.work,
                  label: 'Jobs',
                  isActive: _getCurrentIndex(context) == 1,
                  onTap: () {
                    // TODO: Naviguer vers les jobs
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Jobs section - Coming soon')),
                    );
                  },
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.message_outlined,
                  activeIcon: Icons.message,
                  label: 'Message',
                  isActive: _getCurrentIndex(context) == 2,
                  onTap: () => context.go(AppRoutes.messages),
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.more_horiz_outlined,
                  activeIcon: Icons.more_horiz,
                  label: 'More',
                  isActive: _getCurrentIndex(context) == 3,
                  onTap: () => context.go(AppRoutes.profile),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.purple.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.purple : AppColors.activityTextSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isActive ? AppColors.purple : AppColors.activityTextSecondary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    if (location.startsWith(AppRoutes.messages)) return 2;
    if (location == AppRoutes.profile) return 3;
    return 0; // home par défaut
  }
}