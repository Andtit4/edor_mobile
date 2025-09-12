import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/prestataire_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/prestataire_card.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/search_bar_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prestatairesState = ref.watch(prestatairesProvider);
    final currentUser = ref.watch(currentUserProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header moderne
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              floating: true,
              pinned: false,
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row avec notifications
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Activités',
                                style: AppTextStyles.h1.copyWith(
                                  color: AppColors.activityText,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Restez informé de vos dernières activités',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.activityTextSecondary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: AppColors.activityCardShadow,
                            ),
                            child: Stack(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.notifications_outlined,
                                    color: AppColors.activityText,
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Notifications à venir')),
                                    );
                                  },
                                ),
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.error,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Barre de recherche moderne
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: AppColors.activityCardShadow,
                  ),
                  child: SearchBarWidget(
                    onSearch: (query) {
                      ref
                          .read(prestatairesProvider.notifier)
                          .searchPrestataires(query);
                    },
                  ),
                ),
              ),
            ),

            // Section des catégories
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categories',
                          style: AppTextStyles.h5.copyWith(
                            color: AppColors.activityText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Naviguer vers toutes les catégories
                          },
                          child: Text(
                            'View All',
                            style: AppTextStyles.buttonMedium.copyWith(
                              color: AppColors.activityButton,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: prestatairesState.categories.length,
                      itemBuilder: (context, index) {
                        final category = prestatairesState.categories[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: CategoryChip(
                            category: category,
                            isSelected: prestatairesState.selectedCategoryId == category.id,
                            onTap: () {
                              final currentId = prestatairesState.selectedCategoryId;
                              final newId = currentId == category.id ? null : category.id;
                              ref
                                  .read(prestatairesProvider.notifier)
                                  .filterByCategory(newId);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // Section des activités/réservations
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Activities',
                      style: AppTextStyles.h5.copyWith(
                        color: AppColors.activityText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (prestatairesState.searchQuery.isNotEmpty ||
                        prestatairesState.selectedCategoryId != null)
                      TextButton(
                        onPressed: () {
                          ref.read(prestatairesProvider.notifier).searchPrestataires('');
                          ref.read(prestatairesProvider.notifier).filterByCategory(null);
                        },
                        child: Text(
                          'Clear Filters',
                          style: AppTextStyles.buttonMedium.copyWith(
                            color: AppColors.activityButton,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Liste des activités
            if (prestatairesState.isLoading)
              const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            else if (prestatairesState.error != null)
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${prestatairesState.error}',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(prestatairesProvider.notifier).refresh();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else if (prestatairesState.filteredPrestataires.isEmpty)
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppColors.gray400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No activities found',
                          style: AppTextStyles.h5.copyWith(
                            color: AppColors.activityText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search criteria',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.activityTextSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final prestataire = prestatairesState.filteredPrestataires[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildActivityCard(
                        context: context,
                        prestataire: prestataire,
                        onTap: () {
                          context.push('${AppRoutes.prestataireDetail}/${prestataire.id}');
                        },
                        onFavoriteToggle: () {
                          ref
                              .read(prestatairesProvider.notifier)
                              .toggleFavorite(prestataire.id);
                        },
                        isFavorite: prestatairesState.favorites.any(
                          (fav) => fav.id == prestataire.id,
                        ),
                      ),
                    );
                  }, childCount: prestatairesState.filteredPrestataires.length),
                ),
              ),

            // Espacement pour la bottom navigation
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard({
    required BuildContext context,
    required dynamic prestataire,
    required VoidCallback onTap,
    required VoidCallback onFavoriteToggle,
    required bool isFavorite,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.activityCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.activityBorder),
        boxShadow: AppColors.activityCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec profil
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.purple.withOpacity(0.1),
                  child: Text(
                    prestataire.name.isNotEmpty ? prestataire.name[0].toUpperCase() : 'U',
                    style: AppTextStyles.buttonMedium.copyWith(
                      color: AppColors.purple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prestataire.name,
                        style: AppTextStyles.cardTitle.copyWith(
                          color: AppColors.activityText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        prestataire.category ?? 'Service Provider',
                        style: AppTextStyles.cardSubtitle.copyWith(
                          color: AppColors.activityTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'now',
                  style: AppTextStyles.activityTime.copyWith(
                    color: AppColors.activityTime,
                  ),
                ),
              ],
            ),
          ),

          // Contenu
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              'Your next service is scheduled for 2:00pm',
              style: AppTextStyles.activityContent.copyWith(
                color: AppColors.activityText,
              ),
            ),
          ),

          // Image placeholder (carte ou image du service)
          Container(
            height: 200,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.activityBorder),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 48,
                        color: AppColors.purple.withOpacity(0.3),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Service Location',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.activityTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.open_in_full,
                      size: 16,
                      color: AppColors.activityTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Footer avec actions
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                // Like button
                Row(
                  children: [
                    Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: isFavorite ? AppColors.activityLike : AppColors.activityComment,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${prestataire.rating?.toInt() ?? 0}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.activityComment,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // Comment button
                Row(
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline,
                      size: 20,
                      color: AppColors.activityComment,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${(prestataire.rating ?? 0).toInt()}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.activityComment,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // View Job button
                Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.activityButton,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: onTap,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: Text(
                      'View Job',
                      style: AppTextStyles.buttonSmall.copyWith(
                        color: AppColors.activityButtonText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}