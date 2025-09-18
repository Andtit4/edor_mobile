// lib/presentation/screens/prestataire_detail/prestataire_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/prestataire_provider.dart';
import '../../providers/review_provider.dart';

class PrestataireDetailScreen extends ConsumerWidget {
  final String prestataireId;

  const PrestataireDetailScreen({
    super.key,
    required this.prestataireId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prestataireState = ref.watch(prestataireProvider(prestataireId));

    return Scaffold(
      body: _buildBody(context, ref, prestataireState),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, PrestataireState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text('Erreur: ${state.error}'),
            const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Retour'),
              ),
          ],
        ),
      );
    }

    final prestataire = state.prestataire;
    if (prestataire == null) {
      return const Center(child: Text('Prestataire non trouvé'));
    }

    return CustomScrollView(
      slivers: [
        _buildAppBar(context, prestataire),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPrestataireInfo(prestataire),
                const SizedBox(height: 24),
                _buildAboutSection(prestataire),
                const SizedBox(height: 24),
                _buildSkillsSection(prestataire),
                const SizedBox(height: 24),
                _buildPortfolioSection(prestataire),
                const SizedBox(height: 24),
                _buildReviewsSection(prestataire),
                const SizedBox(height: 100), // Espace pour le bottom bar
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildAppBar(BuildContext context, prestataire) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Image de fond
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF8B5CF6).withOpacity(0.8),
                    const Color(0xFF8B5CF6),
                  ],
                ),
              ),
            ),
            // Contenu
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prestataire.name,
                    style: AppTextStyles.h2.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber[400],
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        prestataire.rating.toStringAsFixed(1),
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${prestataire.reviewCount} avis)',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.white.withOpacity(0.8),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        prestataire.location,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Ajouter aux favoris
          },
          icon: const Icon(Icons.favorite_border, color: Colors.white),
        ),
        IconButton(
          onPressed: () {
            // Partager
          },
          icon: const Icon(Icons.share, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildPrestataireInfo(prestataire) {
    return Container(
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
              CircleAvatar(
                radius: 30,
                backgroundImage: prestataire.avatar != null 
                    ? NetworkImage(prestataire.avatar!) 
                    : null,
                child: prestataire.avatar == null 
                    ? Text(
                        prestataire.name.isNotEmpty ? prestataire.name[0].toUpperCase() : 'P',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                      style: AppTextStyles.h3.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      prestataire.category,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: const Color(0xFF8B5CF6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber[600],
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          prestataire.rating.toStringAsFixed(1),
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${prestataire.reviewCount} avis)',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: prestataire.isAvailable 
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  prestataire.isAvailable ? 'Disponible' : 'Indisponible',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: prestataire.isAvailable ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoItem(
                Icons.work,
                '${prestataire.completedJobs} missions',
                Colors.blue,
              ),
              const SizedBox(width: 24),
              _buildInfoItem(
                Icons.euro,
                '${prestataire.pricePerHour}€/h',
                Colors.green,
              ),
              const SizedBox(width: 24),
              _buildInfoItem(
                Icons.location_on,
                prestataire.location,
                Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.grey[700],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(prestataire) {
    return Container(
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
          Text(
            'À propos',
            style: AppTextStyles.h4.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            prestataire.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection(prestataire) {
    if (prestataire.skills.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
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
          Text(
            'Compétences',
            style: AppTextStyles.h4.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: prestataire.skills.map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  skill,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF8B5CF6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioSection(prestataire) {
    if (prestataire.portfolio.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
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
          Text(
            'Portfolio',
            style: AppTextStyles.h4.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: prestataire.portfolio.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(prestataire.portfolio[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(prestataire) {
    return Consumer(
      builder: (context, ref, child) {
        final reviewsState = ref.watch(prestataireReviewsProvider(prestataire.id));
        
        return Container(
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
                  Text(
                    'Avis (${prestataire.reviewCount})',
                    style: AppTextStyles.h4.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  const Spacer(),
                  if (reviewsState.reviews.length > 3)
                    TextButton(
                      onPressed: () {
                        // Voir tous les avis
                      },
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
              const SizedBox(height: 12),
              if (reviewsState.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (reviewsState.error != null)
                Center(
                  child: Text(
                    'Erreur lors du chargement des avis',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.red,
                    ),
                  ),
                )
              else if (reviewsState.reviews.isEmpty)
                Center(
                  child: Text(
                    'Aucun avis pour le moment',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                )
              else
                ...reviewsState.reviews.take(3).map((review) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildReviewItem(
                    review.clientName ?? 'Client anonyme',
                    review.comment ?? 'Aucun commentaire',
                    review.rating,
                    _formatDate(review.createdAt),
                  ),
                )).toList(),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Date inconnue';
    
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return 'Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'Il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'À l\'instant';
    }
  }

  Widget _buildReviewItem(String name, String comment, int rating, String date) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                child: Text(
                  name[0],
                  style: const TextStyle(
                    fontSize: 12,
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
                      name,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      date,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber[600],
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}