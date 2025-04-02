import 'package:client/features/home/screens/app_bar_search.dart';
import 'package:client/features/home/widgets/tenant_info.dart';
import 'package:client/features/home/widgets/user_info.dart';
import 'package:client/theme/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/features/auth/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const HomeScreen({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeNotifProvider);
    final appBar = AppBar(
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
        SizedBox(width: 8),
        UserInfo(),
        SizedBox(width: 8),
        IconButton(
          icon: Icon(currentThemeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
          tooltip: 'Toggle Theme',
          onPressed: () {
            ref
                .read(themeModeNotifProvider.notifier)
                .setThemeMode(currentThemeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
          },
        ),
        SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Logout',
          onPressed: () async {
            await ref.read(authProvider.notifier).logout();
          },
        ),
        SizedBox(width: 8), // Add some padding to the right edge
      ],
    );

    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            onDestinationSelected: (int index) {
              navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
            },
            selectedIndex: navigationShell.currentIndex,
            extended: true,
            minExtendedWidth: 175,
            leading: TenantInfo(),
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.inventory_2_outlined),
                selectedIcon: Icon(Icons.inventory_2),
                label: Text('Lots'),
              ),
              // Add more destinations...
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: Column(children: <Widget>[appBar, Expanded(child: navigationShell)])),
        ],
      ),
    );
  }
}
