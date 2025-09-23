// lib/presentation/widgets/ai_match_card.dart
import 'package:flutter/material.dart';
import '../../domain/entities/ai_match.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class AIMatchCard extends StatelessWidget {
  final AIMatch match;
  final VoidCallback? onTap;
  final VoidCallback? onContact;
  final Function(AIMatch)? onContactMatch;

  const AIMatchCard({
    super.key,
    required this.match,
    this.onTap,
    this.onContact,
    this.onContactMatch,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec photo de profil et informations
              Row(
                children: [
                  // Photo de profil ou avatar
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                    backgroundImage: match.prestataire?.profileImage != null
                        ? NetworkImage(match.prestataire!.profileImage!)
                        : null,
                    child: match.prestataire?.profileImage == null
                        ? Icon(
                            Icons.person,
                            size: 24,
                            color: AppColors.primaryBlue,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          match.prestataire?.name ?? 'Prestataire',
                          style: AppTextStyles.h4.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          match.prestataire?.category ?? 'Catégorie',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getScoreColor(match.compatibilityScore),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${match.compatibilityScore.toInt()}%',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Barre de score de compatibilité
              _buildCompatibilityBar(),
              const SizedBox(height: 12),
              // Informations clés
              _buildKeyInfo(),
              const SizedBox(height: 12),
              // Raisonnement IA (tronqué)
              _buildReasoningPreview(),
              const SizedBox(height: 16),
              // Actions
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompatibilityBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Compatibilité',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${match.compatibilityScore.toStringAsFixed(1)}%',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: _getScoreColor(match.compatibilityScore),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: match.compatibilityScore / 100,
          backgroundColor: _getScoreColor(match.compatibilityScore).withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(_getScoreColor(match.compatibilityScore)),
        ),
      ],
    );
  }

  Widget _buildKeyInfo() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (match.prestataire != null) ...[
          // Note avec étoiles et avis
          _buildInfoChip(
            Icons.star,
            '${match.prestataire!.rating.toStringAsFixed(1)}/5 (${match.prestataire!.totalReviews} avis)',
            Colors.amber,
          ),
          // Nombre de travaux
          _buildInfoChip(
            Icons.work,
            '${match.prestataire!.completedJobs} travaux',
            Colors.blue,
          ),
          // Solde total estimé avec nombre de travaux
          _buildInfoChip(
            Icons.account_balance_wallet,
            '${(match.prestataire!.totalEarnings / 1000).toStringAsFixed(0)}k FCFA (${match.prestataire!.completedJobs} travaux)',
            Colors.green,
          ),
        ],
        if (match.distance != null) ...[
          // Distance
          _buildInfoChip(
            Icons.location_on,
            '${match.distance!.toStringAsFixed(1)} km',
            Colors.red,
          ),
        ],
        if (match.estimatedPrice != null) ...[
          // Prix estimé
          _buildInfoChip(
            Icons.attach_money,
            '${match.estimatedPrice!.toStringAsFixed(0)} FCFA',
            Colors.purple,
          ),
        ],
        // Disponibilité
        if (match.prestataire?.isAvailable == true) ...[
          _buildInfoChip(
            Icons.check_circle,
            'Disponible',
            Colors.green,
          ),
        ] else ...[
          _buildInfoChip(
            Icons.schedule,
            'Occupé',
            Colors.orange,
          ),
        ],
      ],
    );
  }


  void _onContactPressed(AIMatch match) {
    if (onContactMatch != null) {
      onContactMatch!(match);
    } else if (onContact != null) {
      onContact!();
    } else {
      print('Contacter ${match.prestataire?.name}');
    }
  }

  void _onViewDetailsPressed(AIMatch match) {
    if (onTap != null) {
      onTap!();
    } else {
      print('Voir détails de ${match.prestataire?.name}');
    }
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReasoningPreview() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primaryBlue.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.psychology,
            size: 16,
            color: AppColors.primaryBlue,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _truncateText(match.reasoning, 80),
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primaryBlue,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _onViewDetailsPressed(match),
            icon: const Icon(Icons.info_outline, size: 16),
            label: const Text('Détails'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryBlue,
              side: BorderSide(color: AppColors.primaryBlue),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _onContactPressed(match),
            icon: const Icon(Icons.message, size: 16),
            label: const Text('Contacter'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}
