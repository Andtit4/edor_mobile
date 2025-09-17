// lib/presentation/screens/service_offers/negotiation_widgets.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/price_negotiation.dart';
import '../../../domain/entities/user.dart';
import '../../providers/auth_provider.dart';
import '../../providers/price_negotiation_provider.dart';

class NegotiationWidgets {
  static Widget buildNegotiationsList(WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final authState = ref.watch(authProvider);
        final negotiationState = ref.watch(priceNegotiationProvider);
        
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
        
        if (negotiationState.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        if (negotiationState.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Erreur lors du chargement',
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.red[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  negotiationState.error!,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.red[500],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _loadClientNegotiations(ref),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }
        
        if (negotiationState.negotiations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.handshake_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucune négociation',
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Aucun prestataire n\'a encore proposé de prix pour vos demandes',
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
          itemCount: negotiationState.negotiations.length,
          itemBuilder: (context, index) {
            final negotiation = negotiationState.negotiations[index];
            return buildNegotiationCard(negotiation, ref, context);
          },
        );
      },
    );
  }

  static Widget buildNegotiationCard(PriceNegotiation negotiation, WidgetRef ref, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec nom du prestataire et statut
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: _getNegotiationStatusColor(negotiation.status).withOpacity(0.1),
                  child: Icon(
                    Icons.person,
                    color: _getNegotiationStatusColor(negotiation.status),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prestataire ${negotiation.prestataireId.substring(0, 8)}...',
                        style: AppTextStyles.h4.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Demande ${negotiation.serviceRequestId.substring(0, 8)}...',
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
                    color: _getNegotiationStatusColor(negotiation.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getNegotiationStatusText(negotiation.status),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: _getNegotiationStatusColor(negotiation.status),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Prix proposé
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.attach_money,
                    color: Colors.blue[600],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Prix proposé: ',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    '${negotiation.proposedPrice.toStringAsFixed(0)} FCFA',
                    style: AppTextStyles.h4.copyWith(
                      color: Colors.blue[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // Message (si présent)
            if (negotiation.message != null && negotiation.message!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.message_outlined,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        negotiation.message!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Date de création
            Text(
              'Proposé le ${negotiation.createdAt != null ? _formatDate(negotiation.createdAt!) : 'Date inconnue'}',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.grey[500],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Boutons d'action
            if (negotiation.status == NegotiationStatus.pending) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _acceptNegotiation(negotiation, ref, context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Accepter'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _rejectNegotiation(negotiation, ref, context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Refuser'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  static Color _getNegotiationStatusColor(NegotiationStatus status) {
    switch (status) {
      case NegotiationStatus.pending:
        return Colors.orange;
      case NegotiationStatus.accepted:
        return Colors.green;
      case NegotiationStatus.rejected:
        return Colors.red;
      case NegotiationStatus.countered:
        return Colors.blue;
    }
  }

  static String _getNegotiationStatusText(NegotiationStatus status) {
    switch (status) {
      case NegotiationStatus.pending:
        return 'En attente';
      case NegotiationStatus.accepted:
        return 'Accepté';
      case NegotiationStatus.rejected:
        return 'Rejeté';
      case NegotiationStatus.countered:
        return 'Contre-offre';
    }
  }

  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static void _loadClientNegotiations(WidgetRef ref) {
    final authState = ref.read(authProvider);
    var token = authState.token;
    
    if (token != null && authState.user?.role == UserRole.client) {
      print('Loading client negotiations...');
      ref.read(priceNegotiationProvider.notifier).loadClientNegotiations(
        clientId: authState.user!.id,
        token: token,
      );
    }
  }

  static void _acceptNegotiation(PriceNegotiation negotiation, WidgetRef ref, BuildContext context) async {
    final authState = ref.read(authProvider);
    final token = authState.token;
    
    if (token == null) return;
    
    // Afficher un dialogue de confirmation
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accepter cette offre'),
        content: Text(
          'Êtes-vous sûr de vouloir accepter l\'offre du prestataire ${negotiation.prestataireId.substring(0, 8)}... pour ${negotiation.proposedPrice.toStringAsFixed(0)} FCFA ?\n\nCette action assignera définitivement le prestataire à votre demande et rejettera toutes les autres offres.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Accepter'),
          ),
        ],
      ),
    );
    
    if (confirmed != true) return;
    
    // Afficher un indicateur de chargement
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    
    try {
      final success = await ref.read(priceNegotiationProvider.notifier).acceptNegotiation(
        id: negotiation.id,
        token: token,
      );
      
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Fermer l'indicateur de chargement
        
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Offre acceptée avec succès !'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Recharger les négociations
          _loadClientNegotiations(ref);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur lors de l\'acceptation de l\'offre'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Fermer l'indicateur de chargement
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  static void _rejectNegotiation(PriceNegotiation negotiation, WidgetRef ref, BuildContext context) async {
    final authState = ref.read(authProvider);
    final token = authState.token;
    
    if (token == null) return;
    
    // Afficher un dialogue de confirmation
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Refuser cette offre'),
        content: Text(
          'Êtes-vous sûr de vouloir refuser l\'offre du prestataire ${negotiation.prestataireId.substring(0, 8)}... ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Refuser'),
          ),
        ],
      ),
    );
    
    if (confirmed != true) return;
    
    // Afficher un indicateur de chargement
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    
    try {
      final success = await ref.read(priceNegotiationProvider.notifier).updateNegotiationStatus(
        id: negotiation.id,
        status: 'rejected',
        token: token,
      );
      
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Fermer l'indicateur de chargement
        
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Offre refusée'),
              backgroundColor: Colors.orange,
            ),
          );
          
          // Recharger les négociations
          _loadClientNegotiations(ref);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur lors du refus de l\'offre'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Fermer l'indicateur de chargement
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
