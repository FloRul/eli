import 'package:client/features/auth/providers/is_admin_provider.dart';
import 'package:client/features/contacts/screens/contacts_page.dart';
import 'package:client/features/dashboard/dashboard_screen.dart';
import 'package:client/features/lots/screens/lots_page.dart';
// Import your TenantAdminPage
import 'package:client/features/companies_projects_roles/screens/tenant_admin_page.dart'; // Adjust path if needed
// Import other screens if you add more destinations
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:client/features/auth/providers/auth_provider.dart';
import 'package:client/features/auth/screens/login_screen.dart';
import 'package:client/features/home/screens/home_screen.dart';

part 'router_provider.g.dart';

// It's good practice to use keys for nested navigation
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _dashboardShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'DashboardShell');
final _lotsShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'LotsShell');
final _contactsShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'ContactsShell');
// --- Add Key for Admin Shell ---
final _adminShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'AdminShell');

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
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    refreshListenable: authStateListenable,
    debugLogDiagnostics: true,

    redirect: (BuildContext context, GoRouterState state) {
      final isAuthenticated = ref.read(authProvider) != null;

      final location = state.uri.toString();
      print('Redirecting: location=$location, isAuthenticated=$isAuthenticated');

      final isLoggingIn = location == '/login';
      final isAdminRoute = location == '/admin'; // Check if accessing admin

      if (!isAuthenticated) {
        return isLoggingIn ? null : '/login';
      }

      // --- Role-Based Redirect Example (Optional) ---
      if (isAdminRoute && !ref.read(isAdminProvider)) {
        print('Redirecting non-admin from admin route');
        return '/dashboard'; // Or show an 'unauthorized' page
      }

      if (isLoggingIn) {
        print('Redirecting authenticated user from public route to /dashboard');
        return '/dashboard';
      }

      if (location == '/') {
        print('Redirecting authenticated user from / to /dashboard');
        return '/dashboard';
      }

      return null;
    },

    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _dashboardShellNavigatorKey,
            routes: [
              GoRoute(path: '/dashboard', pageBuilder: (context, state) => NoTransitionPage(child: DashboardScreen())),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _lotsShellNavigatorKey,
            routes: [
              GoRoute(path: '/lots', pageBuilder: (context, state) => const NoTransitionPage(child: LotsPage())),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _contactsShellNavigatorKey,
            routes: [
              GoRoute(path: '/contacts', pageBuilder: (context, state) => NoTransitionPage(child: ContactPage())),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _adminShellNavigatorKey, // Use the new key
            routes: [
              GoRoute(
                path: '/admin', // Define the path for the admin page
                pageBuilder:
                    (context, state) => const NoTransitionPage(
                      // Build your TenantAdminPage here
                      child: TenantAdminPage(),
                    ),
                // You could add nested admin routes here if needed later
                // routes: [
                //   GoRoute(path: 'users', ...),
                // ]
              ),
            ],
          ),
          // --- End Admin Branch ---
        ],
      ),

      GoRoute(path: '/login', parentNavigatorKey: _rootNavigatorKey, builder: (context, state) => const LoginScreen()),
    ],

    errorBuilder:
        (context, state) =>
            Scaffold(body: Center(child: Text('Error: ${state.error?.toString() ?? "Page not found"}'))),
  );
}
