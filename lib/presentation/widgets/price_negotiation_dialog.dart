// lib/presentation/widgets/price_negotiation_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/entities/price_negotiation.dart';
import '../providers/price_negotiation_provider.dart';
import '../providers/auth_provider.dart';
import '../../core/utils/price_converter.dart';

class PriceNegotiationDialog extends ConsumerStatefulWidget {
  final String serviceRequestId;
  final double currentBudget;
  final PriceNegotiation? parentNegotiation;
  final bool isFromPrestataire;

  const PriceNegotiationDialog({
    super.key,
    required this.serviceRequestId,
    required this.currentBudget,
    this.parentNegotiation,
    this.isFromPrestataire = true,
  });

  @override
  ConsumerState<PriceNegotiationDialog> createState() => _PriceNegotiationDialogState();
}

class _PriceNegotiationDialogState extends ConsumerState<PriceNegotiationDialog> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Suggérer un prix légèrement différent du budget actuel
    if (widget.isFromPrestataire) {
      _priceController.text = (widget.currentBudget * 1.1).toStringAsFixed(2);
    } else {
      _priceController.text = (widget.currentBudget * 0.9).toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.parentNegotiation != null ? 'Contre-proposition' : 'Nouvelle proposition',
        style: AppTextStyles.h3,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Budget actuel: ${PriceConverter.formatEuroToFcfa(widget.currentBudget)}',
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Prix proposé:',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Entrez le prix proposé',
                prefixText: 'FCFA ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Message (optionnel):',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _messageController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Expliquez votre proposition...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            if (_isLoading) ...[
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitNegotiation,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8B5CF6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Envoyer'),
        ),
      ],
    );
  }

  Future<void> _submitNegotiation() async {
    final priceText = _priceController.text.trim();
    if (priceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer un prix'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final price = double.tryParse(priceText);
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer un prix valide'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authState = ref.read(authProvider);
      final token = authState.token;

      if (token == null) {
        throw Exception('Token non disponible');
      }

      final negotiation = await ref.read(priceNegotiationProvider.notifier).createNegotiation(
        serviceRequestId: widget.serviceRequestId,
        proposedPrice: price,
        message: _messageController.text.trim().isEmpty ? null : _messageController.text.trim(),
        parentNegotiationId: widget.parentNegotiation?.id,
        token: token,
      );

      if (negotiation != null && mounted) {
        Navigator.pop(context, negotiation);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Proposition envoyée avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Erreur lors de la création de la proposition');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
