abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // Simuler une connexion réseau pour le MVP
    // Dans une vraie implémentation, utiliser connectivity_plus
    await Future.delayed(const Duration(milliseconds: 100));
    return true;
  }
}
