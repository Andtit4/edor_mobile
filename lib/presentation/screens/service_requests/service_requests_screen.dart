// lib/presentation/screens/service_requests/service_requests_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/service_request.dart';
import '../../../domain/entities/user.dart';
import '../../providers/service_request_provider.dart';
import '../../providers/auth_provider.dart';

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

  void _loadData() {
    final authState = ref.read(authProvider);
    final token = authState.token;
    
    print('=== DEBUG SERVICE REQUESTS ===');
    print('Auth state: ${authState.isAuthenticated}');
    print('User: ${authState.user?.email}');
    print('Token: ${token?.substring(0, 20)}...');
    print('==============================');
    
    if (token != null) {
      // Charger toutes les demandes (pour le premier onglet)
      ref.read(serviceRequestProvider.notifier).loadAllRequests();
      
      // ✅ AJOUTER CETTE LIGNE - Charger les demandes de l'utilisateur connecté
      ref.read(serviceRequestProvider.notifier).loadMyRequests(token);
      
      // Charger les demandes assignées à l'utilisateur (pour les prestataires)
      if (authState.user?.role == UserRole.prestataire) {
        ref.read(serviceRequestProvider.notifier).loadAssignedRequests(token);
      }
    } else {
      print('No token available for loading requests');
      _loadDataFromCache();
    }
  }

  void _loadDataFromCache() async {
    try {
      final localDataSource = ref.read(localDataSourceProvider);
      final tokenData = await localDataSource.getFromCache('auth_token');
      final token = tokenData?['token'] as String?;
      
      print('Token from cache: ${token?.substring(0, 20)}...');
      
      if (token != null) {
        // Charger toutes les demandes
        ref.read(serviceRequestProvider.notifier).loadAllRequests();
        
        // ✅ AJOUTER CETTE LIGNE - Charger les demandes de l'utilisateur
        ref.read(serviceRequestProvider.notifier).loadMyRequests(token);
      }
    } catch (e) {
      print('Error loading token from cache: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final requestState = ref.watch(serviceRequestProvider);
    
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
                  _buildRequestsList(requestState.allRequests),
                  _buildMyAcceptedRequests(requestState.myRequests),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Text(
            'Demandes de service',
            style: AppTextStyles.h2.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // Filtres avancés
            },
            icon: const Icon(
              Icons.filter_list,
              color: Color(0xFF8B5CF6),
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
        borderRadius: BorderRadius.circular(25),
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
          hintText: 'Rechercher une demande...',
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: Colors.grey[500],
          ),
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[500],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 16),
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
              selectedColor: const Color(0xFF8B5CF6).withOpacity(0.2),
              checkmarkColor: const Color(0xFF8B5CF6),
              labelStyle: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? const Color(0xFF8B5CF6) : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabBar() {
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
        tabs: const [
          Tab(text: 'Toutes les demandes'),
          Tab(text: 'Mes demandes'),
        ],
      ),
    );
  }

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
      margin: const EdgeInsets.only(bottom: 16),
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
              Icon(
                Icons.person,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
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
              Text(
                '${request.budget.toStringAsFixed(0)}€',
                style: AppTextStyles.bodySmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
              if (request.status == 'pending')
                ElevatedButton(
                  onPressed: () => _acceptRequest(request),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Accepter',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (request.status == 'assigned' || request.status == 'in_progress')
                ElevatedButton(
                  onPressed: () => _completeRequest(request),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Terminer',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _acceptRequest(ServiceRequest request) {
    final authState = ref.read(authProvider);
    final user = authState.user;
    final token = authState.token;
    
    if (user != null && token != null) {
      ref.read(serviceRequestProvider.notifier).acceptRequest(
        request.id,
        token,
      );
    }
  }

  void _completeRequest(ServiceRequest request) {
    final authState = ref.read(authProvider);
    final token = authState.token;
    
    if (token != null) {
      ref.read(serviceRequestProvider.notifier).completeRequest(request.id, token);
    }
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}