import 'package:client/features/dashboard/dashboard_screen.dart';
import 'package:client/features/lots/screens/lots_screen.dart'; // Import LotsScreen
// Import other screens if you add more destinations
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:client/features/auth/providers/auth_provider.dart';
import 'package:client/features/auth/screens/login_screen.dart';
import 'package:client/features/auth/screens/signup_screen.dart';
import 'package:client/features/home/screens/home_screen.dart';

part 'router_provider.g.dart';

// It's good practice to use keys for nested navigation
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _dashboardShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'DashboardShell');
final _lotsShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'LotsShell'); // Key for the shell's navigator

class AuthStateChangeNotifier extends ChangeNotifier {
  AuthStateChangeNotifier(this.ref) {
    print('AuthStateChangeNotifier Initialized');
    _authStateListener = ref.listen(authProvider, (previous, next) {
      print('Auth state changed: ${next != null}');
      notifyListeners();
    });
  }

  final Ref ref;
  late final ProviderSubscription _authStateListener;

  @override
  void dispose() {
    print('AuthStateChangeNotifier Disposed'); // Debugging log
    _authStateListener.close();
    super.dispose();
  }
}

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final authStateListenable = AuthStateChangeNotifier(ref);
  return GoRouter(
    navigatorKey: _rootNavigatorKey, // Root navigator
    initialLocation: '/login', // Start at login, redirect will handle authenticated users
    refreshListenable: authStateListenable,
    debugLogDiagnostics: true, // Enable GoRouter logging for easier debugging

    redirect: (BuildContext context, GoRouterState state) {
      final isAuthenticated = ref.read(authProvider) != null;
      final location = state.uri.toString();
      print('Redirecting: location=$location, isAuthenticated=$isAuthenticated'); // Debugging log

      final isLoggingIn = location == '/login';
      final isSigningUp = location == '/signup';
      final isPublic = isLoggingIn || isSigningUp;

      // If user is NOT authenticated:
      if (!isAuthenticated) {
        // Allow access only to login or signup pages
        return isPublic ? null : '/login';
      }

      // If user IS authenticated:
      // If they are trying to access login/signup, redirect them to the main app page (e.g., '/dashboard')
      if (isPublic) {
        print('Redirecting authenticated user from public route to /dashboard'); // Debugging log
        return '/dashboard'; // Default page after login
      }

      // If user is authenticated and at the root '/', redirect to default shell page
      if (location == '/') {
        print('Redirecting authenticated user from / to /dashboard'); // Debugging log
        return '/dashboard';
      }

      // Otherwise, allow access
      return null;
    },

    routes: [
      // --- ShellRoute for Authenticated Users ---
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // Pass the navigationShell to the HomeScreen
          // HomeScreen will use navigationShell to display the correct content
          // and to handle navigation rail taps
          return HomeScreen(navigationShell: navigationShell);
        },
        branches: [
          // Each branch defines a section managed by the NavigationRail
          StatefulShellBranch(
            navigatorKey: _dashboardShellNavigatorKey, // Use a specific key for this branch
            routes: [
              GoRoute(
                path: '/dashboard', // The path for the first navigation item
                pageBuilder:
                    (context, state) => NoTransitionPage(
                      // Replace Placeholder with your actual DashboardScreen
                      // child: Placeholder(child: Center(child:Text('Dashboard Screen'))),
                      child: DashboardScreen(), // Use your actual Dashboard screen
                    ),
                // Nested routes for dashboard can go here
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _lotsShellNavigatorKey, // Use a specific key for this branch
            routes: [
              GoRoute(
                path: '/lots', // The path for the second navigation item
                pageBuilder:
                    (context, state) => const NoTransitionPage(
                      child: LotsScreen(), // Use the imported LotsScreen
                    ),
                // Nested routes for lots can go here (e.g., '/lots/details/:id')
                // routes: [
                //   GoRoute(path: 'details/:id', ...),
                // ],
              ),
            ],
          ),
          // --- Add more branches for other NavigationRail destinations ---
          // Example: Settings Branch
          /*
          StatefulShellBranch(
            // Add a navigator key if this branch has its own sub-navigation
            // navigatorKey: _settingsShellNavigatorKey,
            routes: [
              GoRoute(
                path: '/settings',
                pageBuilder: (context, state) => const NoTransitionPage(
                   // Replace with your actual SettingsScreen
                  child: Scaffold(body: Center(child: Text('Settings Screen'))),
                ),
              ),
            ],
          ),
          */
        ],
      ),

      // --- Non-Shelled Routes (Login, Signup) ---
      GoRoute(
        path: '/login',
        // Use parentNavigatorKey to ensure these routes take over the whole screen
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SignupScreen(),
      ),
    ],

    errorBuilder:
        (context, state) =>
            Scaffold(body: Center(child: Text('Error: ${state.error?.toString() ?? "Page not found"}'))),
  );
}
