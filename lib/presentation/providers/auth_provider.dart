// lib/presentation/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../data/datasources/local/local_data_source.dart';
import '../../data/datasources/remote/auth_remote_data_source.dart';
import '../../data/repositories_impl/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/network/network_info.dart';
import '../../main.dart';

// Providers pour les dépendances
final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return LocalDataSourceImpl(sharedPreferences: sharedPreferences);
});

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl();
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final client = http.Client();
  final networkInfo = ref.watch(networkInfoProvider);
  return AuthRemoteDataSourceImpl(client: client, networkInfo: networkInfo);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final localDataSource = ref.watch(localDataSourceProvider);
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );
});

// Auth State
class AuthState {
  final User? user;
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    bool? isAuthenticated,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error,
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
        (user) {
          print('Login successful: ${user.email}');
          state = state.copyWith(
            isLoading: false,
            user: user,
            isAuthenticated: true,
            error: null,
          );
        },
      );
    } catch (e) {
      print('Login exception: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Une erreur inattendue s\'est produite',
      );
    }
  }

 // lib/presentation/providers/auth_provider.dart
Future<void> register({
  required String lastName,
  required String phone,
  required String firstName,
  required String email,
  required String password,
  required UserRole role,
}) async {
  print('AuthNotifier: Starting register for: $email');
  state = state.copyWith(isLoading: true, error: null);

  try {
    print('AuthNotifier: Calling repository...');
    final result = await _authRepository.register(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      password: password,
      role: role,
    );

    print('AuthNotifier: Repository returned result');
    result.fold(
      (failure) {
        print('AuthNotifier: Register failed: ${failure.message}');
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (user) {
        print('AuthNotifier: Register successful: ${user.email}');
        print('AuthNotifier: Setting state to authenticated...');
        state = state.copyWith(
          isLoading: false,
          user: user,
          isAuthenticated: true,
          error: null,
        );
        print('AuthNotifier: State updated - isAuthenticated: ${state.isAuthenticated}');
      },
    );
  } catch (e) {
    print('AuthNotifier: Register exception: $e');
    state = state.copyWith(
      isLoading: false,
      error: 'Une erreur inattendue s\'est produite: $e',
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