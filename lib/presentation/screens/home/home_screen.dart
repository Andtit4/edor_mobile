import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/prestataire_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/entities/prestataire.dart';
import '../../../domain/entities/service_request.dart';
import '../../../domain/entities/service_offer.dart';
import '../../router/app_routes.dart';

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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            final authState = ref.watch(authProvider);
            final user = authState.user;
            
            if (user == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                // Header
                _buildHeader(user),
                
                // Search Bar
                _buildSearchBar(),
                
                // Quick Actions based on role
                _buildQuickActions(user.role),
                
                // Content based on role
                Expanded(
                  child: user.role == UserRole.prestataire 
                      ? _buildPrestataireContent()
                      : _buildClientContent(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(User user) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bonjour,',
                style: AppTextStyles.h2.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                user.lastName + ' ' + user.firstName,
                style: AppTextStyles.h2.copyWith(
                  color: const Color(0xFF1F2937),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.role == UserRole.prestataire 
                    ? 'Prestataire de services'
                    : 'Demandeur de services',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[600],
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
          hintText: 'Rechercher...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          border: InputBorder.none,
          suffixIcon: Icon(Icons.tune, color: Colors.grey[400]),
        ),
      ),
    );
  }

  Widget _buildQuickActions(UserRole role) {
    if (role == UserRole.prestataire) {
      return _buildPrestataireQuickActions();
    } else {
      return _buildClientQuickActions();
    }
  }

  Widget _buildPrestataireQuickActions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actions rapides',
            style: AppTextStyles.h4.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  title: 'Nouvelles demandes',
                  subtitle: 'Voir les demandes',
                  icon: Icons.request_quote,
                  color: const Color(0xFF8B5CF6),
                  onTap: () => context.push(AppRoutes.serviceRequests),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  title: 'Mes missions',
                  subtitle: 'Suivre mes travaux',
                  icon: Icons.work,
                  color: const Color(0xFF10B981),
                  onTap: () => context.push(AppRoutes.serviceRequests),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClientQuickActions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actions rapides',
            style: AppTextStyles.h4.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  title: 'Trouver un prestataire',
                  subtitle: 'Voir les offres',
                  icon: Icons.search,
                  color: const Color(0xFF8B5CF6),
                  onTap: () => context.push(AppRoutes.serviceOffers),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  title: 'Créer une demande',
                  subtitle: 'Demander un service',
                  icon: Icons.add,
                  color: const Color(0xFF10B981),
                  onTap: () => context.push(AppRoutes.createRequest),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey[600],
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
        _buildSectionHeader('Demandes récentes', () => context.push(AppRoutes.serviceRequests)),
        Expanded(
          child: _buildRecentRequestsList(),
        ),
      ],
    );
  }

  Widget _buildClientContent() {
    return Column(
      children: [
        // Popular Services
        _buildSectionHeader('Prestataires populaires', () => context.push(AppRoutes.serviceOffers)),
        Expanded(
          child: _buildPopularServicesList(),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Text(
            title,
            style: AppTextStyles.h4.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: onSeeAll,
            child: Text(
              'Voir tout',
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFF8B5CF6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentRequestsList() {
    // Mock data for recent requests
    final requests = [
      {
        'title': 'Réparation de robinet qui fuit',
        'category': 'Plomberie',
        'location': 'Paris 15ème',
        'budget': 80.0,
        'time': 'Il y a 2h',
        'client': 'Marie Dubois',
        'status': 'pending',
      },
      {
        'title': 'Installation de prises électriques',
        'category': 'Électricité',
        'location': 'Lyon 3ème',
        'budget': 150.0,
        'time': 'Il y a 4h',
        'client': 'Pierre Martin',
        'status': 'pending',
      },
      {
        'title': 'Peinture d\'une chambre',
        'category': 'Peinture',
        'location': 'Marseille 8ème',
        'budget': 200.0,
        'time': 'Il y a 1j',
        'client': 'Sophie Leroy',
        'status': 'in_progress',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return _buildRequestCard(request);
      },
    );
  }

  Widget _buildPopularServicesList() {
    // Mock data for popular services
    final services = [
      {
        'title': 'Services de plomberie professionnels',
        'category': 'Plomberie',
        'rating': 4.8,
        'price': 60.0,
        'prestataire': 'Jean Plombier',
        'location': 'Paris et région parisienne',
        'reviews': 127,
      },
      {
        'title': 'Électricien qualifié - Tous travaux',
        'category': 'Électricité',
        'rating': 4.9,
        'price': 70.0,
        'prestataire': 'Marc Électricien',
        'location': 'Lyon et environs',
        'reviews': 89,
      },
      {
        'title': 'Peintre en bâtiment - Finitions soignées',
        'category': 'Peinture',
        'rating': 4.7,
        'price': 45.0,
        'prestataire': 'Paul Peintre',
        'location': 'Marseille et région',
        'reviews': 156,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return _buildServiceCard(service);
      },
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
    final colors = {
      'Plomberie': const Color(0xFF8B5CF6),
      'Électricité': const Color(0xFF06B6D4),
      'Peinture': const Color(0xFF10B981),
      'Bricolage': const Color(0xFFF59E0B),
      'Jardinage': const Color(0xFFEF4444),
      'Nettoyage': const Color(0xFF8B5CF6),
    };

    final color = colors[request['category']] ?? const Color(0xFF8B5CF6);
    final statusColor = request['status'] == 'pending' 
        ? const Color(0xFFF59E0B) 
        : const Color(0xFF06B6D4);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
                  _getCategoryIcon(request['category']),
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
                      request['title'],
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${request['client']} • ${request['location']}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  request['status'] == 'pending' ? 'En attente' : 'En cours',
                  style: AppTextStyles.caption.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.euro,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                '${request['budget'].toStringAsFixed(0)}€',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                request['time'],
                style: AppTextStyles.caption.copyWith(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    final colors = {
      'Plomberie': const Color(0xFF8B5CF6),
      'Électricité': const Color(0xFF06B6D4),
      'Peinture': const Color(0xFF10B981),
      'Bricolage': const Color(0xFFF59E0B),
      'Jardinage': const Color(0xFFEF4444),
      'Nettoyage': const Color(0xFF8B5CF6),
    };

    final color = colors[service['category']] ?? const Color(0xFF8B5CF6);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: color.withOpacity(0.1),
                child: Text(
                  service['prestataire'][0],
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['prestataire'],
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      service['title'],
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
                          service['location'],
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
          const SizedBox(height: 12),
          Row(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.amber[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${service['rating']}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${service['reviews']} avis)',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    Icons.euro,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${service['price'].toStringAsFixed(0)}€/h',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Plomberie':
        return Icons.plumbing;
      case 'Électricité':
        return Icons.electrical_services;
      case 'Peinture':
        return Icons.format_paint;
      case 'Bricolage':
        return Icons.build;
      case 'Jardinage':
        return Icons.local_florist;
      case 'Nettoyage':
        return Icons.cleaning_services;
      default:
        return Icons.work;
    }
  }
}