import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:client/features/auth/providers/auth_provider.dart';
import 'package:client/features/auth/screens/login_screen.dart';
import 'package:client/features/auth/screens/signup_screen.dart';
import 'package:client/features/home/screens/home_screen.dart';

part 'router_provider.g.dart';

// This class implements Listenable for GoRouter refresh purposes
class AuthStateChangeNotifier extends ChangeNotifier {
  AuthStateChangeNotifier(this.ref) {
    print('AuthStateChangeNotifier');
    _authStateListener = ref.listen(authProvider, (_, _) {
      notifyListeners();
    });
  }

  final Ref ref;
  late final ProviderSubscription _authStateListener;

  @override
  void dispose() {
    _authStateListener.close();
    super.dispose();
  }
}

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: AuthStateChangeNotifier(ref),
    redirect: (BuildContext context, GoRouterState state) {
      final isAuthenticated = auth != null;
      final location = state.uri.toString();
      
      // Check if we're heading to the login or signup page
      if (location == '/login' || location == '/signup') {
        return isAuthenticated ? '/' : null;
      }
      
      // If user is not authenticated and not on a public page, redirect to login
      if (!isAuthenticated) {
        return '/login';
      }
      
      // User is authenticated and not trying to access login/signup, allow navigation
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error?.toString() ?? "Unknown error"}'),
      ),
    ),
  );
}
