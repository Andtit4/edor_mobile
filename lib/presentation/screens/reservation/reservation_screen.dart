import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/prestataire_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class ReservationScreen extends ConsumerStatefulWidget {
  final String prestataireId;

  const ReservationScreen({super.key, required this.prestataireId});

  @override
  ConsumerState<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends ConsumerState<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _duration = 1; // heures

  @override
  void dispose() {
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  void _makeReservation() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez sélectionner une date et une heure'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      // Simuler la réservation
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Réservation confirmée !'),
              content: const Text(
                'Votre demande de réservation a été envoyée au prestataire. '
                'Vous recevrez une confirmation sous peu.',
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.pop(); // Retour à l'écran précédent
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final prestataireAsync = ref.watch(
      prestataireProvider(widget.prestataireId),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Réservation')),
      body: prestataireAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur: $error')),
        data: (prestataire) {
          if (prestataire == null) {
            return const Center(child: Text('Prestataire non trouvé'));
          }

          final totalPrice = prestataire.pricePerHour * _duration;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info prestataire
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: AppColors.primaryBlue.withOpacity(
                              0.1,
                            ),
                            child: Text(
                              prestataire.name.isNotEmpty
                                  ? prestataire.name[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  prestataire.name,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  prestataire.category,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: AppColors.gray600),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 16,
                                      color: AppColors.accentYellow,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${prestataire.rating} (${prestataire.totalReviews} avis)',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Date et heure
                  Text(
                    'Date et heure',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: ListTile(
                            leading: const Icon(Icons.calendar_today),
                            title: Text(
                              _selectedDate != null
                                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                  : 'Sélectionner une date',
                            ),
                            onTap: _selectDate,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Card(
                          child: ListTile(
                            leading: const Icon(Icons.access_time),
                            title: Text(
                              _selectedTime != null
                                  ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                                  : 'Sélectionner l\'heure',
                            ),
                            onTap: _selectTime,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Durée
                  Text(
                    'Durée',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Nombre d\'heures :'),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed:
                                        _duration > 1
                                            ? () => setState(() => _duration--)
                                            : null,
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.gray300,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '$_duration h',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed:
                                        _duration < 8
                                            ? () => setState(() => _duration++)
                                            : null,
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Description
                  CustomTextField(
                    controller: _descriptionController,
                    label: 'Description du travail',
                    hint: 'Décrivez précisément le travail à effectuer...',
                    maxLines: 4,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Veuillez décrire le travail à effectuer';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Adresse
                  CustomTextField(
                    controller: _addressController,
                    label: 'Adresse',
                    hint: 'Où le travail doit-il être effectué ?',
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Veuillez indiquer l\'adresse';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  // Récapitulatif des coûts
                  Card(
                    color: AppColors.primaryBlue.withOpacity(0.05),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Récapitulatif',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Tarif horaire:'),
                              Text('${prestataire.pricePerHour} FCFA'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Durée:'),
                              Text(
                                '$_duration heure${_duration > 1 ? 's' : ''}',
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total:',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '$totalPrice FCFA',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Bouton de réservation
                  CustomButton(
                    onPressed: _makeReservation,
                    text: 'Confirmer la réservation',
                    // child: const Text('Confirmer la réservation'),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
