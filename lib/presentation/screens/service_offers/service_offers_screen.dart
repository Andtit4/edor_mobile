import 'package:edor/presentation/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/service_offer.dart';
import '../../../domain/entities/service_request.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/entities/prestataire.dart';
import '../../providers/service_offer_provider.dart';
import '../../providers/service_request_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/prestataire_provider.dart';
import 'package:go_router/go_router.dart';
// import '../../../router/app_routes.dart';

class ServiceOffersScreen extends ConsumerStatefulWidget {
  const ServiceOffersScreen({super.key});

  @override
  ConsumerState<ServiceOffersScreen> createState() => _ServiceOffersScreenState();
}

class _ServiceOffersScreenState extends ConsumerState<ServiceOffersScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'Toutes';

  final List<String> _filters = ['Toutes', 'Plomberie', 'Électricité', 'Peinture', 'Bricolage', 'Jardinage', 'Nettoyage'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Charger les données au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(serviceOfferProvider.notifier).loadOffers();
      ref.read(prestatairesProvider.notifier).loadPrestataires(); // Charger les prestataires
      _loadMyRequests(); // Charger les demandes du client
      _loadMyOffers(); // Charger les offres du prestataire
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offerState = ref.watch(serviceOfferProvider);
    final authState = ref.watch(authProvider);
    final user = authState.user;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Search Bar
            _buildSearchBar(),
            
            // Filter Chips
            _buildFilterChips(),
            
            // Tab Bar
            _buildTabBar(),
            
            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPrestatairesList(), // Premier onglet
                  _buildOffersList(offerState.offers), // Deuxième onglet
                  user?.role == UserRole.prestataire
                    ? _buildMyOffersList(offerState.offers) // Pour les prestataires
                    : _buildMyRequestsList([]), // Pour les clients - on utilise le Consumer à l'intérieur
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.createRequest),
        backgroundColor: const Color(0xFF8B5CF6),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Trouvez votre',
                style: AppTextStyles.h2.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                'prestataire',
                style: AppTextStyles.h2.copyWith(
                  color: const Color(0xFF1F2937),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF6B7280),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Rechercher un prestataire...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          border: InputBorder.none,
          suffixIcon: Icon(Icons.tune, color: Colors.grey[400]),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFF8B5CF6).withOpacity(0.1),
              checkmarkColor: const Color(0xFF8B5CF6),
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFF8B5CF6) : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              side: BorderSide(
                color: isSelected ? const Color(0xFF8B5CF6) : Colors.grey[300]!,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabBar() {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFF8B5CF6),
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        tabs: user?.role == UserRole.prestataire 
          ? const [
              Tab(text: 'Prestataires'),
              Tab(text: 'Offres'),
              Tab(text: 'Mes offres'), // Pour les prestataires
            ]
          : const [
              Tab(text: 'Prestataires'),
              Tab(text: 'Offres'),
              Tab(text: 'Mes demandes'), // Pour les clients
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
        
        // Filtrer les prestataires selon le filtre sélectionné
        final filteredPrestataires = prestatairesState.prestataires.where((prestataire) {
          if (_selectedFilter == 'Toutes') return true;
          return prestataire.category == _selectedFilter;
        }).toList();
        
        if (filteredPrestataires.isEmpty) {
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
          padding: const EdgeInsets.all(20),
          itemCount: filteredPrestataires.length,
          itemBuilder: (context, index) {
            final prestataire = filteredPrestataires[index];
            return _buildPrestataireCard(prestataire);
          },
        );
      },
    );
  }

  Widget _buildOffersList(List<ServiceOffer> offers) {
    final filteredOffers = offers.where((offer) {
      if (_selectedFilter == 'Toutes') return true;
      return offer.category == _selectedFilter;
    }).toList();

    if (filteredOffers.isEmpty) {
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
              'Aucun prestataire',
              style: AppTextStyles.h3.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Aucun prestataire ne correspond à vos critères',
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
      padding: const EdgeInsets.all(20),
      itemCount: filteredOffers.length,
      itemBuilder: (context, index) {
        final offer = filteredOffers[index];
        return _buildOfferCard(offer);
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
          print('Request: ${request.title} - ${request.status} - ${request.clientId}');
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
                      ref.read(serviceRequestProvider.notifier).loadMyRequests(token);
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
                      ref.read(serviceRequestProvider.notifier).loadMyRequests(token);
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
          padding: const EdgeInsets.all(20),
          itemCount: requestState.myRequests.length,
          itemBuilder: (context, index) {
            final request = requestState.myRequests[index];
            return _buildRequestCard(request);
          },
        );
      },
    );
  }

  Widget _buildMyOffersList(List<ServiceOffer> offers) {
    final authState = ref.watch(authProvider);
    
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
    
    if (offers.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_business_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Vous n\'avez créé aucune offre',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Créez votre première offre de service',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: offers.length,
      itemBuilder: (context, index) {
        final offer = offers[index];
        return _buildOfferCard(offer);
      },
    );
  }

  Widget _buildOfferCard(ServiceOffer offer) {
    final colors = {
      'Plomberie': const Color(0xFF8B5CF6),
      'Électricité': const Color(0xFF06B6D4),
      'Peinture': const Color(0xFF10B981),
      'Bricolage': const Color(0xFFF59E0B),
      'Jardinage': const Color(0xFFEF4444),
      'Nettoyage': const Color(0xFF8B5CF6),
    };

    final color = colors[offer.category] ?? const Color(0xFF8B5CF6);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Prestataire Avatar
              CircleAvatar(
                radius: 25,
                backgroundColor: color.withOpacity(0.1),
                child: Text(
                  offer.prestataireName[0],
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.prestataireName,
                      style: AppTextStyles.h4.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      offer.title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          offer.location,
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Disponible',
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFF10B981),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            offer.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey[700],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Rating
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.amber[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${offer.rating}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${offer.reviewCount} avis)',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Price
              Row(
                children: [
                  Icon(
                    Icons.euro,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${offer.price.toStringAsFixed(0)}€/h',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Experience and Availability
          Row(
            children: [
              Icon(
                Icons.work_history,
                size: 14,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 4),
              Text(
                offer.experience ?? '',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.schedule,
                size: 14,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 4),
              Text(
                offer.availability ?? '',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showOfferDetails(offer),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: Colors.grey[700],
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
                  onPressed: () => _contactPrestataire(offer),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
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

  Widget _buildRequestCard(ServiceRequest request) {
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          ],
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

  void _showOfferDetails(ServiceOffer offer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          offer.prestataireName,
          style: AppTextStyles.h4.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service: ${offer.title}',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(offer.description),
            const SizedBox(height: 16),
            Text(
              'Téléphone: ${offer.prestatairePhone}',
              style: AppTextStyles.bodyMedium,
            ),
            Text(
              'Localisation: ${offer.location}',
              style: AppTextStyles.bodyMedium,
            ),
            Text(
              'Prix: ${offer.price.toStringAsFixed(0)}€/h',
              style: AppTextStyles.bodyMedium,
            ),
            if (offer.experience != null) ...[
              Text(
                'Expérience: ${offer.experience}',
                style: AppTextStyles.bodyMedium,
              ),
            ],
            if (offer.availability != null) ...[
              Text(
                'Disponibilité: ${offer.availability}',
                style: AppTextStyles.bodyMedium,
              ),
            ],
            Row(
              children: [
                Icon(Icons.star, size: 16, color: Colors.amber[600]),
                const SizedBox(width: 4),
                Text(
                  '${offer.rating} (${offer.reviewCount} avis)',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
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
              _contactPrestataire(offer);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Contacter'),
          ),
        ],
      ),
    );
  }

  void _contactPrestataire(ServiceOffer offer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Contacter le prestataire'),
        content: Text(
          'Voulez-vous contacter ${offer.prestataireName} pour discuter de vos besoins?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(serviceOfferProvider.notifier).contactPrestataire(offer.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Envoyer message'),
          ),
        ],
      ),
    );
  }

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
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Prestataire Avatar
              CircleAvatar(
                radius: 25,
                backgroundColor: color.withOpacity(0.1),
                backgroundImage: prestataire.avatar != null 
                    ? NetworkImage(prestataire.avatar!) 
                    : null,
                child: prestataire.avatar == null
                    ? Text(
                        prestataire.name.isNotEmpty ? prestataire.name[0].toUpperCase() : 'P',
                        style: TextStyle(
                          color: color,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prestataire.name,
                      style: AppTextStyles.h4.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      prestataire.category,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          prestataire.location,
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: prestataire.isAvailable 
                      ? const Color(0xFF10B981).withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  prestataire.isAvailable ? 'Disponible' : 'Indisponible',
                  style: AppTextStyles.caption.copyWith(
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
          Text(
            prestataire.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey[700],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Rating
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.amber[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${prestataire.rating}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${prestataire.totalReviews} avis)',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Price
              Row(
                children: [
                  Icon(
                    Icons.euro,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${prestataire.pricePerHour.toStringAsFixed(0)}€/h',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Experience and Jobs completed
          Row(
            children: [
              Icon(
                Icons.work_history,
                size: 14,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 4),
              Text(
                '${prestataire.completedJobs} travaux terminés',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.phone,
                size: 14,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 4),
              Text(
                prestataire.phone ?? 'Non disponible',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showPrestataireDetails(prestataire),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: Colors.grey[700],
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
                  onPressed: () => _contactPrestataireFromCard(prestataire),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
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

  void _showPrestataireDetails(Prestataire prestataire) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          prestataire.name,
          style: AppTextStyles.h4.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Catégorie: ${prestataire.category}',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(prestataire.description),
            const SizedBox(height: 16),
            Text(
              'Téléphone: ${prestataire.phone}',
              style: AppTextStyles.bodyMedium,
            ),
            Text(
              'Localisation: ${prestataire.location}',
              style: AppTextStyles.bodyMedium,
            ),
            Text(
              'Prix: ${prestataire.pricePerHour.toStringAsFixed(0)}€/h',
              style: AppTextStyles.bodyMedium,
            ),
            Text(
              'Travaux terminés: ${prestataire.completedJobs}',
              style: AppTextStyles.bodyMedium,
            ),
            Row(
              children: [
                Icon(Icons.star, size: 16, color: Colors.amber[600]),
                const SizedBox(width: 4),
                Text(
                  '${prestataire.rating} (${prestataire.totalReviews} avis)',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
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
              _contactPrestataireFromCard(prestataire);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Contacter'),
          ),
        ],
      ),
    );
  }

  void _contactPrestataireFromCard(Prestataire prestataire) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Contacter le prestataire'),
        content: Text(
          'Voulez-vous contacter ${prestataire.name} pour discuter de vos besoins?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implémenter la logique de contact
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Contact avec ${prestataire.name} initié'),
                  backgroundColor: const Color(0xFF8B5CF6),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Envoyer message'),
          ),
        ],
      ),
    );
  }
}