import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class CreateRequestScreen extends ConsumerStatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  ConsumerState<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends ConsumerState<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _budgetController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedCategory = 'Plomberie';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));

  final List<String> _categories = [
    'Plomberie',
    'Électricité',
    'Peinture',
    'Bricolage',
    'Jardinage',
    'Nettoyage',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _budgetController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF1F2937),
              size: 16,
            ),
          ),
        ),
        title: Text(
          'Créer une demande',
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Selection
              _buildSectionTitle('Catégorie de service'),
              const SizedBox(height: 12),
              _buildCategorySelector(),
              
              const SizedBox(height: 24),
              
              // Title
              _buildSectionTitle('Titre de votre demande'),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _titleController,
                // hintText: 'Ex: Réparation de robinet qui fuit',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir un titre';
                  }
                  return null;
                }, label: 'Titre de votre demande',
              ),
              
              const SizedBox(height: 24),
              
              // Description
              _buildSectionTitle('Description détaillée'),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _descriptionController,
                // hintText: 'Décrivez votre demande en détail...',
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir une description';
                  }
                  return null;
                }, label: 'Description détaillée',
              ),
              
              const SizedBox(height: 24),
              
              // Location
              _buildSectionTitle('Localisation'),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _locationController,
                // hintText: 'Ex: Paris 15ème, 123 rue de la Paix',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir votre localisation';
                  }
                  return null;
                }, label: 'Localisation',
              ),
              
              const SizedBox(height: 24),
              
              // Budget and Phone
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Budget (€)'),
                        const SizedBox(height: 12),
                        CustomTextField(
                          controller: _budgetController,
                          // hintText: '100',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Budget requis';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Montant invalide';
                            }
                            return null;
                          }, label: 'Budget (FCFA)',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Téléphone'),
                        const SizedBox(height: 12),
                        CustomTextField(
                          controller: _phoneController,
                          // hintText: '+33 6 12 34 56 78',
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Téléphone requis';
                            }
                            return null;
                          }, label: '+228',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Deadline
              _buildSectionTitle('Date limite souhaitée'),
              const SizedBox(height: 12),
              _buildDateSelector(),
              
              const SizedBox(height: 24),
              
              // Notes
              _buildSectionTitle('Notes supplémentaires (optionnel)'),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _notesController,
                // hintText: 'Informations complémentaires...',
                maxLines: 3, label: 'Notes supplémentaires (optionnel)',
              ),
              
              const SizedBox(height: 32),
              
              // Submit Button
              CustomButton(
                text: 'Publier ma demande',
                onPressed: _submitRequest,
                isLoading: false,
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.bodyLarge.copyWith(
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1F2937),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          isExpanded: true,
          items: _categories.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(
                category,
                style: AppTextStyles.bodyLarge,
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategory = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              _formatDate(_selectedDate),
              style: AppTextStyles.bodyLarge.copyWith(
                color: const Color(0xFF1F2937),
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) {
      return 'Aujourd\'hui';
    } else if (difference == 1) {
      return 'Demain';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      // Simuler l'envoi de la demande
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Demande publiée avec succès!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
      
      // Retourner à l'écran précédent
      context.pop();
    }
  }
}
