// lib/presentation/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/prestataire_provider.dart';
import '../../providers/service_offer_provider.dart';
import '../../providers/service_request_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/entities/prestataire.dart';
import '../../../domain/entities/service_request.dart';
import '../../router/app_routes.dart';
import '../../widgets/profile_avatar.dart';
import '../../widgets/image_gallery.dart';
import '../../widgets/photo_viewer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Charger les données au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    // Charger les prestataires
    ref.read(prestatairesProvider.notifier).loadPrestataires();
    
    // Charger les offres de service
    ref.read(serviceOfferProvider.notifier).loadOffers();
    
    // Charger toutes les demandes de service - CORRECTION
    ref.read(serviceRequestProvider.notifier).loadAllRequests();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            final authState = ref.watch(authProvider);
            final user = authState.user;
            
            if (user == null) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.purple),
                ),
              );
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06, // 6% de la largeur
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Espace flexible pour centrer le contenu
                    SizedBox(height: screenHeight * 0.02),
                    
                    // Header amélioré
                    _buildEnhancedHeader(user),
                    
                    SizedBox(height: screenHeight * 0.025),
                    
                    // Search Bar amélioré
                    _buildEnhancedSearchBar(),
                    
                    SizedBox(height: screenHeight * 0.025),
                    
                    // Quick Actions based on role
                    _buildQuickActions(user.role),
                    
                    SizedBox(height: screenHeight * 0.02),
                    
                    // Content based on role
                    SizedBox(
                      height: screenHeight * 0.5, // Hauteur fixe pour éviter les conflits
                      child: user.role == UserRole.prestataire 
                          ? _buildPrestataireContent()
                          : _buildClientContent(),
                    ),
                    
                    // Espace en bas
                    SizedBox(height: screenHeight * 0.1),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEnhancedHeader(User user) {
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
            child: ProfileAvatar(
              imageUrl: user.profileImage,
              name: user.firstName,
              size: 50.0,
              showBorder: false,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour, ${user.firstName}!',
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Que souhaitez-vous faire aujourd\'hui?',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 50,
            height: 50,
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
            child: IconButton(
              onPressed: () {
                // Navigation vers les notifications
              },
              icon: const Icon(
                Icons.notifications_outlined,
                color: AppColors.purple,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
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
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Rechercher un service...',
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary.withOpacity(0.7),
            fontSize: 16,
          ),
          border: InputBorder.none,
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.search,
              color: AppColors.purple,
              size: 20,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
        ),
        style: AppTextStyles.bodyMedium.copyWith(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildQuickActions(UserRole role) {
    if (role == UserRole.prestataire) {
      // Ne pas afficher le bloc Actions rapides pour les prestataires
      return const SizedBox.shrink();
    } else {
      return _buildClientQuickActions();
    }
  }


  Widget _buildClientQuickActions() {
    return Container(
      padding: const EdgeInsets.all(24),
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
          Text(
            'Actions rapides',
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildEnhancedQuickActionCard(
                  'Demander un service',
                  'Créer une demande',
                  Icons.add_circle_outline,
                  AppColors.purple,
                  () => context.push(AppRoutes.createRequest),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildEnhancedQuickActionCard(
                  'Prestataires',
                  'Voir les services',
                  Icons.people_outline,
                  const Color(0xFF10B981),
                  () => context.push(AppRoutes.serviceOffers),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedQuickActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.05),
              color.withOpacity(0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.2),
                    color.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: color,
                size: 26,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrestataireContent() {
    return Column(
      children: [
        // Recent Requests
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.purple.withOpacity(0.05),
                AppColors.purple.withOpacity(0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.purple.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.purple.withOpacity(0.2),
                      AppColors.purple.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.purple.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.work_outline,
                  color: AppColors.purple,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Demandes récentes',
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    
                  ],
                ),
              ),
              TextButton(
                onPressed: () => context.push(AppRoutes.serviceRequests),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  backgroundColor: AppColors.purple.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Voir tout',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.purple,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _buildRecentRequestsList(),
        ),
      ],
    );
  }

  Widget _buildClientContent() {
    return Column(
      children: [
        // Titre de la section
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.purple.withOpacity(0.05),
                AppColors.purple.withOpacity(0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.purple.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.purple.withOpacity(0.2),
                      AppColors.purple.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.purple.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.people_outline,
                  color: AppColors.purple,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prestataires populaires',
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Découvrez nos meilleurs professionnels',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => context.push(AppRoutes.serviceOffers),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  backgroundColor: AppColors.purple.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Voir tout',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.purple,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Liste des prestataires
        Expanded(
          child: _buildPopularServicesList(),
        ),
      ],
    );
  }


  Widget _buildRecentRequestsList() {
    final serviceRequestState = ref.watch(serviceRequestProvider);
    
    if (serviceRequestState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (serviceRequestState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Erreur: ${serviceRequestState.error}'),
            ElevatedButton(
              onPressed: () => ref.read(serviceRequestProvider.notifier).loadAllRequests(),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }
    
    if (serviceRequestState.allRequests.isEmpty) {
      return const Center(
        child: Text('Aucune demande récente'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: serviceRequestState.allRequests.length,
      itemBuilder: (context, index) {
        final request = serviceRequestState.allRequests[index];
        return _buildRequestCardFromEntity(request);
      },
    );
  }

  Widget _buildPopularServicesList() {
    final prestataireState = ref.watch(prestatairesProvider);
    
    print('=== DEBUG PRESTATAIRES ===');
    print('Loading: ${prestataireState.isLoading}');
    print('Error: ${prestataireState.error}');
    print('Count: ${prestataireState.prestataires.length}');
    print('========================');
    
    if (prestataireState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (prestataireState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Erreur: ${prestataireState.error}'),
            ElevatedButton(
              onPressed: () => ref.read(prestatairesProvider.notifier).loadPrestataires(),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }
    
    if (prestataireState.prestataires.isEmpty) {
      return const Center(
        child: Text('Aucun prestataire disponible'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: prestataireState.prestataires.length,
      itemBuilder: (context, index) {
        final prestataire = prestataireState.prestataires[index];
        return _buildPrestataireListItem(prestataire);
      },
    );
  }

  Widget _buildPrestataireListItem(Prestataire prestataire) {
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
      padding: const EdgeInsets.all(24),
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
          Row(
            children: [
              // Prestataire Avatar
              PrestataireAvatar(
                imageUrl: prestataire.profileImage ?? prestataire.avatar,
                name: prestataire.name,
                size: 50.0,
                showBorder: true,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                      prestataire.name,
                      style: AppTextStyles.h4.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
              prestataire.category,
              style: AppTextStyles.bodySmall.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: prestataire.isAvailable 
                      ? const Color(0xFF10B981).withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: prestataire.isAvailable 
                        ? const Color(0xFF10B981)
                        : Colors.grey,
                    width: 1,
                  ),
                ),
                child: Text(
                  prestataire.isAvailable ? 'Disponible' : 'Indisponible',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: prestataire.isAvailable 
                        ? const Color(0xFF10B981)
                        : Colors.grey[600],
                fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Description
          if (prestataire.description.isNotEmpty) ...[
            Text(
              prestataire.description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey[600],
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
          ],
          // Rating and Location
          Row(
            children: [
              // Rating
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                      size: 16,
                  color: Colors.amber[600],
                ),
                const SizedBox(width: 4),
                Text(
                      '${prestataire.rating.toStringAsFixed(1)}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.amber[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${prestataire.totalReviews})',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Location
              Expanded(
                child: Row(
                  children: [
                Icon(
                  Icons.location_on,
                      size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    prestataire.location,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
                ),
            ),
          ],
        ),
          const SizedBox(height: 16),
          // Price and Completed Jobs
          Row(
          children: [
              if (prestataire.pricePerHour > 0) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF10B981).withOpacity(0.1),
                    const Color(0xFF10B981).withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF10B981).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Text(
                '${prestataire.pricePerHour.toStringAsFixed(0)} FCFA/h',
                style: AppTextStyles.bodySmall.copyWith(
                  color: const Color(0xFF10B981),
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
                const SizedBox(width: 12),
              ],
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${prestataire.completedJobs} travaux',
                style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF8B5CF6),
                  fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
          context.push('/prestataire/${prestataire.id}', extra: prestataire.id);
        },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF8B5CF6),
                    side: const BorderSide(color: Color(0xFF8B5CF6)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Voir profil'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _contactPrestataire(prestataire);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Contacter'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCardFromEntity(ServiceRequest request) {
    final colors = {
      'Plomberie': const Color(0xFF8B5CF6),
      'Électricité': const Color(0xFF10B981),
      'Peinture': const Color(0xFFF59E0B),
      'Nettoyage': const Color(0xFFEF4444),
      'Jardinage': const Color(0xFF22C55E),
    };

    final color = colors[request.category] ?? const Color(0xFF8B5CF6);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.work,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      request.category,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(request.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusText(request.status),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: _getStatusColor(request.status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
              ClientAvatar(
                imageUrl: request.clientImage,
                name: request.clientName,
                size: 24.0,
                showBorder: false,
              ),
              const SizedBox(width: 8),
              Text(
                request.clientName,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.location_on,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  request.location,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.1),
                      color.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: color.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${request.budget.toStringAsFixed(0)} FCFA',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
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
            ImageGallery(
              imageUrls: request.photos,
              height: 100,
              maxImagesToShow: 3,
              onTap: () {
                showPhotoViewer(
                  context,
                  imageUrls: request.photos,
                  title: request.title,
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
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

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'En attente';
      case 'assigned':
        return 'Assigné';
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

  void _contactPrestataire(Prestataire prestataire) {
    // Navigation vers la page des messages ou création d'une conversation
    context.push(AppRoutes.messages);
  }
}
