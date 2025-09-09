import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/prestataire_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
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
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bonjour ${currentUser?.name ?? 'Utilisateur'} !',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              'Que recherchez-vous aujourd\'hui ?',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.gray600),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications à venir')),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(prestatairesProvider.notifier).refresh();
        },
        child: CustomScrollView(
          slivers: [
            // Barre de recherche
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SearchBarWidget(
                  onSearch: (query) {
                    ref
                        .read(prestatairesProvider.notifier)
                        .searchPrestataires(query);
                  },
                ),
              ),
            ),

            // Catégories
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Catégories',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Naviguer vers toutes les catégories
                          },
                          child: const Text('Voir tout'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: prestatairesState.categories.length,
                      itemBuilder: (context, index) {
                        final category = prestatairesState.categories[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: CategoryChip(
                            category: category,
                            isSelected:
                                prestatairesState.selectedCategoryId ==
                                category.id,
                            onTap: () {
                              final currentId =
                                  prestatairesState.selectedCategoryId;
                              final newId =
                                  currentId == category.id ? null : category.id;
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

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Section prestataires
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Prestataires recommandés',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (prestatairesState.searchQuery.isNotEmpty ||
                        prestatairesState.selectedCategoryId != null)
                      TextButton(
                        onPressed: () {
                          ref
                              .read(prestatairesProvider.notifier)
                              .searchPrestataires('');
                          ref
                              .read(prestatairesProvider.notifier)
                              .filterByCategory(null);
                        },
                        child: const Text('Effacer filtres'),
                      ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // Liste des prestataires
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
                          'Erreur: ${prestatairesState.error}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(prestatairesProvider.notifier).refresh();
                          },
                          child: const Text('Réessayer'),
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
                          'Aucun prestataire trouvé',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Essayez de modifier vos critères de recherche',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.gray600),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final prestataire =
                        prestatairesState.filteredPrestataires[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: PrestataireCard(
                        prestataire: prestataire,
                        onTap: () {
                          context.push(
                            '${AppRoutes.prestataireDetail}/${prestataire.id}',
                          );
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
}
