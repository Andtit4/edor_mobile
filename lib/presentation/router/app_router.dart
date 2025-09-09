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

// Wrapper pour les routes principales avec bottom navigation
class MainWrapper extends ConsumerWidget {
  final Widget child;

  const MainWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _getCurrentIndex(context),
        onTap: (index) => _onTap(context, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    if (location.startsWith(AppRoutes.messages)) return 1;
    if (location == AppRoutes.profile) return 2;
    return 0; // home par défaut
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.messages);
        break;
      case 2:
        context.go(AppRoutes.profile);
        break;
    }
  }
}
