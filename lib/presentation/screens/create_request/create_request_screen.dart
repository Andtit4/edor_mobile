import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../providers/service_request_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class CreateRequestScreen extends ConsumerStatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  ConsumerState<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends ConsumerState<CreateRequestScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _budgetController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedCategory = 'Plomberie';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  String _selectedUrgency = 'Normal';
  bool _isSubmitting = false;
  int _currentStep = 0;

  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  final List<String> _categories = [
    'Plomberie',
    'Électricité',
    'Peinture',
    'Bricolage',
    'Jardinage',
    'Nettoyage',
    'Climatisation',
    'Sécurité',
    'Autre',
  ];

  final List<String> _urgencyLevels = [
    'Urgent (Aujourd\'hui)',
    'Normal (Cette semaine)',
    'Flexible (Ce mois)',
  ];

  @override
  void initState() {
    super.initState();
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressAnimationController, curve: Curves.easeInOut),
    );
    
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.elasticOut),
    );
    
    _fabAnimationController.forward();
    _progressAnimationController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _budgetController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    _progressAnimationController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header moderne avec progression
            _buildModernHeader(),
            
            // Barre de progression
            _buildProgressBar(),
            
            // Contenu principal
            Expanded(
              child: _buildStepContent(),
            ),
            
            // Navigation et actions
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nouvelle demande',
                      style: AppTextStyles.h2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Décrivez votre besoin en détail',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.request_quote,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Étape ${_currentStep + 1} sur 3',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '${((_currentStep + 1) / 3 * 100).round()}%',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF8B5CF6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: _progressAnimation.value * ((_currentStep + 1) / 3),
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
                minHeight: 6,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _getStepWidget(),
    );
  }

  Widget _getStepWidget() {
    switch (_currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      default:
        return _buildStep1();
    }
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Catégorie
            _buildSectionCard(
              title: 'Type de service',
              icon: Icons.category,
              child: _buildCategorySelector(),
            ),
            
            const SizedBox(height: 20),
            
            // Titre
            _buildSectionCard(
              title: 'Titre de votre demande',
              icon: Icons.title,
              child: CustomTextField(
                controller: _titleController,
                hint: 'Ex: Réparation de robinet qui fuit',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir un titre';
                  }
                  if (value.length < 10) {
                    return 'Le titre doit contenir au moins 10 caractères';
                  }
                  return null;
                },
                label: 'Titre de votre demande',
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Description
            _buildSectionCard(
              title: 'Description détaillée',
              icon: Icons.description,
              child: CustomTextField(
                controller: _descriptionController,
                hint: 'Décrivez votre demande en détail...',
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir une description';
                  }
                  if (value.length < 20) {
                    return 'La description doit contenir au moins 20 caractères';
                  }
                  return null;
                },
                label: 'Description détaillée',
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Urgence
            _buildSectionCard(
              title: 'Niveau d\'urgence',
              icon: Icons.schedule,
              child: _buildUrgencySelector(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Localisation
          _buildSectionCard(
            title: 'Localisation',
            icon: Icons.location_on,
            child: CustomTextField(
              controller: _locationController,
              hint: 'Ex: Lomé, Agoè-Nyivé, Rue de la Paix',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez saisir votre localisation';
                }
                return null;
              },
              label: 'Votre localisation',
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Budget et Téléphone
          Row(
            children: [
              Expanded(
                child: _buildSectionCard(
                  title: 'Budget (FCFA)',
                  icon: Icons.euro,
                  child: CustomTextField(
                    controller: _budgetController,
                    hint: '50000',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Budget requis';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Montant invalide';
                      }
                      if (double.parse(value) < 1000) {
                        return 'Budget minimum: 1000 FCFA';
                      }
                      return null;
                    },
                    label: 'Budget (FCFA)',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSectionCard(
                  title: 'Téléphone',
                  icon: Icons.phone,
                  child: CustomTextField(
                    controller: _phoneController,
                    hint: '+228 90 12 34 56',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Téléphone requis';
                      }
                      if (!RegExp(r'^\+228\s?\d{2}\s?\d{2}\s?\d{2}\s?\d{2}$').hasMatch(value)) {
                        return 'Format: +228 XX XX XX XX';
                      }
                      return null;
                    },
                    label: 'Téléphone',
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Date limite
          _buildSectionCard(
            title: 'Date limite souhaitée',
            icon: Icons.calendar_today,
            child: _buildDateSelector(),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notes supplémentaires
          _buildSectionCard(
            title: 'Notes supplémentaires',
            icon: Icons.note_add,
            child: CustomTextField(
              controller: _notesController,
              hint: 'Informations complémentaires, préférences...',
              maxLines: 3,
              label: 'Notes supplémentaires (optionnel)',
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Récapitulatif
          _buildSummaryCard(),
          
          const SizedBox(height: 20),
          
          // Conditions
          _buildTermsCard(),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.activityCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF8B5CF6),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTextStyles.h4.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

  Widget _buildUrgencySelector() {
    return Column(
      children: _urgencyLevels.map((urgency) {
        final isSelected = _selectedUrgency == urgency;
        final colors = {
          'Urgent (Aujourd\'hui)': const Color(0xFFEF4444),
          'Normal (Cette semaine)': const Color(0xFF8B5CF6),
          'Flexible (Ce mois)': const Color(0xFF10B981),
        };
        
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => _selectedUrgency = urgency),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? colors[urgency]!.withOpacity(0.1)
                      : const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected 
                        ? colors[urgency]!
                        : const Color(0xFFE5E7EB),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected 
                            ? colors[urgency]!
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected 
                              ? colors[urgency]!
                              : Colors.grey[400]!,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        urgency,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: isSelected 
                              ? colors[urgency]!
                              : Colors.grey[700],
                          fontWeight: isSelected 
                              ? FontWeight.w600 
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: colors[urgency]!,
                        size: 20,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDateSelector() {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
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

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.activityCardShadow,
        border: Border.all(
          color: const Color(0xFF8B5CF6).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.summarize,
                  color: Color(0xFF8B5CF6),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Récapitulatif',
                style: AppTextStyles.h4.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSummaryItem('Catégorie', _selectedCategory),
          _buildSummaryItem('Titre', _titleController.text.isNotEmpty ? _titleController.text : 'Non renseigné'),
          _buildSummaryItem('Urgence', _selectedUrgency),
          _buildSummaryItem('Localisation', _locationController.text.isNotEmpty ? _locationController.text : 'Non renseigné'),
          _buildSummaryItem('Budget', _budgetController.text.isNotEmpty ? '${_budgetController.text} FCFA' : 'Non renseigné'),
          _buildSummaryItem('Téléphone', _phoneController.text.isNotEmpty ? _phoneController.text : 'Non renseigné'),
          _buildSummaryItem('Date limite', _formatDate(_selectedDate)),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFF1F2937),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: Color(0xFF8B5CF6),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Conditions d\'utilisation',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '• Votre demande sera visible par les prestataires qualifiés\n'
            '• Les prestataires pourront vous contacter directement\n'
            '• Vous recevrez des notifications pour les nouvelles réponses\n'
            '• Vous pouvez modifier ou annuler votre demande à tout moment',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: CustomButton(
                  text: 'Précédent',
                  onPressed: _previousStep,
                  backgroundColor: Colors.grey[100],
                  textColor: Colors.grey[700],
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: AnimatedBuilder(
                animation: _fabAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _fabAnimation.value,
                    child: CustomButton(
                      text: _currentStep == 2 ? 'Publier la demande' : 'Suivant',
                      onPressed: _currentStep == 2 ? _submitRequest : _nextStep,
                      isLoading: _isSubmitting,
                      backgroundColor: const Color(0xFF8B5CF6),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (_formKey.currentState!.validate()) {
        setState(() => _currentStep = 1);
        _progressAnimationController.reset();
        _progressAnimationController.forward();
      }
    } else if (_currentStep == 1) {
      if (_locationController.text.isNotEmpty && 
          _budgetController.text.isNotEmpty && 
          _phoneController.text.isNotEmpty) {
        setState(() => _currentStep = 2);
        _progressAnimationController.reset();
        _progressAnimationController.forward();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez remplir tous les champs obligatoires'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _progressAnimationController.reset();
      _progressAnimationController.forward();
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) {
      return 'Aujourd\'hui';
    } else if (difference == 1) {
      return 'Demain';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8B5CF6),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1F2937),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submitRequest() async {
    // Vérifier que nous sommes sur la bonne étape et que le formulaire est valide
    if (_currentStep == 0) {
      if (_formKey.currentState?.validate() ?? false) {
        setState(() => _currentStep = 1);
        _progressAnimationController.reset();
        _progressAnimationController.forward();
        return;
      }
    }
    
    // Pour l'étape finale, on valide manuellement les champs requis
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le titre est requis')),
      );
      return;
    }
    
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La description est requise')),
      );
      return;
    }
    
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une catégorie')),
      );
      return;
    }
    
    if (_locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le lieu est requis')),
      );
      return;
    }
    
    if (_budgetController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le budget est requis')),
      );
      return;
    }
    
    setState(() => _isSubmitting = true);
    
    try {
      final authState = ref.read(authProvider);
      final user = authState.user;
      
      if (user == null) {
        throw Exception('Utilisateur non connecté');
      }

      // Récupérer le token directement depuis le cache
      final localDataSource = ref.read(localDataSourceProvider);
      final tokenData = await localDataSource.getFromCache('auth_token');
      final token = tokenData?['token'] as String?;
      
      if (token == null || token.isEmpty) {
        throw Exception('Token d\'authentification manquant');
      }

      // Créer la demande via l'API
      final newRequest = await ref.read(serviceRequestProvider.notifier).createRequest(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory!,
        clientName: '${user.firstName} ${user.lastName}',
        clientPhone: user.phone,
        location: _locationController.text.trim(),
        budget: double.parse(_budgetController.text.trim()),
        deadline: _selectedDate ?? DateTime.now().add(const Duration(days: 7)),
        notes: _selectedUrgency != null ? 'Urgence: $_selectedUrgency' : null,
        token: token,
      );

      // Afficher un message de succès
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Demande créée avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Rafraîchir la liste des demandes
        ref.read(serviceRequestProvider.notifier).loadMyRequests(token);
        
        // Retourner à l'écran précédent
        context.pop();
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
        setState(() => _isSubmitting = false);
      }
    }
  }
}
