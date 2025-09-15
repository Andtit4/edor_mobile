import 'package:edor/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final sharedPreferences = await SharedPreferences.getInstance();
  
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const EdorApp(),
    ),
  );
}

// Provider pour SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized in main()');
});

class EdorApp extends ConsumerWidget {
  const EdorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider); 

     // Debug: Écouter les changements d'état d'auth
    ref.listen<AuthState>(authProvider, (previous, next) {
      print('=== AUTH STATE CHANGE ===');
      print('Previous: isLoading=${previous?.isLoading}, isAuthenticated=${previous?.isAuthenticated}');
      print('Next: isLoading=${next.isLoading}, isAuthenticated=${next.isAuthenticated}, user=${next.user?.email}');
      print('Error: ${next.error}');
      print('========================');
    });
    
    return MaterialApp.router(
      title: 'Edor',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}