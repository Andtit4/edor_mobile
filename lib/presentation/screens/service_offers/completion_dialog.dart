import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/service_request_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../domain/entities/price_negotiation.dart';

class CompletionDialog extends ConsumerStatefulWidget {
  final PriceNegotiation negotiation;

  const CompletionDialog({
    Key? key,
    required this.negotiation,
  }) : super(key: key);

  @override
  ConsumerState<CompletionDialog> createState() => _CompletionDialogState();
}

class _CompletionDialogState extends ConsumerState<CompletionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _completionNotesController = TextEditingController();
  final _reviewCommentController = TextEditingController();
  
  DateTime _completionDate = DateTime.now();
  int _rating = 5;

  @override
  void dispose() {
    _completionNotesController.dispose();
    _reviewCommentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Clôturer cette offre'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Informations sur l'offre
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prestataire: ${widget.negotiation.prestataireName ?? widget.negotiation.prestataireId.substring(0, 8)}...',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Prix accepté: ${widget.negotiation.proposedPrice.toStringAsFixed(0)} FCFA',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: const Color(0xFF8B5CF6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Date de réalisation
              Text(
                'Date de réalisation',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${_completionDate.day}/${_completionDate.month}/${_completionDate.year}',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Remarques de clôture
              Text(
                'Remarques de clôture (optionnel)',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _completionNotesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Décrivez comment s\'est déroulée la prestation...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Note du prestataire
              Text(
                'Note du prestataire',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                    child: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                  );
                }),
              ),
              
              const SizedBox(height: 16),
              
              // Commentaire d'avis
              Text(
                'Commentaire d\'avis (optionnel)',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _reviewCommentController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Partagez votre expérience avec ce prestataire...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _completeService,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8B5CF6),
            foregroundColor: Colors.white,
          ),
          child: const Text('Clôturer'),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _completionDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (date != null) {
      setState(() {
        _completionDate = date;
      });
    }
  }

  Future<void> _completeService() async {
    if (!_formKey.currentState!.validate()) return;

    final authState = ref.read(authProvider);
    final token = authState.token;

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Token non disponible'),
          backgroundColor: Colors.red,
        ),
      );
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
      final result = await ref.read(serviceRequestProvider.notifier).completeServiceRequest(
        id: widget.negotiation.serviceRequestId,
        completionDate: _completionDate,
        completionNotes: _completionNotesController.text.trim().isEmpty 
            ? null 
            : _completionNotesController.text.trim(),
        rating: _rating,
        reviewComment: _reviewCommentController.text.trim().isEmpty 
            ? null 
            : _reviewCommentController.text.trim(),
        token: token,
      );

      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Fermer l'indicateur de chargement
        Navigator.of(context).pop(); // Fermer le dialogue
        
        if (result != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Offre clôturée avec succès !'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur lors de la clôture'),
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
