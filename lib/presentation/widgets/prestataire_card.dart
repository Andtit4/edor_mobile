import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/prestataire.dart';
import '../../core/theme/app_colors.dart';

class PrestataireCard extends StatelessWidget {
  final Prestataire prestataire;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final bool isFavorite;

  const PrestataireCard({
    super.key,
    required this.prestataire,
    required this.onTap,
    required this.onFavoriteToggle,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec avatar, nom et favori
              Row(
                children: [
                  // Avatar
                  Hero(
                    tag: 'avatar_${prestataire.id}',
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.gray200,
                      backgroundImage:
                          prestataire.avatar != null
                              ? CachedNetworkImageProvider(prestataire.avatar!)
                              : null,
                      child:
                          prestataire.avatar == null
                              ? Text(
                                prestataire.name.isNotEmpty
                                    ? prestataire.name[0].toUpperCase()
                                    : '?',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(color: AppColors.gray600),
                              )
                              : null,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Nom et informations
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prestataire.name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: AppColors.gray600,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                prestataire.location,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.gray600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 14,
                              color: AppColors.accentYellow,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${prestataire.rating}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              ' (${prestataire.totalReviews} avis)',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.gray600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Bouton favori
                  IconButton(
                    onPressed: onFavoriteToggle,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? AppColors.error : AppColors.gray400,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Catégorie
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  prestataire.category,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Description
              Text(
                prestataire.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Compétences (chips)
              if (prestataire.skills.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children:
                      prestataire.skills.take(3).map((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gray100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            skill,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        );
                      }).toList(),
                ),

              const SizedBox(height: 12),

              // Footer avec prix et statut
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Prix
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${prestataire.pricePerHour} FCFA',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        TextSpan(
                          text: '/heure',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.gray600),
                        ),
                      ],
                    ),
                  ),

                  // Statut disponibilité
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          prestataire.isAvailable
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.gray200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color:
                                prestataire.isAvailable
                                    ? AppColors.success
                                    : AppColors.gray500,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          prestataire.isAvailable ? 'Disponible' : 'Occupé',
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(
                            color:
                                prestataire.isAvailable
                                    ? AppColors.success
                                    : AppColors.gray600,
                            fontWeight: FontWeight.w500,
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
      ),
    );
  }
}
