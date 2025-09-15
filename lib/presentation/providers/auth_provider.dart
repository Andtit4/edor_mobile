// lib/presentation/providers/auth_provider.dart
import 'dart:async';
import 'package:edor/domain/repositories/auth_repository.dart';
import 'package:edor/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../data/repositories_impl/auth_repository_impl.dart';
import '../../data/datasources/local/local_data_source.dart';
import '../../data/datasources/remote/auth_remote_data_source.dart';
import '../../domain/entities/user.dart';
import '../../core/network/network_info.dart';
import '../../core/errors/failures.dart';

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
  bool _isInitialized = false;

  AuthNotifier(this._authRepository) : super(const AuthState()) {
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
          final userResult = await _authRepository.getCurrentUser();
          userResult.fold(
            (failure) {
              print('Get current user failed: ${failure.message}');
              state = state.copyWith(
                isLoading: false,
                error: failure.message,
              );
            },
            (user) {
              print('User authenticated: ${user?.email}');
              state = state.copyWith(
                isLoading: false,
                user: user,
                isAuthenticated: user != null,
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
}) async {
  print('Attempting register for: $email');
  state = state.copyWith(isLoading: true, error: null);

  try {
    final result = await _authRepository.register(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      password: password,
      role: role,
    );

    result.fold(
      (failure) {
        print('Register failed: ${failure.message}');
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (user) async {
        print('Register successful: ${user.email}');
        
        // Récupérer le token depuis le cache après l'inscription
        final tokenResult = await _authRepository.getToken();
        String? token;
        tokenResult.fold(
          (failure) => print('Token retrieval failed: ${failure.message}'),
          (tokenData) {
            token = tokenData;
            print('Token retrieved after register: ${token?.substring(0, 20)}...');
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
    print('Register exception: $e');
    state = state.copyWith(
      isLoading: false,
      error: 'Erreur inattendue: $e',
    );
  }
}

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    final result = await _authRepository.logout();
    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (_) => state = const AuthState(isAuthenticated: false),
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});

// Convenient providers
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});