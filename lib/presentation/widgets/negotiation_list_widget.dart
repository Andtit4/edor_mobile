// lib/presentation/widgets/negotiation_list_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/price_converter.dart';
import '../../domain/entities/price_negotiation.dart';
import '../providers/price_negotiation_provider.dart';
import '../providers/auth_provider.dart';
import 'price_negotiation_dialog.dart';

class NegotiationListWidget extends ConsumerWidget {
  final String serviceRequestId;
  final double currentBudget;

  const NegotiationListWidget({
    super.key,
    required this.serviceRequestId,
    required this.currentBudget,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final negotiationsState = ref.watch(priceNegotiationProvider);
    final authState = ref.watch(authProvider);
    final currentUser = authState.user;

    // Charger les négociations si elles ne sont pas déjà chargées
    if (negotiationsState.negotiations.isEmpty && !negotiationsState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (authState.token != null) {
          ref.read(priceNegotiationProvider.notifier).loadNegotiationsByServiceRequest(
            serviceRequestId: serviceRequestId,
            token: authState.token!,
          );
        }
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Négociations de prix',
              style: AppTextStyles.h4.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (currentUser != null) ...[
              ElevatedButton.icon(
                onPressed: () => _showNegotiationDialog(context, ref),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Négocier'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        if (negotiationsState.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (negotiationsState.negotiations.isEmpty)
          _buildEmptyState()
        else
          _buildNegotiationsList(negotiationsState.negotiations, ref),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.handshake_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune négociation',
            style: AppTextStyles.h4.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Commencez une négociation de prix',
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNegotiationsList(List<PriceNegotiation> negotiations, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: negotiations.length,
      itemBuilder: (context, index) {
        final negotiation = negotiations[index];
        return _buildNegotiationCard(negotiation, ref);
      },
    );
  }

  Widget _buildNegotiationCard(PriceNegotiation negotiation, WidgetRef ref) {
    final authState = ref.read(authProvider);
    final currentUser = authState.user;
    final isCurrentUser = currentUser?.role.name == 'prestataire' 
        ? negotiation.isFromPrestataire 
        : !negotiation.isFromPrestataire;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrentUser ? const Color(0xFF8B5CF6).withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentUser ? const Color(0xFF8B5CF6) : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                PriceConverter.formatEuroToFcfa(negotiation.proposedPrice),
                style: AppTextStyles.h4.copyWith(
                  color: const Color(0xFF8B5CF6),
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildStatusChip(negotiation.status),
            ],
          ),
          const SizedBox(height: 8),
          if (negotiation.message != null) ...[
            Text(
              negotiation.message!,
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                negotiation.isFromPrestataire ? 'Prestataire' : 'Client',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              Text(
                _formatDate(negotiation.createdAt),
                style: AppTextStyles.caption.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          if (negotiation.status == NegotiationStatus.pending && !isCurrentUser) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _rejectNegotiation(negotiation, ref),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text('Rejeter'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _acceptNegotiation(negotiation, ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Accepter'),
                  ),
                ),
              ],
            ),
          ],
          if (negotiation.status == NegotiationStatus.pending && isCurrentUser) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showCounterProposalDialog(negotiation, ref),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF8B5CF6),
                      side: const BorderSide(color: Color(0xFF8B5CF6)),
                    ),
                    child: const Text('Contre-proposer'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusChip(NegotiationStatus status) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case NegotiationStatus.pending:
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange[700]!;
        text = 'En attente';
        break;
      case NegotiationStatus.accepted:
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green[700]!;
        text = 'Accepté';
        break;
      case NegotiationStatus.rejected:
        backgroundColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red[700]!;
        text = 'Rejeté';
        break;
      case NegotiationStatus.countered:
        backgroundColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue[700]!;
        text = 'Contre-proposé';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return 'Il y a ${difference.inMinutes}min';
    } else {
      return 'À l\'instant';
    }
  }

  void _showNegotiationDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => PriceNegotiationDialog(
        serviceRequestId: serviceRequestId,
        currentBudget: currentBudget,
        isFromPrestataire: ref.read(authProvider).user?.role.name == 'prestataire',
      ),
    ).then((negotiation) {
      if (negotiation != null) {
        // Recharger les négociations
        final authState = ref.read(authProvider);
        if (authState.token != null) {
          ref.read(priceNegotiationProvider.notifier).loadNegotiationsByServiceRequest(
            serviceRequestId: serviceRequestId,
            token: authState.token!,
          );
        }
      }
    });
  }

  void _showCounterProposalDialog(PriceNegotiation negotiation, WidgetRef ref) {
    showDialog(
      context: ref.context,
      builder: (context) => PriceNegotiationDialog(
        serviceRequestId: serviceRequestId,
        currentBudget: currentBudget,
        parentNegotiation: negotiation,
        isFromPrestataire: ref.read(authProvider).user?.role.name == 'prestataire',
      ),
    ).then((newNegotiation) {
      if (newNegotiation != null) {
        // Recharger les négociations
        final authState = ref.read(authProvider);
        if (authState.token != null) {
          ref.read(priceNegotiationProvider.notifier).loadNegotiationsByServiceRequest(
            serviceRequestId: serviceRequestId,
            token: authState.token!,
          );
        }
      }
    });
  }

  Future<void> _acceptNegotiation(PriceNegotiation negotiation, WidgetRef ref) async {
    final authState = ref.read(authProvider);
    if (authState.token == null) return;

    final success = await ref.read(priceNegotiationProvider.notifier).updateNegotiationStatus(
      id: negotiation.id,
      status: 'accepted',
      token: authState.token!,
    );

    if (success) {
      ScaffoldMessenger.of(ref.context).showSnackBar(
        const SnackBar(
          content: Text('Proposition acceptée'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _rejectNegotiation(PriceNegotiation negotiation, WidgetRef ref) async {
    final authState = ref.read(authProvider);
    if (authState.token == null) return;

    final success = await ref.read(priceNegotiationProvider.notifier).updateNegotiationStatus(
      id: negotiation.id,
      status: 'rejected',
      token: authState.token!,
    );

    if (success) {
      ScaffoldMessenger.of(ref.context).showSnackBar(
        const SnackBar(
          content: Text('Proposition rejetée'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
