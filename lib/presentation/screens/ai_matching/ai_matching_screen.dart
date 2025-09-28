// lib/presentation/screens/ai_matching/ai_matching_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/ai_matching_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/message_provider.dart';
import '../../../../domain/entities/ai_match.dart';
import '../../../../domain/entities/conversation.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../presentation/widgets/ai_match_card.dart';

class AIMatchingScreen extends ConsumerStatefulWidget {
  final String serviceRequestId;
  final String? title;

  const AIMatchingScreen({
    super.key,
    required this.serviceRequestId,
    this.title,
  });

  @override
  ConsumerState<AIMatchingScreen> createState() => _AIMatchingScreenState();
}

class _AIMatchingScreenState extends ConsumerState<AIMatchingScreen> {
  String _sortBy = 'compatibility';
  double _minScore = 30.0;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMatches();
    });
  }

  Future<void> _loadMatches() async {
    final authState = ref.read(authProvider);
    if (authState.token != null) {
      // D'abord essayer de récupérer les matches existants
      await ref.read(aiMatchingProvider.notifier).getMatchesForRequest(
        serviceRequestId: widget.serviceRequestId,
        token: authState.token!,
      );
      
      // Si aucun match n'existe, en générer de nouveaux
      final state = ref.read(aiMatchingProvider);
      if (state.matches.isEmpty) {
        await _generateNewMatches();
      }
    }
  }

  Future<void> _generateNewMatches() async {
    final authState = ref.read(authProvider);
    if (authState.token != null) {
      print('🔄 Génération de nouveaux matches...');
      await ref.read(aiMatchingProvider.notifier).generateMatches(
        serviceRequestId: widget.serviceRequestId,
        token: authState.token!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiMatchingProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.title ?? 'Recommandations IA',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _generateNewMatches,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtres
          if (_showFilters) _buildFilters(),
          
          // Contenu principal
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.matches.isEmpty
                    ? _buildEmptyState()
                    : _buildMatchesList(state),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Score minimum: ${_minScore.toInt()}%',
                  style: AppTextStyles.bodyMedium,
                ),
              ),
              Slider(
                value: _minScore,
                min: 0,
                max: 100,
                divisions: 10,
                onChanged: (value) {
                  setState(() {
                    _minScore = value;
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: _sortBy,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 'compatibility', child: Text('Compatibilité')),
                    DropdownMenuItem(value: 'rating', child: Text('Note')),
                    DropdownMenuItem(value: 'price', child: Text('Prix')),
                    DropdownMenuItem(value: 'distance', child: Text('Distance')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _sortBy = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.psychology_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune recommandation',
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
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _generateNewMatches,
            icon: const Icon(Icons.refresh),
            label: const Text('Générer les recommandations'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchesList(AIMatchingState state) {
    final filteredMatches = state.matches.where((match) => 
      match.compatibilityScore >= _minScore
    ).toList();

    // Trier les matches
    filteredMatches.sort((a, b) {
      switch (_sortBy) {
        case 'rating':
          return (b.prestataire?.rating ?? 0).compareTo(a.prestataire?.rating ?? 0);
        case 'price':
          return (a.prestataire?.pricePerHour ?? 0).compareTo(b.prestataire?.pricePerHour ?? 0);
        case 'distance':
          return (a.distance ?? 0).compareTo(b.distance ?? 0);
        default:
          return b.compatibilityScore.compareTo(a.compatibilityScore);
      }
    });

    return Column(
      children: [
        // En-tête avec statistiques
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${filteredMatches.length} recommandations trouvées',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  _showFilters ? Icons.filter_list : Icons.filter_list_outlined,
                  color: AppColors.primaryBlue,
                ),
                onPressed: () {
                  setState(() {
                    _showFilters = !_showFilters;
                  });
                },
              ),
            ],
          ),
        ),
        
        // Liste des matches
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredMatches.length,
            itemBuilder: (context, index) {
              final match = filteredMatches[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: AIMatchCard(
                  match: match,
                  onTap: () => _showMatchDetails(match),
                  onContactMatch: _contactPrestataire,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showMatchDetails(AIMatch match) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _MatchDetailsModal(match: match),
    );
  }

  /// Contacte un prestataire et ouvre directement la boîte de discussion
  Future<void> _contactPrestataire(AIMatch match) async {
    if (match.prestataire == null) return;

    final authState = ref.read(authProvider);
    final token = authState.token;
    
    if (token == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vous devez être connecté pour contacter un prestataire'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
          (conv) => conv.prestataireId == match.prestataire!.id,
        );
      } catch (e) {
        existingConversation = null;
      }
      
      Conversation? conversation;
      
      if (existingConversation != null) {
        conversation = existingConversation;
        print('✅ Conversation existante trouvée: ${conversation.id}');
      } else {
        // Créer une nouvelle conversation
        conversation = await ref.read(messagesProvider.notifier).createConversation(
          prestataireId: match.prestataire!.id,
          token: token,
        );
        print('✅ Nouvelle conversation créée: ${conversation?.id}');
      }
      
      // Fermer l'indicateur de chargement
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      
      if (conversation != null && mounted) {
        // Naviguer vers le chat
        context.push('/messages/chat/${conversation.id}');
        print('✅ Navigation vers le chat: /messages/chat/${conversation.id}');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la création de la conversation'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Fermer l'indicateur de chargement
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('❌ Erreur lors du contact: $e');
    }
  }
}

class _MatchDetailsModal extends StatelessWidget {
  final AIMatch match;

  const _MatchDetailsModal({required this.match});

  @override
  Widget build(BuildContext context) {
    final prestataire = match.prestataire;
    if (prestataire == null) {
      return const SizedBox.shrink();
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // En-tête
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: prestataire.profileImage != null
                      ? NetworkImage(prestataire.profileImage!)
                      : null,
                  child: prestataire.profileImage == null
                      ? Text(
                          prestataire.name.isNotEmpty 
                              ? prestataire.name[0].toUpperCase()
                              : 'P',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                        style: AppTextStyles.h3.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        prestataire.category,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      if (prestataire.location.isNotEmpty)
                        Text(
                          prestataire.location,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          
          // Contenu scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Score de compatibilité
                  _buildCompatibilityScore(),
                  const SizedBox(height: 24),
                  
                  // Description
                  if (prestataire.bio?.isNotEmpty == true) ...[
                    Text(
                      'À propos',
                      style: AppTextStyles.h4.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      prestataire.bio ?? '',
                      style: AppTextStyles.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Statistiques détaillées
                  _buildDetailedStats(prestataire),
                  const SizedBox(height: 24),
                  
                  // Raisonnement IA
                  _buildReasoningSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompatibilityScore() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getScoreColor(match.compatibilityScore).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getScoreColor(match.compatibilityScore).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.psychology,
            color: _getScoreColor(match.compatibilityScore),
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Score de compatibilité',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${match.compatibilityScore.toStringAsFixed(1)}%',
                  style: AppTextStyles.h2.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _getScoreColor(match.compatibilityScore),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedStats(prestataire) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistiques détaillées',
          style: AppTextStyles.h4.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Note et avis
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Note Moyenne',
                '${prestataire.rating.toStringAsFixed(1)}/5',
                Icons.star,
                Colors.amber,
                subtitle: '${prestataire.totalReviews} avis',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Avis Reçus',
                '${prestataire.totalReviews}',
                Icons.rate_review,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Travaux et gains
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Travaux Terminés',
                '${prestataire.completedJobs}',
                Icons.work,
                Colors.green,
                subtitle: prestataire.completedJobs > 0 
                    ? '${(prestataire.totalEarnings / prestataire.completedJobs).toStringAsFixed(0)} FCFA/travail'
                    : 'Nouveau prestataire',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Gains Totaux',
                '${(prestataire.totalEarnings / 1000).toStringAsFixed(0)}k FCFA',
                Icons.account_balance_wallet,
                Colors.purple,
                subtitle: '${prestataire.completedJobs} travaux',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Prix et disponibilité
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Prix/Horaire',
                '${prestataire.pricePerHour.toStringAsFixed(0)} FCFA',
                Icons.attach_money,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Statut',
                prestataire.isAvailable ? 'Disponible' : 'Occupé',
                prestataire.isAvailable ? Icons.check_circle : Icons.schedule,
                prestataire.isAvailable ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReasoningSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analyse IA',
          style: AppTextStyles.h4.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primaryBlue.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.psychology,
                    color: AppColors.primaryBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Raisonnement',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                match.reasoning,
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, {String? subtitle}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.h4.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: color.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}
