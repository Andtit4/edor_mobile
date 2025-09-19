import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/service_request.dart';
import '../../../domain/entities/user.dart';
import '../../providers/auth_provider.dart';
import '../../providers/service_request_provider.dart';

class ServiceRequestDetailScreen extends ConsumerWidget {
  final ServiceRequest request;

  const ServiceRequestDetailScreen({
    Key? key,
    required this.request,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Détails de la demande'),
        backgroundColor: const Color(0xFF8B5CF6),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carte principale
            _buildMainCard(),
            
            const SizedBox(height: 20),
            
            // Informations détaillées
            _buildDetailsCard(),
            
            const SizedBox(height: 20),
            
            // Informations de contact
            _buildContactCard(),
            
            const SizedBox(height: 20),
            
            // Actions (si applicable)
            _buildActionsCard(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    request.title,
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ),
                _buildStatusChip(request.status),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              request.description,
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.category, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  request.category,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informations détaillées',
              style: AppTextStyles.h4.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.attach_money,
              label: 'Budget',
              value: '${request.budget.toStringAsFixed(0)} FCFA',
              valueColor: const Color(0xFF8B5CF6),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.location_on,
              label: 'Localisation',
              value: request.location,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.schedule,
              label: 'Date limite',
              value: _formatDate(request.deadline),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.access_time,
              label: 'Créée le',
              value: _formatDate(request.createdAt),
            ),
            if (request.completionDate != null) ...[
              const SizedBox(height: 12),
              _buildDetailRow(
                icon: Icons.check_circle,
                label: 'Date de réalisation',
                value: _formatDate(request.completionDate!),
                valueColor: Colors.green,
              ),
            ],
            if (request.completionNotes != null && request.completionNotes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildDetailRow(
                icon: Icons.note,
                label: 'Notes de clôture',
                value: request.completionNotes!,
              ),
            ],
            if (request.notes != null && request.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildDetailRow(
                icon: Icons.sticky_note_2,
                label: 'Notes',
                value: request.notes!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informations de contact',
              style: AppTextStyles.h4.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.person,
              label: 'Client',
              value: request.clientName,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.phone,
              label: 'Téléphone',
              value: request.clientPhone,
            ),
            if (request.prestataireName != null) ...[
              const SizedBox(height: 12),
              _buildDetailRow(
                icon: Icons.build,
                label: 'Prestataire assigné',
                value: request.prestataireName!,
                valueColor: const Color(0xFF8B5CF6),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    // Seuls les clients peuvent voir les actions pour leurs demandes
    if (user?.role != UserRole.client || user?.id != request.clientId) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions',
              style: AppTextStyles.h4.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 16),
            if (request.status == 'pending') ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _cancelRequest(context, ref),
                  icon: const Icon(Icons.cancel),
                  label: const Text('Annuler la demande'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ] else if (request.status == 'completed') ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green[600], size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Demande terminée avec succès',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.green[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (request.status == 'cancelled') ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.cancel, color: Colors.red[600], size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Demande annulée',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.red[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: valueColor ?? const Color(0xFF1F2937),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String text;
    
    switch (status) {
      case 'pending':
        color = Colors.orange;
        text = 'En attente';
        break;
      case 'assigned':
        color = Colors.blue;
        text = 'Assigné';
        break;
      case 'in_progress':
        color = Colors.purple;
        text = 'En cours';
        break;
      case 'completed':
        color = Colors.green;
        text = 'Terminé';
        break;
      case 'cancelled':
        color = Colors.red;
        text = 'Annulé';
        break;
      default:
        color = Colors.grey;
        text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _cancelRequest(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Annuler la demande'),
        content: const Text(
          'Êtes-vous sûr de vouloir annuler cette demande ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Non'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Oui, annuler'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final authState = ref.read(authProvider);
      final token = authState.token;

      if (token != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        try {
          await ref.read(serviceRequestProvider.notifier).updateServiceRequest(
            request.id,
            {'status': 'cancelled'},
            token,
          );

          if (context.mounted) {
            Navigator.of(context, rootNavigator: true).pop(); // Fermer l'indicateur
            Navigator.of(context).pop(); // Retourner à la liste
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Demande annulée avec succès'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            Navigator.of(context, rootNavigator: true).pop(); // Fermer l'indicateur
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
  }
}
