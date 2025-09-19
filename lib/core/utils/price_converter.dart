// lib/core/utils/price_converter.dart

/// Utilitaire pour la conversion des prix entre Euro et FCFA
class PriceConverter {
  // Taux de change approximatif : 1 EUR = 655.96 FCFA
  static const double _euroToFcfaRate = 655.96;
  
  /// Convertit un prix en Euro vers FCFA
  static double euroToFcfa(num euroPrice) {
    return euroPrice * _euroToFcfaRate;
  }
  
  /// Convertit un prix en FCFA vers Euro
  static double fcfaToEuro(num fcfaPrice) {
    return fcfaPrice / _euroToFcfaRate;
  }
  
  /// Formate un prix en FCFA avec le symbole
  static String formatFcfa(num fcfaPrice) {
    return '${fcfaPrice.toStringAsFixed(0)} FCFA';
  }
  
  /// Formate un prix en Euro vers FCFA avec le symbole
  static String formatEuroToFcfa(num euroPrice) {
    return formatFcfa(euroToFcfa(euroPrice));
  }
  
  /// Formate un prix par heure en FCFA
  static String formatFcfaPerHour(num fcfaPrice) {
    return '${fcfaPrice.toStringAsFixed(0)} FCFA/h';
  }
  
  /// Formate un prix par heure en Euro vers FCFA
  static String formatEuroToFcfaPerHour(num euroPrice) {
    return formatFcfaPerHour(euroToFcfa(euroPrice));
  }
}
