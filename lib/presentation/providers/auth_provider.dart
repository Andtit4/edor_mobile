import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/local/local_data_source.dart';
import '../../data/repositories_impl/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

// Providers pour les dépendances
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized in main()');
});

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return LocalDataSourceImpl(sharedPreferences: sharedPreferences);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final localDataSource = ref.watch(localDataSourceProvider);
  return AuthRepositoryImpl(localDataSource: localDataSource);
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
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);

    final result = await _authRepository.isLoggedIn();
    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (isLoggedIn) async {
        if (isLoggedIn) {
          final userResult = await _authRepository.getCurrentUser();
          userResult.fold(
            (failure) =>
                state = state.copyWith(
                  isLoading: false,
                  error: failure.message,
                ),
            (user) =>
                state = state.copyWith(
                  isLoading: false,
                  user: user,
                  isAuthenticated: user != null,
                ),
          );
        } else {
          state = state.copyWith(isLoading: false, isAuthenticated: false);
        }
      },
    );
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _authRepository.login(
      email: email,
      password: password,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (user) =>
          state = state.copyWith(
            isLoading: false,
            user: user,
            isAuthenticated: true,
            error: null,
          ),
    );
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _authRepository.register(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      password: password,
      role: role,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (user) =>
          state = state.copyWith(
            isLoading: false,
            user: user,
            isAuthenticated: true,
            error: null,
          ),
    );
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
