// lib/presentation/providers/auth_provider.dart
import 'dart:async';
import 'package:edor/domain/repositories/auth_repository.dart';
import 'package:edor/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../data/repositories_impl/auth_repository_impl.dart';
import '../../data/datasources/local/local_data_source.dart';
import '../../data/datasources/remote/auth_remote_data_source.dart';
import '../../domain/entities/user.dart';
import '../../core/network/network_info.dart';
import '../../core/services/social_auth_service.dart';
import '../../core/services/simple_google_auth_service.dart';
import '../widgets/role_selection_dialog.dart';

// Providers pour les dépendances
final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return LocalDataSourceImpl(sharedPreferences: sharedPreferences);
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final client = http.Client();
  final networkInfo = ref.watch(networkInfoProvider);
  return AuthRemoteDataSourceImpl(client: client, networkInfo: networkInfo);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final localDataSource = ref.watch(localDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: networkInfo,
  );
});

// Auth State
class AuthState {
  final User? user;
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;
  final String? token;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
    this.token,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    bool? isAuthenticated,
    String? error,
    String? token,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error,
      token: token ?? this.token,
    );
  }
}

// Auth State Notifier
// lib/presentation/providers/auth_provider.dart
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final LocalDataSource _localDataSource;
  bool _isInitialized = false;

  AuthNotifier(this._authRepository, this._localDataSource) : super(const AuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    if (_isInitialized) return; // Éviter les vérifications multiples
    
    state = state.copyWith(isLoading: true);
    _isInitialized = true;

    final result = await _authRepository.isLoggedIn();
    result.fold(
      (failure) {
        print('Auth check failed: ${failure.message}');
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (isLoggedIn) async {
        if (isLoggedIn) {
          // Récupérer l'utilisateur et le token
          final userResult = await _authRepository.getCurrentUser();
          final tokenResult = await _authRepository.getToken();
          
          userResult.fold(
            (failure) {
              print('Get current user failed: ${failure.message}');
              state = state.copyWith(
                isLoading: false,
                error: failure.message,
              );
            },
            (user) async {
              print('User authenticated: ${user?.email}');
              
              // Récupérer le token
              String? token;
              tokenResult.fold(
                (failure) => print('Token retrieval failed: ${failure.message}'),
                (tokenData) {
                  token = tokenData;
                  print('Token retrieved: ${token?.substring(0, 20)}...');
                },
              );
              
              state = state.copyWith(
                isLoading: false,
                user: user,
                isAuthenticated: user != null,
                token: token, // Ajouter le token à l'état
              );
            },
          );
        } else {
          print('User not logged in');
          state = state.copyWith(isLoading: false, isAuthenticated: false);
        }
      },
    );
  }

  Future<void> login({required String email, required String password}) async {
    print('Attempting login for: $email');
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authRepository.login(
        email: email,
        password: password,
      );

      result.fold(
        (failure) {
          print('Login failed: ${failure.message}');
          state = state.copyWith(isLoading: false, error: failure.message);
        },
        (user) async {
          print('Login successful: ${user.email}');
          
          // Récupérer le token depuis le cache après la connexion
          final tokenResult = await _authRepository.getToken();
          String? token;
          tokenResult.fold(
            (failure) => print('Token retrieval failed: ${failure.message}'),
            (tokenData) {
              token = tokenData;
              print('Token retrieved after login: ${token?.substring(0, 20)}...');
            },
          );
          
          state = state.copyWith(
            isLoading: false,
            user: user,
            isAuthenticated: true,
            token: token, // Ajouter le token à l'état
            error: null,
          );
        },
      );
    } catch (e) {
      print('Login exception: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur inattendue: $e',
      );
    }
  }

 // lib/presentation/providers/auth_provider.dart
Future<void> register({
  required String email,
  required String password,
  required String firstName,
  required String lastName,
  required String phone,
  required UserRole role,
  String? category,
  String? location,
  String? description,
  double? pricePerHour,
  List<String>? skills,
}) async {
  state = state.copyWith(isLoading: true, error: null);
  
  print('=== REGISTER START ===');
  print('Email: $email');
  print('Role: $role');
  print('Category: $category');
  print('Location: $location');
  print('=====================');

  final result = await _authRepository.register(
    email: email,
    password: password,
    firstName: firstName,
    lastName: lastName,
    phone: phone,
    role: role,
    category: category,
    location: location,
    description: description,
    pricePerHour: pricePerHour,
    skills: skills,
  );

  result.fold(
    (failure) {
      print('Register failed: ${failure.message}');
      state = state.copyWith(
        isLoading: false,
        error: failure.message,
      );
    },
    (user) {
      print('Register success: ${user.email}');
      // Récupérer le token
      _authRepository.getToken().then((tokenResult) {
        tokenResult.fold(
          (failure) => print('Token retrieval failed: ${failure.message}'),
          (token) {
            state = state.copyWith(
              isLoading: false,
              isAuthenticated: true,
              user: user,
              token: token,
              error: null,
            );
            print('Auth state updated with token');
          },
        );
      });
    },
  );
}

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      // Déconnexion de Google Auth
      await SimpleGoogleAuthService.signOut();
      
      // Déconnexion via le repository
      final result = await _authRepository.logout();
      result.fold(
        (failure) =>
            state = state.copyWith(isLoading: false, error: failure.message),
        (_) => state = const AuthState(isAuthenticated: false),
      );
      
      print('✅ Déconnexion Google et locale réussie');
    } catch (e) {
      print('🔴 Erreur lors de la déconnexion: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors de la déconnexion',
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<void> updateProfileImage(String imageUrl) async {
    print('=== UPDATE PROFILE IMAGE ===');
    print('Current user: ${state.user}');
    print('Image URL: $imageUrl');
    
    if (state.user != null) {
      // Créer une copie de l'utilisateur avec la nouvelle image
      final updatedUser = state.user!.copyWith(profileImage: imageUrl);
      print('Updated user: $updatedUser');
      
      state = state.copyWith(user: updatedUser);
      print('State updated with new user');
    } else {
      print('No user in state, cannot update profile image');
    }
    print('==================');
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String bio,
    required String address,
    required String city,
    required String postalCode,
    required UserRole role,
  }) async {
    if (state.user != null) {
      // Créer une copie de l'utilisateur avec les nouvelles données
      final updatedUser = state.user!.copyWith(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        bio: bio,
        address: address,
        city: city,
        postalCode: postalCode,
        role: role,
      );
      
      state = state.copyWith(user: updatedUser);
    }
  }

  Future<void> refreshToken() async {
    final tokenResult = await _authRepository.getToken();
    tokenResult.fold(
      (failure) => print('Token refresh failed: ${failure.message}'),
      (token) {
        print('Token refreshed: ${token.substring(0, 20)}...');
        state = state.copyWith(token: token);
      },
    );
  }

  // Social Authentication Methods
  Future<void> signInWithGoogle({UserRole role = UserRole.client, BuildContext? context}) async {
    if (context == null) {
      state = state.copyWith(isLoading: false, error: 'Contexte manquant pour l\'authentification Google');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      print('🔵 === DÉBUT AUTHENTIFICATION GOOGLE FIREBASE ===');
      
      // Utiliser Google Auth simple pour l'authentification Google
      final firebaseData = await SimpleGoogleAuthService.signInWithGoogle();
      
      if (firebaseData == null) {
        print('🔴 Authentification Google Firebase échouée ou annulée');
        state = state.copyWith(isLoading: false, error: 'Authentification Google annulée');
        return;
      }

      print('✅ Données Firebase récupérées avec succès');
      
      // Afficher le dialogue de sélection de rôle
      final selectedRole = await _showRoleSelectionDialog(
        context: context,
        email: firebaseData['email'] as String,
        firstName: firebaseData['firstName'] as String,
        lastName: firebaseData['lastName'] as String,
        profileImage: firebaseData['profileImage'] as String?,
      );
      
      if (selectedRole == null) {
        print('🔴 Sélection de rôle annulée');
        // Déconnecter de Google si l'utilisateur annule
        await SimpleGoogleAuthService.signOut();
        state = state.copyWith(isLoading: false, error: 'Sélection de rôle annulée');
        return;
      }

      print('✅ Rôle sélectionné: $selectedRole');
      
      // Synchroniser avec le backend
      print('🔵 Synchronisation avec le backend...');
      final backendResponse = await SimpleGoogleAuthService.syncWithBackend(firebaseData, selectedRole);
      
      if (backendResponse == null) {
        print('🔴 Échec de la synchronisation backend');
        state = state.copyWith(isLoading: false, error: 'Erreur lors de la synchronisation avec le serveur');
        return;
      }

      print('✅ Réponse backend reçue: $backendResponse');
      final user = User.fromJson(backendResponse['user']);
      final token = backendResponse['token'] as String;

      print('🔵 Utilisateur créé: ${user.email}, Rôle: ${user.role}');
      print('🔵 Token reçu: ${token.substring(0, 20)}...');

      // Sauvegarder la session
      print('🔵 Sauvegarde de la session...');
      await _localDataSource.saveToCache('current_user', user.toJson());
      await _localDataSource.saveToCache('auth_token', {'token': token});
      await _localDataSource.saveToCache('is_logged_in', {'value': true});
      await _localDataSource.saveToCache('firebase_uid', {'uid': firebaseData['firebaseUid']});

      print('🔵 Mise à jour de l\'état AuthProvider...');
      state = state.copyWith(
        isLoading: false,
        user: user,
        isAuthenticated: true,
        token: token,
        error: null,
      );
      
      print('✅ Authentification Google Firebase réussie pour: ${user.email}');
      print('✅ État final: isAuthenticated=${state.isAuthenticated}, user=${state.user?.email}');
    } catch (e) {
      print('🔴 Erreur lors de l\'authentification Google Firebase: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors de la connexion Google: ${e.toString()}',
      );
    }
  }

  // Méthode pour la connexion Google (sans sélection de rôle)
  Future<void> loginWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      print('🔵 === DÉBUT CONNEXION GOOGLE ===');
      
      // Utiliser Google Auth simple pour l'authentification Google
      final firebaseData = await SimpleGoogleAuthService.signInWithGoogle();
      
      if (firebaseData == null) {
        print('🔴 Connexion Google échouée ou annulée');
        state = state.copyWith(isLoading: false, error: 'Connexion Google annulée');
        return;
      }

      print('✅ Données Google récupérées avec succès');
      
      // Pour la connexion, on utilise le rôle par défaut (client)
      // Le backend déterminera le bon rôle selon l'utilisateur existant
      final defaultRole = UserRole.client;
      
      // Synchroniser avec le backend
      print('🔵 Synchronisation avec le backend...');
      final backendResponse = await SimpleGoogleAuthService.syncWithBackend(firebaseData, defaultRole);
      
      if (backendResponse == null) {
        print('🔴 Échec de la synchronisation backend');
        state = state.copyWith(isLoading: false, error: 'Erreur lors de la connexion avec le serveur');
        return;
      }

      print('✅ Réponse backend reçue: $backendResponse');
      final user = User.fromJson(backendResponse['user']);
      final token = backendResponse['token'] as String;

      print('🔵 Utilisateur connecté: ${user.email}, Rôle: ${user.role}');
      print('🔵 Token reçu: ${token.substring(0, 20)}...');

      // Sauvegarder la session
      print('🔵 Sauvegarde de la session...');
      await _localDataSource.saveToCache('current_user', user.toJson());
      await _localDataSource.saveToCache('auth_token', {'token': token});
      await _localDataSource.saveToCache('is_logged_in', {'value': true});
      await _localDataSource.saveToCache('firebase_uid', {'uid': firebaseData['firebaseUid']});

      print('🔵 Mise à jour de l\'état AuthProvider...');
      state = state.copyWith(
        isLoading: false,
        user: user,
        isAuthenticated: true,
        token: token,
        error: null,
      );
      
      print('✅ Connexion Google réussie pour: ${user.email}');
      print('✅ État final: isAuthenticated=${state.isAuthenticated}, user=${state.user?.email}');
    } catch (e) {
      print('🔴 Erreur lors de la connexion Google: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors de la connexion Google: ${e.toString()}',
      );
    }
  }

  // Méthode pour afficher le dialogue de sélection de rôle
  Future<UserRole?> _showRoleSelectionDialog({
    required BuildContext context,
    required String email,
    required String firstName,
    required String lastName,
    String? profileImage,
  }) async {
    return await showDialog<UserRole>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return RoleSelectionDialog(
          email: email,
          firstName: firstName,
          lastName: lastName,
          profileImage: profileImage,
          onRoleSelected: (UserRole role) {
            Navigator.of(context).pop(role);
          },
        );
      },
    );
  }

  Future<void> signInWithFacebook({UserRole role = UserRole.client}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final socialData = await SocialAuthService.signInWithFacebook();
      if (socialData == null) {
        state = state.copyWith(isLoading: false, error: 'Connexion Facebook annulée');
        return;
      }

      final backendResponse = await SocialAuthService.authenticateWithBackend(socialData, role);
      if (backendResponse == null) {
        state = state.copyWith(isLoading: false, error: 'Erreur lors de l\'authentification');
        return;
      }

      final user = User.fromJson(backendResponse['user']);
      final token = backendResponse['token'] as String;

      // Sauvegarder la session
      await _localDataSource.saveToCache('current_user', user.toJson());
      await _localDataSource.saveToCache('auth_token', {'token': token});
      await _localDataSource.saveToCache('is_logged_in', {'value': true});

      state = state.copyWith(
        isLoading: false,
        user: user,
        isAuthenticated: true,
        token: token,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Erreur Facebook: $e');
    }
  }

  Future<void> signInWithApple({UserRole role = UserRole.client}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final socialData = await SocialAuthService.signInWithApple();
      if (socialData == null) {
        state = state.copyWith(isLoading: false, error: 'Connexion Apple annulée');
        return;
      }

      final backendResponse = await SocialAuthService.authenticateWithBackend(socialData, role);
      if (backendResponse == null) {
        state = state.copyWith(isLoading: false, error: 'Erreur lors de l\'authentification');
        return;
      }

      final user = User.fromJson(backendResponse['user']);
      final token = backendResponse['token'] as String;

      // Sauvegarder la session
      await _localDataSource.saveToCache('current_user', user.toJson());
      await _localDataSource.saveToCache('auth_token', {'token': token});
      await _localDataSource.saveToCache('is_logged_in', {'value': true});

      state = state.copyWith(
        isLoading: false,
        user: user,
        isAuthenticated: true,
        token: token,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Erreur Apple: $e');
    }
  }
}

// Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final localDataSource = ref.watch(localDataSourceProvider);
  return AuthNotifier(authRepository, localDataSource);
});

// Convenient providers
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});