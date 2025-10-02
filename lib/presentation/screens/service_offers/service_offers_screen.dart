import 'package:edor/presentation/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/service_request.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/entities/prestataire.dart';
import '../../../domain/entities/conversation.dart';
import '../../providers/service_offer_provider.dart';
import '../../providers/service_request_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/prestataire_provider.dart';
import '../../providers/message_provider.dart';
import '../../providers/price_negotiation_provider.dart';
import 'negotiation_widgets.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/profile_avatar.dart';
import '../../widgets/image_gallery.dart';
import '../../widgets/photo_viewer.dart';
import '../ai_matching/ai_matching_screen.dart';
// import '../../../router/app_routes.dart';

class ServiceOffersScreen extends ConsumerStatefulWidget {
  const ServiceOffersScreen({super.key});

  @override
  ConsumerState<ServiceOffersScreen> createState() =>
      _ServiceOffersScreenState();
}

class _ServiceOffersScreenState extends ConsumerState<ServiceOffersScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Charger les données au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(serviceOfferProvider.notifier).loadOffers();
      ref
          .read(prestatairesProvider.notifier)
          .loadPrestataires(); // Charger les prestataires
      ref
          .read(serviceRequestProvider.notifier)
          .loadAllRequests(); // Charger toutes les demandes
      _loadMyRequests(); // Charger les demandes du client
      _loadMyOffers(); // Charger les offres du prestataire
      _loadAssignedRequests(); // Charger les demandes assignées au prestataire
      _loadClientNegotiations(); // Charger les négociations du client
    });
  }

  void _loadMyRequests() async {
    final authState = ref.read(authProvider);
    var token = authState.token;

    print('=== LOAD MY REQUESTS CALLED ===');
    print('User: ${authState.user?.firstName} ${authState.user?.lastName}');
    print('Role: ${authState.user?.role}');
    print('Token exists: ${token != null}');

    // Si le token n'est pas disponible, essayer de le rafraîchir
    if (token == null && authState.user?.role == UserRole.client) {
      print('Token not available, trying to refresh...');
      await ref.read(authProvider.notifier).refreshToken();
      final newAuthState = ref.read(authProvider);
      token = newAuthState.token;
      print('Token after refresh: ${token != null}');
    }

    if (token != null && authState.user?.role == UserRole.client) {
      print('Loading my requests...');
      ref.read(serviceRequestProvider.notifier).loadMyRequests(token);
    } else {
      print('Not loading requests - conditions not met');
    }
  }

  void _loadMyOffers() {
    final authState = ref.read(authProvider);
    final token = authState.token;

    if (token != null && authState.user?.role == UserRole.prestataire) {
      ref.read(serviceOfferProvider.notifier).loadMyOffers(token);
    }
  }

  void _loadAssignedRequests() {
    final authState = ref.read(authProvider);
    final token = authState.token;

    if (token != null && authState.user?.role == UserRole.prestataire) {
      ref.read(serviceRequestProvider.notifier).loadAssignedRequests(token);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Header
              _buildEnhancedHeader(),

              // Search Bar
              _buildEnhancedSearchBar(),

              // Tab Bar
              _buildEnhancedTabBar(),

              // Content
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPrestatairesList(), // Premier onglet
                    user?.role == UserRole.prestataire
                        ? _buildAllRequestsList() // Pour les prestataires - toutes les demandes
                        : NegotiationWidgets.buildNegotiationsList(
                            ref), // Pour les clients - négociations
                    user?.role == UserRole.prestataire
                        ? _buildAssignedRequestsList() // Pour les prestataires - demandes assignées
                        : _buildMyRequestsList(
                            []), // Pour les clients - leurs demandes
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.createRequest),
        backgroundColor: const Color(0xFF8B5CF6),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// Header moderne avec glassmorphism
  Widget _buildEnhancedHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.06,
        vertical: 24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.purple.withOpacity(0.1),
            AppColors.purple.withOpacity(0.05),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: AppColors.purpleGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.purple.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.work_outline,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trouvez votre',
                            style: AppTextStyles.h3.copyWith(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            'prestataire',
                            style: AppTextStyles.h2.copyWith(
                              color: const Color(0xFF1F2937),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
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
            child: Icon(
              Icons.notifications_outlined,
              color: AppColors.purple,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  /// Barre de recherche moderne avec glassmorphism
  Widget _buildEnhancedSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.06,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Rechercher un prestataire...',
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
          ),
          prefixIcon: Container(
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
            child: const Icon(
              Icons.search,
              color: Colors.white,
              size: 20,
            ),
          ),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.tune,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  /// Filter chips modernes avec animations

  /// TabBar moderne avec glassmorphism
  Widget _buildEnhancedTabBar() {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.06,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.9),
            Colors.white.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.purple.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: AppColors.purpleGradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.purple.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
        unselectedLabelStyle: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        tabs: user?.role == UserRole.prestataire
            ? [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Prestataires',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Demandes',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Mes demandes',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            : [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Prestataires',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Offres',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          'Mes demandes',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
      ),
    );
  }

  Widget _buildPrestatairesList() {
    return Consumer(
      builder: (context, ref, child) {
        final prestatairesState = ref.watch(prestatairesProvider);

        if (prestatairesState.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (prestatairesState.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Erreur de chargement',
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.red[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  prestatairesState.error!,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.red[500],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.read(prestatairesProvider.notifier).loadPrestataires();
                  },
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        if (prestatairesState.prestataires.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucun prestataire disponible',
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Aucun prestataire n\'est actuellement disponible.',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // Afficher tous les prestataires
        final allPrestataires = prestatairesState.prestataires;

        if (allPrestataires.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucun prestataire trouvé',
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Aucun prestataire ne correspond à vos critères de recherche.',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.06,
            vertical: 20,
          ),
          itemCount: allPrestataires.length,
          itemBuilder: (context, index) {
            final prestataire = allPrestataires[index];
            return _buildPrestataireCard(prestataire);
          },
        );
      },
    );
  }

  Widget _buildAllRequestsList() {
    return Consumer(
      builder: (context, ref, child) {
        final authState = ref.watch(authProvider);
        final requestState = ref.watch(serviceRequestProvider);

        // Vérifier que l'utilisateur est un prestataire
        if (authState.user?.role != UserRole.prestataire) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_outline,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Cette section est réservée aux prestataires',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        if (requestState.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (requestState.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Erreur de chargement',
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.red[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  requestState.error!,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.red[500],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.read(serviceRequestProvider.notifier).loadAllRequests();
                  },
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        if (requestState.allRequests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Aucune demande disponible',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Il n\'y a pas de demandes de service pour le moment',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(serviceRequestProvider.notifier).loadAllRequests();
                  },
                  icon: Icon(Icons.refresh),
                  label: Text('Actualiser'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.06,
            vertical: 20,
          ),
          itemCount: requestState.allRequests.length,
          itemBuilder: (context, index) {
            final request = requestState.allRequests[index];
            return _buildAllRequestCard(request);
          },
        );
      },
    );
  }

  Widget _buildMyRequestsList(List<ServiceRequest> requests) {
    return Consumer(
      builder: (context, ref, child) {
        final authState = ref.watch(authProvider);
        final requestState = ref.watch(serviceRequestProvider);

        // Debug logs
        print('=== DEBUG MY REQUESTS ===');
        print('User role: ${authState.user?.role}');
        print('Is loading: ${requestState.isLoading}');
        print('Error: ${requestState.error}');
        print('My requests count: ${requestState.myRequests.length}');
        print('Requests passed to widget: ${requests.length}');
        for (var request in requestState.myRequests) {
          print(
              'Request: ${request.title} - ${request.status} - ${request.clientId}');
        }

        // Vérifier que l'utilisateur est un client
        if (authState.user?.role != UserRole.client) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_outline,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Cette section est réservée aux clients',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        if (requestState.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (requestState.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Erreur de chargement',
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.red[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  requestState.error!,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.red[500],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final token = authState.token;
                    if (token != null) {
                      ref
                          .read(serviceRequestProvider.notifier)
                          .loadMyRequests(token);
                    }
                  },
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        if (requestState.myRequests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Vous n\'avez envoyé aucune demande',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Créez votre première demande de service',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    var token = authState.token;
                    if (token == null) {
                      await ref.read(authProvider.notifier).refreshToken();
                      final newAuthState = ref.read(authProvider);
                      token = newAuthState.token;
                    }
                    if (token != null) {
                      ref
                          .read(serviceRequestProvider.notifier)
                          .loadMyRequests(token);
                    }
                  },
                  icon: Icon(Icons.refresh),
                  label: Text('Actualiser'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.06,
            vertical: 20,
          ),
          itemCount: requestState.myRequests.length,
          itemBuilder: (context, index) {
            final request = requestState.myRequests[index];
            return _buildRequestCard(request);
          },
        );
      },
    );
  }

  Widget _buildAssignedRequestsList() {
    return Consumer(
      builder: (context, ref, child) {
        final authState = ref.watch(authProvider);
        final requestState = ref.watch(serviceRequestProvider);

        // Vérifier que l'utilisateur est un prestataire
        if (authState.user?.role != UserRole.prestataire) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_outline,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Cette section est réservée aux prestataires',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        if (requestState.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (requestState.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Erreur de chargement',
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.red[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  requestState.error!,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.red[500],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final token = authState.token;
                    if (token != null) {
                      ref
                          .read(serviceRequestProvider.notifier)
                          .loadAssignedRequests(token);
                    }
                  },
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        if (requestState.assignedRequests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Aucune demande assignée',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Vous n\'avez pas encore de demandes assignées',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    final token = authState.token;
                    if (token != null) {
                      ref
                          .read(serviceRequestProvider.notifier)
                          .loadAssignedRequests(token);
                    }
                  },
                  icon: Icon(Icons.refresh),
                  label: Text('Actualiser'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.06,
            vertical: 20,
          ),
          itemCount: requestState.assignedRequests.length,
          itemBuilder: (context, index) {
            final request = requestState.assignedRequests[index];
            return _buildAssignedRequestCard(request);
          },
        );
      },
    );
  }

  Widget _buildAllRequestCard(ServiceRequest request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    request.title,
                    style: AppTextStyles.h4.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ),
                _buildStatusChip(request.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              request.description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  request.location,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                Text(
                  '${request.budget.toStringAsFixed(0)} FCFA',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8B5CF6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  'Échéance: ${_formatDate(request.deadline)}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                if (request.assignedPrestataireId != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Déjà assigné',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (request.assignedPrestataireId == null) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showRequestDetails(request),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      child: const Text('Voir détails'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        print('=== ACCEPT BUTTON CLICKED ===');
                        _acceptRequestFromAll(request);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Accepter'),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Cette demande a déjà été assignée',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAssignedRequestCard(ServiceRequest request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    request.title,
                    style: AppTextStyles.h4.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ),
                _buildStatusChip(request.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              request.description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  request.location,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                Text(
                  '${request.budget.toStringAsFixed(0)} FCFA',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8B5CF6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  'Échéance: ${_formatDate(request.deadline)}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Assigné à vous',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _rejectRequest(request),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text('Refuser'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _acceptRequest(request),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Accepter'),
                  ),
                ),
              ],
            ),
            // Les négociations sont maintenant gérées dans l'onglet "Offres"
            // Plus besoin d'afficher NegotiationListWidget ici
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(ServiceRequest request) {
    return GestureDetector(
      onTap: () {
        // Afficher un dialog avec les détails de la demande
        _showRequestDetailsDialog(request);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      request.title,
                      style: AppTextStyles.h4.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  _buildStatusChip(request.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                request.description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Affichage des photos si disponibles
              if (request.photos.isNotEmpty) ...[
                ImageGallery(
                  imageUrls: request.photos,
                  height: 120,
                  maxImagesToShow: 3,
                  onTap: () {
                    showPhotoViewer(
                      context,
                      imageUrls: request.photos,
                      initialIndex: 0,
                    );
                  },
                ),
                const SizedBox(height: 12),
              ],

              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    request.location,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${request.budget.toStringAsFixed(0)} FCFA',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8B5CF6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Échéance: ${_formatDate(request.deadline)}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  if (request.assignedPrestataireId != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Assigné',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.green[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),

              // Photos de la demande
              if (request.photos.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.photo_camera,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Photos (${request.photos.length})',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CompactImageGallery(
                  imageUrls: request.photos,
                  onTap: () {
                    showPhotoViewer(
                      context,
                      imageUrls: request.photos,
                      title: request.title,
                    );
                  },
                ),
              ],

              // Bouton IA pour les demandes en attente
              if (request.status == 'pending') ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showAIRecommendations(request.id),
                    icon: const Icon(Icons.psychology, size: 18),
                    label: const Text('Recommandations IA'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],

              // Les négociations sont maintenant gérées dans l'onglet "Offres"
              // Plus besoin d'afficher NegotiationListWidget ici
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange[700]!;
        break;
      case 'accepted':
        backgroundColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue[700]!;
        break;
      case 'in_progress':
        backgroundColor = Colors.purple.withOpacity(0.1);
        textColor = Colors.purple[700]!;
        break;
      case 'completed':
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green[700]!;
        break;
      case 'cancelled':
        backgroundColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red[700]!;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey[700]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getStatusText(status),
        style: AppTextStyles.bodySmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'En attente';
      case 'accepted':
        return 'Accepté';
      case 'in_progress':
        return 'En cours';
      case 'completed':
        return 'Terminé';
      case 'cancelled':
        return 'Annulé';
      default:
        return status;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Carte de prestataire moderne avec glassmorphism
  Widget _buildPrestataireCard(Prestataire prestataire) {
    final colors = {
      'Plomberie': const Color(0xFF8B5CF6),
      'Électricité': const Color(0xFF06B6D4),
      'Peinture': const Color(0xFF10B981),
      'Bricolage': const Color(0xFFF59E0B),
      'Jardinage': const Color(0xFFEF4444),
      'Nettoyage': const Color(0xFF8B5CF6),
    };

    final color = colors[prestataire.category] ?? const Color(0xFF8B5CF6);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(25),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec avatar et informations principales
          Row(
            children: [
              // Avatar avec bordure moderne et note
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: color.withOpacity(0.3),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: PrestataireAvatar(
                      imageUrl: prestataire.profileImage ?? prestataire.avatar,
                      name: prestataire.name,
                      size: 60.0,
                      showBorder: false,
                    ),
                  ),
                  // Note en bas de l'avatar
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amber[600],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${prestataire.rating}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prestataire.name,
                      style: AppTextStyles.h3.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color.withOpacity(0.1),
                            color.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: color.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        prestataire.category,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            prestataire.location,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Badge de disponibilité moderne
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  gradient: prestataire.isAvailable
                      ? LinearGradient(
                          colors: [
                            const Color(0xFF10B981).withOpacity(0.1),
                            const Color(0xFF10B981).withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: [
                            Colors.grey.withOpacity(0.1),
                            Colors.grey.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: prestataire.isAvailable
                        ? const Color(0xFF10B981).withOpacity(0.3)
                        : Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      prestataire.isAvailable
                          ? Icons.check_circle
                          : Icons.cancel,
                      size: 16,
                      color: prestataire.isAvailable
                          ? const Color(0xFF10B981)
                          : Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      prestataire.isAvailable ? 'Disponible' : 'Indisponible',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 12,
                        color: prestataire.isAvailable
                            ? const Color(0xFF10B981)
                            : Colors.grey[600],
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Description
          Text(
            prestataire.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey[700],
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),
          // Prix uniquement
          if (prestataire.pricePerHour > 0)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF10B981).withOpacity(0.1),
                    const Color(0xFF10B981).withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF10B981).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.attach_money,
                    size: 20,
                    color: const Color(0xFF10B981),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${prestataire.pricePerHour.toStringAsFixed(0)} FCFA',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: const Color(0xFF10B981),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'par heure',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          // Travaux terminés et téléphone
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.purple.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.work_outline,
                        size: 16,
                        color: AppColors.purple,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${prestataire.completedJobs} travaux',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.purple,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 16,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          prestataire.phone ?? 'Non disponible',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Boutons d'action modernes
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppColors.purpleGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.purple.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => _contactPrestataireFromCard(prestataire),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Contacter',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  void _acceptRequestFromAll(ServiceRequest request) async {
    print('=== ACCEPT REQUEST FROM ALL CALLED ===');
    print('Request ID: ${request.id}');
    print('Request title: ${request.title}');

    final authState = ref.read(authProvider);
    final token = authState.token;

    print('User: ${authState.user?.firstName} ${authState.user?.lastName}');
    print('User role: ${authState.user?.role}');
    print('User ID: ${authState.user?.id}');
    print('Token exists: ${token != null}');

    if (token == null) {
      print('ERROR: Token is null');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Token non disponible'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Afficher un indicateur de chargement
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      print('Calling assignPrestataire...');
      // Assigner le prestataire à la demande
      await ref.read(serviceRequestProvider.notifier).assignPrestataire(
            request.id,
            authState.user!.id, // ID du prestataire connecté
            '${authState.user!.firstName} ${authState.user!.lastName}', // Nom du prestataire
            token,
          );
      print('assignPrestataire completed successfully');

      // Fermer l'indicateur de chargement
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      // Afficher un message de succès
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Demande acceptée avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Recharger toutes les demandes
      print('Reloading all requests...');
      ref.read(serviceRequestProvider.notifier).loadAllRequests();
      print('All requests reloaded');
    } catch (e) {
      print('ERROR in assignPrestataire: $e');
      // Fermer l'indicateur de chargement
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showRequestDetails(ServiceRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          request.title,
          style: AppTextStyles.h4.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description:',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(request.description),
            const SizedBox(height: 16),
            Text(
              'Catégorie: ${request.category}',
              style: AppTextStyles.bodyMedium,
            ),
            Text(
              'Localisation: ${request.location}',
              style: AppTextStyles.bodyMedium,
            ),
            Text(
              'Budget: ${request.budget.toStringAsFixed(0)} FCFA',
              style: AppTextStyles.bodyMedium,
            ),
            Text(
              'Échéance: ${_formatDate(request.deadline)}',
              style: AppTextStyles.bodyMedium,
            ),
            if (request.notes != null) ...[
              const SizedBox(height: 8),
              Text(
                'Notes: ${request.notes}',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _acceptRequestFromAll(request);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Accepter'),
          ),
        ],
      ),
    );
  }

  void _acceptRequest(ServiceRequest request) async {
    final authState = ref.read(authProvider);
    final token = authState.token;

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Token non disponible'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Afficher un indicateur de chargement
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Mettre à jour le statut de la demande à "accepted"
      await ref.read(serviceRequestProvider.notifier).updateServiceRequest(
            request.id,
            {'status': 'accepted'},
            token,
          );

      // Fermer l'indicateur de chargement
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      // Afficher un message de succès
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Demande acceptée avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Recharger les demandes assignées
      _loadAssignedRequests();
    } catch (e) {
      // Fermer l'indicateur de chargement
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _rejectRequest(ServiceRequest request) async {
    final authState = ref.read(authProvider);
    final token = authState.token;

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Token non disponible'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Afficher un indicateur de chargement
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Mettre à jour le statut de la demande à "cancelled"
      await ref.read(serviceRequestProvider.notifier).updateServiceRequest(
            request.id,
            {'status': 'cancelled'},
            token,
          );

      // Fermer l'indicateur de chargement
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      // Afficher un message de succès
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Demande refusée'),
            backgroundColor: Colors.orange,
          ),
        );
      }

      // Recharger les demandes assignées
      _loadAssignedRequests();
    } catch (e) {
      // Fermer l'indicateur de chargement
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _contactPrestataireFromCard(Prestataire prestataire) async {
    final authState = ref.read(authProvider);
    final token = authState.token;

    if (!authState.isAuthenticated || token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Vous devez être connecté pour contacter un prestataire'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Afficher un indicateur de chargement
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Charger les conversations d'abord
      await ref.read(messagesProvider.notifier).loadConversations(token);

      // Vérifier si une conversation existe déjà
      final existingConversations = ref.read(messagesProvider).conversations;
      Conversation? existingConversation;
      try {
        existingConversation = existingConversations.firstWhere(
          (conv) => conv.prestataireId == prestataire.id,
        );
      } catch (e) {
        existingConversation = null;
      }

      Conversation? conversation;

      if (existingConversation != null) {
        conversation = existingConversation;
      } else {
        // Créer une nouvelle conversation
        conversation =
            await ref.read(messagesProvider.notifier).createConversation(
                  prestataireId: prestataire.id,
                  token: token,
                );
      }

      // Fermer l'indicateur de chargement
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      if (conversation != null && context.mounted) {
        // Naviguer vers le chat
        context.push('/messages/chat/${conversation.id}');
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la création de la conversation'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Fermer l'indicateur de chargement
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _loadClientNegotiations() async {
    final authState = ref.read(authProvider);
    var token = authState.token;

    print('=== LOAD CLIENT NEGOTIATIONS CALLED ===');
    print('User: ${authState.user?.firstName} ${authState.user?.lastName}');
    print('Role: ${authState.user?.role}');
    print('User ID: ${authState.user?.id}');
    print('Token exists: ${token != null}');

    if (token != null && authState.user?.role == UserRole.client) {
      print('Loading client negotiations for client ID: ${authState.user!.id}');
      ref.read(priceNegotiationProvider.notifier).loadClientNegotiations(
            clientId: authState.user!.id,
            token: token,
          );
    } else {
      print('Not loading negotiations - conditions not met');
    }
  }

  void _showRequestDetailsDialog(ServiceRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getCategoryColor(request.category).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.work,
                color: _getCategoryColor(request.category),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                request.title,
                style: AppTextStyles.h4.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Catégorie
              _buildDetailRow(Icons.category, 'Catégorie', request.category),
              const SizedBox(height: 12),

              // Description
              _buildDetailRow(
                  Icons.description, 'Description', request.description),
              const SizedBox(height: 12),

              // Client
              _buildDetailRow(Icons.person, 'Client', request.clientName),
              const SizedBox(height: 12),

              // Téléphone
              _buildDetailRow(Icons.phone, 'Téléphone', request.clientPhone),
              const SizedBox(height: 12),

              // Localisation
              _buildDetailRow(Icons.location_on, 'Lieu', request.location),
              const SizedBox(height: 12),

              // Budget
              _buildDetailRow(Icons.attach_money, 'Budget',
                  '${request.budget.toStringAsFixed(0)} FCFA'),
              const SizedBox(height: 12),

              // Échéance
              _buildDetailRow(Icons.calendar_today, 'Échéance',
                  _formatDate(request.deadline)),
              const SizedBox(height: 12),

              // Statut
              _buildDetailRow(
                Icons.info_outline,
                'Statut',
                _getStatusText(request.status),
                color: _getStatusColor(request.status),
              ),

              // Prestataire assigné
              if (request.assignedPrestataireId != null) ...[
                const SizedBox(height: 12),
                _buildDetailRow(
                    Icons.assignment_ind,
                    'Prestataire assigné',
                    request.assignedPrestataireName ??
                        request.prestataireName ??
                        'Inconnu'),
              ],

              // Notes
              if (request.notes != null && request.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildDetailRow(Icons.notes, 'Notes', request.notes!),
              ],

              // Date de création
              const SizedBox(height: 12),
              _buildDetailRow(Icons.access_time, 'Créée le',
                  _formatDateTime(request.createdAt)),

              // Date de réalisation
              if (request.completionDate != null) ...[
                const SizedBox(height: 12),
                _buildDetailRow(
                    Icons.check_circle_outline,
                    'Date de réalisation',
                    _formatDate(request.completionDate!)),
              ],

              // Remarques de clôture
              if (request.completionNotes != null &&
                  request.completionNotes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildDetailRow(Icons.rate_review, 'Remarques de clôture',
                    request.completionNotes!),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value,
      {Color? color}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: Text(
            '$label :',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: color ?? Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    final colors = {
      'Plomberie': const Color(0xFF8B5CF6),
      'Électricité': const Color(0xFF06B6D4),
      'Peinture': const Color(0xFF10B981),
      'Bricolage': const Color(0xFFF59E0B),
      'Jardinage': const Color(0xFFEF4444),
      'Nettoyage': const Color(0xFF8B5CF6),
    };
    return colors[category] ?? const Color(0xFF8B5CF6);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'assigned':
        return Colors.blue;
      case 'in_progress':
        return Colors.purple;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _showAIRecommendations(String serviceRequestId) {
    print('🔍 AI Button clicked for serviceRequestId: $serviceRequestId');
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AIMatchingScreen(
            serviceRequestId: serviceRequestId,
            title: 'Recommandations IA',
          ),
        ),
      );
      print('✅ Navigation successful');
    } catch (e) {
      print('❌ Navigation error: $e');
    }
  }
}
