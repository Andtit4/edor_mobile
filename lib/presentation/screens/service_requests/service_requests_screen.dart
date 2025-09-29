// lib/presentation/screens/service_requests/service_requests_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/service_request.dart';
import '../../../domain/entities/user.dart';
import '../../providers/service_request_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/price_negotiation_provider.dart';
import '../../widgets/image_gallery.dart';
import '../../widgets/photo_viewer.dart';

class ServiceRequestsScreen extends ConsumerStatefulWidget {
  const ServiceRequestsScreen({super.key});

  @override
  ConsumerState<ServiceRequestsScreen> createState() => _ServiceRequestsScreenState();
}

class _ServiceRequestsScreenState extends ConsumerState<ServiceRequestsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'Toutes';

  final List<String> _filters = ['Toutes', 'En attente', 'En cours', 'Terminées'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Charger les données au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  /// Charge les données des demandes de service
  void _loadData() {
    final authState = ref.read(authProvider);
    final token = authState.token;
    
    if (token != null) {
      // Charger toutes les demandes (pour le premier onglet)
      ref.read(serviceRequestProvider.notifier).loadAllRequests();
      
      // Charger les demandes de l'utilisateur connecté
      ref.read(serviceRequestProvider.notifier).loadMyRequests(token);
      
      // Charger les demandes assignées à l'utilisateur (pour les prestataires)
      if (authState.user?.role == UserRole.prestataire) {
        ref.read(serviceRequestProvider.notifier).loadAssignedRequests(token);
      }
    } else {
      _loadDataFromCache();
    }
  }

  /// Charge les données depuis le cache local
  Future<void> _loadDataFromCache() async {
    try {
      final localDataSource = ref.read(localDataSourceProvider);
      final tokenData = await localDataSource.getFromCache('auth_token');
      final token = tokenData?['token'] as String?;
      
      if (token != null) {
        // Charger toutes les demandes
        ref.read(serviceRequestProvider.notifier).loadAllRequests();
        
        // Charger les demandes de l'utilisateur
        ref.read(serviceRequestProvider.notifier).loadMyRequests(token);
      }
    } catch (e) {
      // Gestion silencieuse des erreurs de cache
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Ouvre Google Maps avec les coordonnées de la demande
  Future<void> _openGoogleMaps(double latitude, double longitude) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
    final uri = Uri.parse(url);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('Impossible d\'ouvrir Google Maps');
      }
    } catch (e) {
      _showErrorSnackBar('Erreur lors de l\'ouverture de Google Maps: $e');
    }
  }

  /// Affiche un message d'erreur
  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final requestState = ref.watch(serviceRequestProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: screenHeight * 0.02),
                _buildEnhancedHeader(),
                SizedBox(height: screenHeight * 0.025),
                _buildEnhancedSearchBar(),
                SizedBox(height: screenHeight * 0.02),
                _buildEnhancedFilterChips(),
                SizedBox(height: screenHeight * 0.02),
                _buildEnhancedTabBar(),
                SizedBox(height: screenHeight * 0.02),
                SizedBox(
                  height: screenHeight * 0.6,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildRequestsList(requestState.allRequests),
                      _buildMyAcceptedRequests(requestState.myRequests),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construit le header amélioré de la page
  Widget _buildEnhancedHeader() {
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
              size: 30,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Demandes de service',
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Découvrez les nouvelles opportunités',
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
                // Filtres avancés
              },
              icon: const Icon(
                Icons.filter_list,
                color: AppColors.purple,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construit la barre de recherche améliorée
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
          hintText: 'Rechercher une demande...',
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

  /// Construit les puces de filtre améliorées
  Widget _buildEnhancedFilterChips() {
    return Container(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          
          return Container(
            margin: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected 
                        ? AppColors.purple.withOpacity(0.3)
                        : AppColors.borderColor.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
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
                child: Text(
                  filter,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isSelected ? AppColors.purple : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Construit la barre d'onglets améliorée
  Widget _buildEnhancedTabBar() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            AppColors.lightGray.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.purple.withOpacity(0.1),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.purple.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: AppColors.purpleGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.purple.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
        unselectedLabelStyle: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        tabs: [
          Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  const SizedBox(width: 6),
                  const Flexible(
                    child: Text(
                      'Toutes',
                      style: TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  const SizedBox(width: 6),
                  const Flexible(
                    child: Text(
                      'Mes demandes',
                      style: TextStyle(fontSize: 13),
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

  /// Construit la liste de toutes les demandes
  Widget _buildRequestsList(List<ServiceRequest> requests) {
    final filteredRequests = _filterRequests(requests);
    
    if (filteredRequests.isEmpty) {
      return const Center(
        child: Text('Aucune demande trouvée'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: filteredRequests.length,
      itemBuilder: (context, index) {
        final request = filteredRequests[index];
        return _buildRequestCard(request);
      },
    );
  }

  /// Construit la liste des demandes acceptées par l'utilisateur
  Widget _buildMyAcceptedRequests(List<ServiceRequest> requests) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    
    if (user?.role != UserRole.prestataire) {
      return const Center(
        child: Text('Cette section est réservée aux prestataires'),
      );
    }

    final myRequests = requests.where((request) => 
      request.assignedPrestataireId == user?.id
    ).toList();

    if (myRequests.isEmpty) {
      return const Center(
        child: Text('Aucune demande assignée'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: myRequests.length,
      itemBuilder: (context, index) {
        final request = myRequests[index];
        return _buildRequestCard(request);
      },
    );
  }

  /// Filtre les demandes selon le filtre sélectionné
  List<ServiceRequest> _filterRequests(List<ServiceRequest> requests) {
    switch (_selectedFilter) {
      case 'En attente':
        return requests.where((r) => r.status == 'pending').toList();
      case 'En cours':
        return requests.where((r) => r.status == 'in_progress').toList();
      case 'Terminées':
        return requests.where((r) => r.status == 'completed').toList();
      default:
        return requests;
    }
  }

  /// Construit une carte de demande de service
  Widget _buildRequestCard(ServiceRequest request) {
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
        border: Border.all(
          color: AppColors.borderColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec gradient subtil
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.08),
                  color.withOpacity(0.03),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Catégorie et statut
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.category_outlined,
                            color: color,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            request.category,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: color,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(request.status).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getStatusText(request.status),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: _getStatusColor(request.status),
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Titre
                Text(
                  request.title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 18,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          
          // Contenu principal
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Text(
                  request.description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Informations en grille compacte
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lightGray.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // Client et Prix sur une ligne
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoItem(
                              icon: Icons.person_outline,
                              label: 'Client',
                              value: request.clientName,
                              color: AppColors.purple,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInfoItem(
                              icon: Icons.attach_money_outlined,
                              label: 'Prix',
                              value: '${request.budget.toStringAsFixed(0)} FCFA',
                              color: color,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Localisation et Date sur une ligne
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoItem(
                              icon: Icons.location_on_outlined,
                              label: 'Localisation',
                              value: request.location,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInfoItem(
                              icon: Icons.schedule_outlined,
                              label: 'Échéance',
                              value: _formatDate(request.deadline),
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Photos si disponibles
                if (request.photos.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.borderColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.photo_camera_outlined,
                              color: AppColors.purple,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Photos (${request.photos.length})',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ImageGallery(
                          imageUrls: request.photos,
                          height: 100,
                          maxImagesToShow: 3,
                          onTap: () {
                            showPhotoViewer(
                              context,
                              imageUrls: request.photos,
                              initialIndex: 0,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
                
                const SizedBox(height: 16),
                
                // Actions
                if (request.status == 'pending' || request.status == 'assigned' || request.status == 'in_progress')
                  Row(
                    children: [
                      if (request.status == 'pending')
                        Expanded(
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: AppColors.purpleGradient,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.purple.withOpacity(0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () => _acceptRequest(request),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Accepter',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (request.status == 'assigned' || request.status == 'in_progress')
                        Expanded(
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF10B981),
                                  const Color(0xFF10B981).withOpacity(0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF10B981).withOpacity(0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () => _completeRequest(request),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Terminer',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
          
          // Bouton Google Maps
          if (request.latitude != null && request.longitude != null && 
              (request.status == 'assigned' || request.status == 'in_progress'))
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _openGoogleMaps(request.latitude!, request.longitude!),
                  icon: const Icon(Icons.directions, size: 16),
                  label: const Text('Ouvrir dans Google Maps'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4285F4),
                    side: const BorderSide(color: Color(0xFF4285F4), width: 1),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  /// Accepte une demande de service
  void _acceptRequest(ServiceRequest request) async {
    final authState = ref.read(authProvider);
    final user = authState.user;
    final token = authState.token;
    
    
    if (user != null && token != null) {
      // Afficher un indicateur de chargement
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      try {
        // Fermer l'indicateur de chargement
        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        
        // Rediriger directement vers le flow de négociation
        // La demande reste "En attente" jusqu'à ce que le client accepte
        if (context.mounted) {
          _showPriceNegotiationDialog(request);
        }
      } catch (e) {
        // Fermer l'indicateur de chargement
        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          _showErrorSnackBar('Erreur: ${e.toString()}');
        }
      }
    } else {
      _showErrorSnackBar('Erreur d\'authentification');
    }
  }

  /// Affiche le dialogue de négociation de prix
  void _showPriceNegotiationDialog(ServiceRequest request) {
    final TextEditingController priceController = TextEditingController();
    final TextEditingController messageController = TextEditingController();
    bool useInitialBudget = false;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Proposer un prix',
            style: AppTextStyles.h4.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Demande: ${request.title}',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Budget initial: ${request.budget.toStringAsFixed(0)} FCFA',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              
              // Checkbox "Le prix me va"
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF8B5CF6).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: useInitialBudget,
                      onChanged: (value) {
                        setState(() {
                          useInitialBudget = value ?? false;
                          if (useInitialBudget) {
                            priceController.text = request.budget.toStringAsFixed(0);
                          } else {
                            priceController.text = '';
                          }
                        });
                      },
                      activeColor: const Color(0xFF8B5CF6),
                    ),
                    Expanded(
                      child: Text(
                        'Le prix me va (${request.budget.toStringAsFixed(0)} FCFA)',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF8B5CF6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                enabled: !useInitialBudget,
                decoration: InputDecoration(
                  labelText: 'Votre prix proposé (FCFA)',
                  hintText: 'Ex: 50000',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Message (optionnel)',
                  hintText: 'Expliquez votre proposition...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.message),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                final proposedPrice = double.tryParse(priceController.text);
                if (proposedPrice == null || proposedPrice <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Veuillez entrer un prix valide'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                Navigator.pop(context);
                _createPriceNegotiation(request, proposedPrice, messageController.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Proposer'),
            ),
          ],
        ),
      ),
    );
  }

  void _createPriceNegotiation(ServiceRequest request, double proposedPrice, String message) async {
    final authState = ref.read(authProvider);
    final token = authState.token;
    
    print('=== CREATE PRICE NEGOTIATION CALLED ===');
    print('Request ID: ${request.id}');
    print('Proposed Price: $proposedPrice');
    print('Message: $message');
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
      print('Calling createNegotiation...');
      // Créer la négociation de prix
      final result = await ref.read(priceNegotiationProvider.notifier).createNegotiation(
        serviceRequestId: request.id,
        proposedPrice: proposedPrice,
        isFromPrestataire: true,
        message: message.isNotEmpty ? message : null,
        token: token,
      );
      
      print('createNegotiation result: $result');

      // Fermer l'indicateur de chargement
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      // Recharger les demandes pour voir le statut mis à jour
      ref.read(serviceRequestProvider.notifier).loadAllRequests();
      
      // Afficher un message de succès
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Proposition de prix envoyée avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('ERROR in createNegotiation: $e');
      
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


  /// Marque une demande comme terminée
  void _completeRequest(ServiceRequest request) {
    final authState = ref.read(authProvider);
    final token = authState.token;
    
    if (token != null) {
      ref.read(serviceRequestProvider.notifier).completeRequest(request.id, token);
    }
  }

  /// Retourne la couleur associée au statut
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

  /// Retourne le texte associé au statut
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

  /// Formate une date pour l'affichage
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}