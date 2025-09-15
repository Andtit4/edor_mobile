import 'package:edor/domain/entities/user.dart';
import 'package:edor/presentation/screens/job/job_detail_screen.dart';
import 'package:edor/presentation/screens/job/job_screen.dart';
import 'package:edor/presentation/screens/profile/edit_profile_screeb.dart';
import 'package:edor/presentation/screens/service_offers/service_offers_screen.dart';
import 'package:edor/presentation/screens/service_requests/service_requests_screen.dart';
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
// import '../screens/profile/edit_profile_screen.dart';
import '../widgets/animated_bottom_nav.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
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

          // Jobs
          GoRoute(
            path: AppRoutes.jobs,
            name: AppRoutes.jobsName,
            builder: (context, state) => const JobsScreen(),
          ),

          // Service Offers (for clients) - DÉPLACÉ DANS LE SHELLROUTE
          GoRoute(
            path: AppRoutes.serviceOffers,
            name: AppRoutes.serviceOffersName,
            builder: (context, state) => const ServiceOffersScreen(),
          ),

          // Service Requests (for prestataires) - DÉPLACÉ DANS LE SHELLROUTE
          GoRoute(
            path: AppRoutes.serviceRequests,
            name: AppRoutes.serviceRequestsName,
            builder: (context, state) => const ServiceRequestsScreen(),
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

      // Prestataire Detail (Full Screen) - RESTE EN DEHORS
      GoRoute(
        path: '${AppRoutes.prestataireDetail}/:prestataireId',
        name: AppRoutes.prestataireDetailName,
        builder: (context, state) {
          final prestataireId = state.pathParameters['prestataireId']!;
          return PrestataireDetailScreen(prestataireId: prestataireId);
        },
      ),

      // Job Detail (Full Screen) - RESTE EN DEHORS
      GoRoute(
        path: '${AppRoutes.jobDetail}/:jobId',
        name: AppRoutes.jobDetailName,
        builder: (context, state) {
          final jobId = state.pathParameters['jobId']!;
          return JobDetailScreen(jobId: jobId);
        },
      ),

      // Reservation (Full Screen) - RESTE EN DEHORS
      GoRoute(
        path: '${AppRoutes.reservation}/:prestataireId',
        name: AppRoutes.reservationName,
        builder: (context, state) {
          final prestataireId = state.pathParameters['prestataireId']!;
          return ReservationScreen(prestataireId: prestataireId);
        },
      ),

      // Edit Profile (Full Screen) - RESTE EN DEHORS
      GoRoute(
        path: AppRoutes.editProfile,
        name: AppRoutes.editProfileName,
        builder: (context, state) => const EditProfileScreen(),
      ),

      // SUPPRIMER LA ROUTE JOBS DUPLIQUÉE (lignes 139-143)
    ],
    errorBuilder: (context, state) => Scaffold(
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

// Wrapper pour les routes principales avec bottom navigation animée
class MainWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const MainWrapper({super.key, required this.child});

  @override
  ConsumerState<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends ConsumerState<MainWrapper>
    with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.elasticOut,
    ));
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final authState = ref.watch(authProvider);
        final user = authState.user;
        
        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: Stack(
            children: [
              widget.child,
              // Floating Action Button (only for clients)
              if (user?.role == UserRole.client)
                AnimatedBuilder(
                  animation: _fabAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _fabAnimation.value,
                      child: FloatingActionButton(
                        onPressed: () {
                          context.push(AppRoutes.createRequest);
                        },
                        backgroundColor: const Color(0xFF8B5CF6),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    );
                  },
                ),
            ],
          ),
          bottomNavigationBar: AnimatedBottomNav(
            currentIndex: _getCurrentIndex(context),
            onTap: (index) => _onTap(context, index),
            user: user,
          ),
        );
      },
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    if (location == AppRoutes.serviceRequests) return 1;
    if (location == AppRoutes.serviceOffers) return 1;
    if (location.startsWith(AppRoutes.messages)) return 2;
    if (location == AppRoutes.profile) return 3;
    return 0; // home par défaut
  }

  void _onTap(BuildContext context, int index) {
    final authState = ref.read(authProvider);
    final user = authState.user;
    
    if (user?.role == UserRole.prestataire) {
      switch (index) {
        case 0:
          context.go(AppRoutes.home);
          break;
        case 1:
          context.go(AppRoutes.serviceRequests);
          break;
        case 2:
          context.go(AppRoutes.messages);
          break;
        case 3:
          context.go(AppRoutes.profile);
          break;
      }
    } else {
      switch (index) {
        case 0:
          context.go(AppRoutes.home);
          break;
        case 1:
          context.go(AppRoutes.serviceOffers);
          break;
        case 2:
          context.go(AppRoutes.messages);
          break;
        case 3:
          context.go(AppRoutes.profile);
          break;
      }
    }
  }

  void _showQuickActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Actions rapides',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Actions
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(20),
                children: [
                  _buildQuickAction(
                    context: context,
                    icon: Icons.search,
                    title: 'Rechercher',
                    subtitle: 'Trouver des services',
                    onTap: () {
                      Navigator.pop(context);
                      context.go(AppRoutes.home);
                    },
                  ),
                  _buildQuickAction(
                    context: context,
                    icon: Icons.message,
                    title: 'Messages',
                    subtitle: 'Voir les conversations',
                    onTap: () {
                      Navigator.pop(context);
                      context.go(AppRoutes.messages);
                    },
                  ),
                  _buildQuickAction(
                    context: context,
                    icon: Icons.person,
                    title: 'Profil',
                    subtitle: 'Gérer mon compte',
                    onTap: () {
                      Navigator.pop(context);
                      context.go(AppRoutes.profile);
                    },
                  ),
                  _buildQuickAction(
                    context: context,
                    icon: Icons.work,
                    title: 'Jobs',
                    subtitle: 'Voir les emplois',
                    onTap: () {
                      Navigator.pop(context);
                      context.go(AppRoutes.jobs);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF8B5CF6),
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}