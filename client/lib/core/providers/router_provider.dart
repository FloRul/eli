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
    _authStateListener = ref.listen(authProvider, (previous, next) {
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

@riverpod
GoRouter router(Ref ref) {
  final authStateChangeNotifier = AuthStateChangeNotifier(ref);
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: authStateChangeNotifier,
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;

      final isAuthRoute = state.fullPath == '/login' || state.fullPath == '/signup';

      // If not logged in and not on an auth route, redirect to login
      if (!isLoggedIn && !isAuthRoute) {
        return '/login';
      }

      // If logged in and on an auth route, redirect to home
      if (isLoggedIn && isAuthRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    ],
    errorBuilder: (context, state) => Scaffold(body: Center(child: Text('Error: ${state.error}'))),
  );
}
