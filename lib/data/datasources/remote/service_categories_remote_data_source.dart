import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/service_category.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/constants/service_categories.dart';

abstract class ServiceCategoriesRemoteDataSource {
  Future<List<ServiceCategory>> getCategories();
}

// Provider pour la source de données distante
final serviceCategoriesRemoteDataSourceProvider = Provider<ServiceCategoriesRemoteDataSource>((ref) {
  return ServiceCategoriesRemoteDataSourceImpl(
    client: http.Client(),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class ServiceCategoriesRemoteDataSourceImpl implements ServiceCategoriesRemoteDataSource {
  final http.Client client;
  final NetworkInfo networkInfo;

  ServiceCategoriesRemoteDataSourceImpl({
    required this.client,
    required this.networkInfo,
  });

  @override
  Future<List<ServiceCategory>> getCategories() async {
    // Retourner directement les catégories par défaut
    // Le backend gère déjà les catégories dans le champ 'category' de l'entité Prestataire
    return _getDefaultCategories();
  }

  // Méthode pour obtenir les catégories par défaut
  List<ServiceCategory> _getDefaultCategories() {
    return ServiceCategories.allCategories.map((categoryInfo) {
      return ServiceCategory(
        id: categoryInfo.id,
        name: categoryInfo.name,
        description: categoryInfo.description,
        icon: categoryInfo.icon,
        image: categoryInfo.image,
        isActive: true,
        prestataireCount: 0,
        createdAt: DateTime.now(),
      );
    }).toList();
  }

}
