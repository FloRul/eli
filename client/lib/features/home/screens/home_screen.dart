import 'package:client/features/home/screens/app_bar_search.dart';
import 'package:client/theme/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/features/auth/providers/auth_provider.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter

class HomeScreen extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const HomeScreen({required this.navigationShell, super.key});

  void _onItemTapped(int index) {
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final currentThemeMode = ref.watch(themeModeNotifProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppBarSearch(),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              // Implement refresh functionality if needed
            },
          ),
          IconButton(
            icon: Icon(currentThemeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Toggle Theme',
            onPressed: () {
              ref
                  .read(themeModeNotifProvider.notifier)
                  .setThemeMode(currentThemeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
            },
          ),

          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              // GoRouter's redirect will handle navigation to /login
            },
          ),
        ],
      ),
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _onItemTapped,
            labelType: NavigationRailLabelType.selected,
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.inventory_2_outlined),
                selectedIcon: Icon(Icons.inventory_2),
                label: Text('Lots'),
              ),
              // Add more destinations corresponding to your StatefulShellRoute branches
              // NavigationRailDestination(
              //   icon: Icon(Icons.settings_outlined),
              //   selectedIcon: Icon(Icons.settings),
              //   label: Text('Settings'),
              // ),
            ],

            // --- Trailing Section (User Info, Theme, Logout) ---
            trailing: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Divider(),
                  if (user != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (user.avatarUrl != null)
                            CircleAvatar(backgroundImage: NetworkImage(user.avatarUrl!), radius: 16)
                          else
                            const CircleAvatar(radius: 16, child: Icon(Icons.person, size: 16)),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              user.fullName ?? user.email.split('@').first,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0, right: 4.0),
                      child: Text(
                        user.tenantName,
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ] else ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: CircleAvatar(radius: 16, child: Icon(Icons.person_off, size: 16)),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text('Not logged in', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ],
              ),
            ),
            minWidth: 56,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // --- Main Content Area ---
          // The navigationShell widget manages displaying the correct page
          // based on the current branch
          Expanded(
            child: navigationShell, // Use the navigationShell directly here
          ),
        ],
      ),
    );
  }
}
