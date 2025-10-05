import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/firebase_notification_service.dart';
import '../../domain/entities/user.dart';

/// État des notifications
class NotificationState {
  final bool isInitialized;
  final String? fcmToken;
  final List<String> subscribedTopics;
  final bool isLoading;
  final String? error;

  NotificationState({
    this.isInitialized = false,
    this.fcmToken,
    this.subscribedTopics = const [],
    this.isLoading = false,
    this.error,
  });

  NotificationState copyWith({
    bool? isInitialized,
    String? fcmToken,
    List<String>? subscribedTopics,
    bool? isLoading,
    String? error,
  }) {
    return NotificationState(
      isInitialized: isInitialized ?? this.isInitialized,
      fcmToken: fcmToken ?? this.fcmToken,
      subscribedTopics: subscribedTopics ?? this.subscribedTopics,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier pour gérer l'état des notifications
class NotificationNotifier extends StateNotifier<NotificationState> {
  final FirebaseNotificationService _notificationService;

  NotificationNotifier(this._notificationService) : super(NotificationState());

  /// Initialise le service de notifications
  Future<void> initialize() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _notificationService.initialize();
      state = state.copyWith(
        isInitialized: true,
        fcmToken: _notificationService.fcmToken,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Configure les notifications pour un utilisateur prestataire
  Future<void> setupPrestataireNotifications(User user) async {
    if (user.role != UserRole.prestataire) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // S'abonner aux topics des catégories du prestataire
      if (user.categories != null) {
        for (final category in user.categories!) {
          await _notificationService.subscribeToCategory(category);
        }
        
        state = state.copyWith(
          subscribedTopics: user.categories!,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Configure les notifications pour un utilisateur client
  Future<void> setupClientNotifications(User user) async {
    if (user.role != UserRole.client) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Les clients n'ont pas besoin de s'abonner aux topics de catégories
      // Ils reçoivent des notifications directes
      state = state.copyWith(
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// S'abonne à une catégorie
  Future<void> subscribeToCategory(String category) async {
    try {
      await _notificationService.subscribeToCategory(category);
      final newTopics = [...state.subscribedTopics, category];
      state = state.copyWith(subscribedTopics: newTopics);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Se désabonne d'une catégorie
  Future<void> unsubscribeFromCategory(String category) async {
    try {
      await _notificationService.unsubscribeFromCategory(category);
      final newTopics = state.subscribedTopics.where((topic) => topic != category).toList();
      state = state.copyWith(subscribedTopics: newTopics);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Envoie une notification à une catégorie
  Future<void> sendNotificationToCategory({
    required String category,
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _notificationService.sendNotificationToCategory(
        category: category,
        title: title,
        body: body,
        data: data,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Envoie une notification à un utilisateur
  Future<void> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _notificationService.sendNotificationToUser(
        userId: userId,
        title: title,
        body: body,
        data: data,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Efface l'erreur
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider pour le service de notifications
final firebaseNotificationServiceProvider = Provider<FirebaseNotificationService>((ref) {
  return FirebaseNotificationService();
});

/// Provider pour le notifier des notifications
final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier(ref.read(firebaseNotificationServiceProvider));
});




