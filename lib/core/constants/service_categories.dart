/// Constantes pour les catégories de services
/// Ce fichier centralise toutes les catégories utilisées dans l'application
class ServiceCategories {
  // IDs des catégories (utilisés pour l'API et la base de données)
  static const String plomberie = 'plomberie';
  static const String electricite = 'electricite';
  static const String bricolage = 'bricolage';
  static const String menage = 'menage';
  static const String jardinage = 'jardinage';
  static const String transport = 'transport';
  static const String cuisine = 'cuisine';
  static const String beaute = 'beaute';
  static const String peinture = 'peinture';
  static const String climatisation = 'climatisation';
  static const String securite = 'securite';
  static const String autre = 'autre';

  /// Liste de toutes les catégories avec leurs informations
  static const List<ServiceCategoryInfo> allCategories = [
    ServiceCategoryInfo(
      id: plomberie,
      name: 'Plomberie',
      description: 'Installation et réparation de plomberie',
      icon: 'plumbing',
      image: 'assets/images/categories/plomberie.png',
    ),
    ServiceCategoryInfo(
      id: electricite,
      name: 'Électricité',
      description: 'Installation et réparation électrique',
      icon: 'electrical_services',
      image: 'assets/images/categories/electricite.png',
    ),
    ServiceCategoryInfo(
      id: bricolage,
      name: 'Bricolage',
      description: 'Petits travaux de réparation et d\'amélioration',
      icon: 'build',
      image: 'assets/images/categories/bricolage.png',
    ),
    ServiceCategoryInfo(
      id: menage,
      name: 'Ménage',
      description: 'Nettoyage et entretien domestique',
      icon: 'cleaning_services',
      image: 'assets/images/categories/menage.png',
    ),
    ServiceCategoryInfo(
      id: jardinage,
      name: 'Jardinage',
      description: 'Entretien d\'espaces verts et jardins',
      icon: 'grass',
      image: 'assets/images/categories/jardinage.png',
    ),
    ServiceCategoryInfo(
      id: transport,
      name: 'Transport',
      description: 'Services de transport et livraison',
      icon: 'directions_car',
      image: 'assets/images/categories/transport.png',
    ),
    ServiceCategoryInfo(
      id: cuisine,
      name: 'Cuisine',
      description: 'Préparation de repas et service traiteur',
      icon: 'restaurant',
      image: 'assets/images/categories/cuisine.png',
    ),
    ServiceCategoryInfo(
      id: beaute,
      name: 'Beauté',
      description: 'Services de coiffure et soins esthétiques',
      icon: 'face',
      image: 'assets/images/categories/beaute.png',
    ),
    ServiceCategoryInfo(
      id: peinture,
      name: 'Peinture',
      description: 'Peinture intérieure et extérieure',
      icon: 'format_paint',
      image: 'assets/images/categories/peinture.png',
    ),
    ServiceCategoryInfo(
      id: climatisation,
      name: 'Climatisation',
      description: 'Installation et réparation de climatisation',
      icon: 'ac_unit',
      image: 'assets/images/categories/climatisation.png',
    ),
    ServiceCategoryInfo(
      id: securite,
      name: 'Sécurité',
      description: 'Installation de systèmes de sécurité',
      icon: 'security',
      image: 'assets/images/categories/securite.png',
    ),
    ServiceCategoryInfo(
      id: autre,
      name: 'Autre',
      description: 'Autres services non listés',
      icon: 'more_horiz',
      image: 'assets/images/categories/autre.png',
    ),
  ];

  /// Liste des IDs des catégories (pour les dropdowns et l'API)
  static List<String> get categoryIds => allCategories.map((cat) => cat.id).toList();

  /// Liste des noms des catégories (pour l'affichage)
  static List<String> get categoryNames => allCategories.map((cat) => cat.name).toList();

  /// Obtenir les informations d'une catégorie par son ID
  static ServiceCategoryInfo? getCategoryById(String id) {
    try {
      return allCategories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Obtenir les informations d'une catégorie par son nom
  static ServiceCategoryInfo? getCategoryByName(String name) {
    try {
      return allCategories.firstWhere((cat) => cat.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Convertir un nom de catégorie en ID
  static String? nameToId(String name) {
    final category = getCategoryByName(name);
    return category?.id;
  }

  /// Convertir un ID de catégorie en nom
  static String? idToName(String id) {
    final category = getCategoryById(id);
    return category?.name;
  }

  /// Vérifier si une catégorie existe
  static bool categoryExists(String id) {
    return allCategories.any((cat) => cat.id == id);
  }

  /// Obtenir les catégories principales (les plus utilisées)
  static List<ServiceCategoryInfo> get mainCategories => [
    getCategoryById(menage)!,
    getCategoryById(plomberie)!,
    getCategoryById(electricite)!,
    getCategoryById(bricolage)!,
    getCategoryById(jardinage)!,
    getCategoryById(transport)!,
  ];

  /// Obtenir les catégories secondaires
  static List<ServiceCategoryInfo> get secondaryCategories => [
    getCategoryById(cuisine)!,
    getCategoryById(beaute)!,
    getCategoryById(peinture)!,
    getCategoryById(climatisation)!,
    getCategoryById(securite)!,
    getCategoryById(autre)!,
  ];
}

/// Classe pour stocker les informations d'une catégorie
class ServiceCategoryInfo {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String image;

  const ServiceCategoryInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.image,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceCategoryInfo && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ServiceCategoryInfo(id: $id, name: $name)';
}




