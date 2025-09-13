import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class JobDetailScreen extends ConsumerStatefulWidget {
  final String jobId;
  
  const JobDetailScreen({
    super.key,
    required this.jobId,
  });

  @override
  ConsumerState<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends ConsumerState<JobDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isJobSaved = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Job Details Card
            _buildJobDetailsCard(),
            
            // Tab Bar
            _buildTabBar(),
            
            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAboutJobContent(),
                  _buildCompanyDetailsContent(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildApplyButton(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
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
                size: 20,
              ),
            ),
          ),
          const Spacer(),
          Text(
            'Détails de l\'emploi',
            style: AppTextStyles.h3.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
            ),
          ),
          const Spacer(),
          Container(
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
              Icons.more_vert,
              color: Color(0xFF1F2937),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobDetailsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Company Logo
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Center(
                  child: Text(
                    'U',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Développeur Full Stack',
                            style: AppTextStyles.h3.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isJobSaved = !_isJobSaved;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _isJobSaved 
                                  ? const Color(0xFF8B5CF6).withOpacity(0.1)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              _isJobSaved ? Icons.bookmark : Icons.bookmark_border,
                              color: _isJobSaved 
                                  ? const Color(0xFF8B5CF6)
                                  : Colors.grey[600],
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'PT Uniclov Int.',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Colors.grey[600],
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'Bandung, Jawa Barat',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.euro,
                color: Colors.grey[600],
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '35.000.000 IDR',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Temps plein',
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFF1F2937),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Remote',
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFF1F2937),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Il y a 2 jours',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFF8B5CF6).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: const Color(0xFF8B5CF6),
        unselectedLabelColor: Colors.grey[600],
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: 'À propos du poste'),
          Tab(text: 'Détails de l\'entreprise'),
        ],
      ),
    );
  }

  Widget _buildAboutJobContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Job Description
          _buildSection(
            title: 'Description du poste',
            content: 'Nous recherchons un développeur Full Stack hautement qualifié pour rejoindre notre équipe dynamique. En tant que développeur Full Stack, vous serez responsable de la conception, du développement et de la mise en œuvre de solutions logicielles à la fois pour le front-end et le back-end de nos applications web. Vous collaborerez avec des équipes interfonctionnelles pour traduire les exigences métier en spécifications techniques et livrer un code de haute qualité, évolutif et maintenable.',
          ),
          
          const SizedBox(height: 24),
          
          // Responsibilities
          _buildSection(
            title: 'Responsabilités',
            content: '• Concevoir et développer des applications web complètes\n• Collaborer avec les équipes de conception pour créer des interfaces utilisateur intuitives\n• Développer et maintenir des API robustes et évolutives\n• Optimiser les applications pour la vitesse et l\'évolutivité\n• Participer aux revues de code et aux tests\n• Rester à jour avec les dernières technologies et tendances',
          ),
          
          const SizedBox(height: 24),
          
          // Requirements
          _buildSection(
            title: 'Exigences',
            content: '• Baccalauréat en informatique ou domaine connexe\n• 3+ années d\'expérience en développement Full Stack\n• Maîtrise de JavaScript, React, Node.js\n• Expérience avec les bases de données (MongoDB, PostgreSQL)\n• Connaissance de Git et des pratiques DevOps\n• Excellentes compétences en communication',
          ),
          
          const SizedBox(height: 24),
          
          // Benefits
          _buildSection(
            title: 'Avantages',
            content: '• Salaire compétitif et bonus de performance\n• Assurance santé complète\n• Environnement de travail flexible\n• Opportunités de formation et de développement\n• Équipe jeune et dynamique\n• Projets innovants et stimulants',
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyDetailsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company Overview
          _buildSection(
            title: 'À propos de l\'entreprise',
            content: 'PT Uniclov Int. est une entreprise technologique innovante spécialisée dans le développement de solutions logicielles de pointe. Fondée en 2018, nous nous concentrons sur la création d\'applications web et mobiles qui transforment la façon dont les entreprises opèrent.',
          ),
          
          const SizedBox(height: 24),
          
          // Company Size
          _buildInfoRow('Taille de l\'entreprise', '50-100 employés'),
          _buildInfoRow('Secteur', 'Technologie de l\'information'),
          _buildInfoRow('Fondée en', '2018'),
          _buildInfoRow('Localisation', 'Bandung, Jawa Barat'),
          
          const SizedBox(height: 24),
          
          // Company Culture
          _buildSection(
            title: 'Culture d\'entreprise',
            content: 'Nous croyons en l\'innovation, la collaboration et l\'excellence. Notre équipe est composée de professionnels passionnés qui partagent une vision commune : créer des solutions technologiques qui font la différence.',
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.h4.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.grey[700],
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
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

  Widget _buildApplyButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              _showApplyDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1F2937),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Postuler maintenant',
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showApplyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Postuler à ce poste',
          style: AppTextStyles.h4.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Voulez-vous postuler au poste de Développeur Full Stack chez PT Uniclov Int.?',
          style: AppTextStyles.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Annuler',
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Candidature envoyée avec succès!'),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Postuler',
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}