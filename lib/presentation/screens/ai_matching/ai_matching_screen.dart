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
                // Espace flexible pour centrer le contenu
                SizedBox(height: screenHeight * 0.02),
                
                // Header amélioré
                _buildEnhancedHeader(),
                
                SizedBox(height: screenHeight * 0.025),
                
                // Search Bar amélioré
                _buildEnhancedSearchBar(),
                
                SizedBox(height: screenHeight * 0.025),
                
                // Filtres améliorés
                if (_showFilters) _buildEnhancedFilters(),
                
                SizedBox(height: screenHeight * 0.02),
                
                // Contenu principal
                SizedBox(
                  height: screenHeight * 0.6,
                  child: state.isLoading
                      ? _buildLoadingState()
                      : state.matches.isEmpty
                          ? _buildEmptyState()
                          : _buildMatchesList(state),
                ),
                
                // Espace en bas
                SizedBox(height: screenHeight * 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construit le header amélioré avec design glassmorphism
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
          // Bouton retour stylisé
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.purple.withOpacity(0.1),
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
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.purple,
                size: 20,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          
          const SizedBox(width: 20),
          
          // Icône IA avec gradient
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
            child: Icon(
              Icons.psychology,
              color: AppColors.purple,
              size: 30,
            ),
          ),
          
          const SizedBox(width: 20),
          
          // Titre et description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title ?? 'Recommandations IA',
                  style: AppTextStyles.h2.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Trouvez le prestataire parfait',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Bouton refresh stylisé
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.purple.withOpacity(0.1),
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
              icon: Icon(
                Icons.refresh,
                color: AppColors.purple,
                size: 20,
              ),
              onPressed: _generateNewMatches,
            ),
          ),
        ],
      ),
    );
  }

  /// Construit la barre de recherche améliorée
  Widget _buildEnhancedSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.borderColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
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
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Rechercher un prestataire...',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construit l'état de chargement amélioré
  Widget _buildLoadingState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.borderColor.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: AppColors.purpleGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.purple.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Analyse en cours...',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'L\'IA recherche les meilleurs prestataires',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit les filtres améliorés
  Widget _buildEnhancedFilters() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.borderColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
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
                  Icons.tune,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Filtres',
                style: AppTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Tri par
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lightGray.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.borderColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.sort,
                  color: AppColors.purple,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Trier par:',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<String>(
                    value: _sortBy,
                    onChanged: (value) {
                      setState(() {
                        _sortBy = value!;
                      });
                    },
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.purple,
                      fontWeight: FontWeight.w600,
                    ),
                    underline: Container(),
                    items: const [
                      DropdownMenuItem(value: 'compatibility', child: Text('Compatibilité')),
                      DropdownMenuItem(value: 'rating', child: Text('Note')),
                      DropdownMenuItem(value: 'price', child: Text('Prix')),
                      DropdownMenuItem(value: 'distance', child: Text('Distance')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Score minimum
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lightGray.withOpacity(0.3),
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
                      Icons.trending_up,
                      color: AppColors.purple,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Score minimum: ${_minScore.toInt()}%',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.purple,
                    inactiveTrackColor: AppColors.purple.withOpacity(0.2),
                    thumbColor: AppColors.purple,
                    overlayColor: AppColors.purple.withOpacity(0.1),
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  ),
                  child: Slider(
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Construit l'état vide amélioré
  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.borderColor.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
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
                  color: AppColors.purple.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.psychology_outlined,
                size: 40,
                color: AppColors.purple,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Aucune recommandation',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Aucun prestataire ne correspond à vos critères actuels',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
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
              child: ElevatedButton.icon(
                onPressed: _generateNewMatches,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  'Générer les recommandations',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit la liste des matches améliorée
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
        // En-tête avec statistiques amélioré
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.borderColor.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
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
                  Icons.psychology,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${filteredMatches.length} recommandations trouvées',
                      style: AppTextStyles.h3.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Basées sur vos critères',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13,
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
                    color: AppColors.purple.withOpacity(0.1),
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
                  icon: Icon(
                    _showFilters ? Icons.filter_list : Icons.filter_list_outlined,
                    color: AppColors.purple,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _showFilters = !_showFilters;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Liste des matches
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.06,
              vertical: 20,
            ),
            itemCount: filteredMatches.length,
            itemBuilder: (context, index) {
              final match = filteredMatches[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
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
