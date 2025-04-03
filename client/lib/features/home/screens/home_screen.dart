import 'package:client/features/home/providers/companies_provider.dart';
import 'package:client/features/home/providers/projects_provider.dart';
import 'package:client/features/home/screens/app_bar_search.dart';
import 'package:client/features/home/widgets/pill_dropdown.dart';
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
    final companyListAsync = ref.watch(companiesProvider);
    final projectListAsync = ref.watch(projectsProvider);
    final selectedCompanyId = ref.watch(currentCompanyNotifierProvider);
    final selectedProjectId = ref.watch(currentProjectNotifierProvider);

    // Get access to the notifiers to update the state
    final companyNotifier = ref.read(currentCompanyNotifierProvider.notifier);
    final projectNotifier = ref.read(currentProjectNotifierProvider.notifier);

    final currentThemeMode = ref.watch(themeModeNotifProvider);
    final appBar = AppBar(
      centerTitle: true,
      title: Row(
        children: [
          Expanded(
            child: PillDropdownWidget(
              itemsProvider: companyListAsync,
              currentSelectedId: selectedCompanyId,
              onSelected: (id) => companyNotifier.setCompany(id),
              hintText: 'Select a Company',
              noItemsText: 'No companies found',
              addNoneOption: false, // Allow clearing the selection
            ),
          ),
          Expanded(
            child: PillDropdownWidget(
              itemsProvider: projectListAsync,
              currentSelectedId: selectedProjectId,
              onSelected: (id) => projectNotifier.setProject(id),
              hintText: 'Select a Project',
              noItemsText: 'No projects found',
              addNoneOption: false, // Allow clearing the selection
            ),
          ),
          Expanded(child: AppBarSearch()),
        ],
      ),
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
