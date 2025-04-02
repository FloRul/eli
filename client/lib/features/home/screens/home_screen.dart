import 'package:client/features/lots/screens/lots_screen.dart';
import 'package:client/theme/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/features/auth/providers/auth_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  // Changed to ConsumerStatefulWidget to manage selectedIndex
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0; // State for the selected navigation rail item
  final TextEditingController _searchController = TextEditingController(); // Controller for search bar

  @override
  void dispose() {
    _searchController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    final currentThemeMode = ref.watch(themeModeNotifProvider);
    final theme = Theme.of(context); // Get theme for styling

    // Define the main content screens based on index
    // Add more screens here as needed for more destinations
    final List<Widget> screens = [
      const LotsScreen(),
      // Example: Add another screen for a potential second destination
      // const PlaceholderWidget(color: Colors.blue),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SearchAnchor(
          builder: (BuildContext context, SearchController controller) {
            return SearchBar(
              constraints: BoxConstraints(maxWidth: 400, minWidth: 200, maxHeight: 36, minHeight: 36),
              controller: controller,
              padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
              onTap: () {
                controller.openView();
              },
              onChanged: (_) {
                controller.openView();
              },
              leading: const Icon(Icons.search),
            );
          },
          suggestionsBuilder: (BuildContext context, SearchController controller) {
            return List<ListTile>.generate(5, (int index) {
              final String item = 'item $index';
              return ListTile(
                title: Text(item),
                onTap: () {
                  setState(() {
                    controller.closeView(item);
                  });
                },
              );
            });
          },
        ),
        // Actions are now moved to the NavigationRail's trailing section
      ),
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
                // Potentially navigate or update content based on index
              });
            },
            labelType: NavigationRailLabelType.selected, // Show label for selected item only
            // --- Leading Section (Optional) ---
            // leading: const FloatingActionButton( // Example leading widget
            //   elevation: 0,
            //   onPressed: null, // Add functionality if needed
            //   child: Icon(Icons.add),
            // ),

            // --- Navigation Destinations ---
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.inventory_2_outlined),
                selectedIcon: Icon(Icons.inventory_2),
                label: Text('Lots'),
              ),
              // Add more destinations here if needed
              // NavigationRailDestination(
              //   icon: Icon(Icons.settings_outlined),
              //   selectedIcon: Icon(Icons.settings),
              //   label: Text('Settings'),
              // ),
            ],

            // --- Trailing Section (User Info, Theme, Logout) ---
            trailing: Expanded(
              // Use Expanded to push content to bottom
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0), // Add some padding at the very bottom
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end, // Align items to the bottom
                  crossAxisAlignment: CrossAxisAlignment.center, // Center items horizontally
                  children: <Widget>[
                    const Divider(), // Optional separator
                    if (user != null) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 4.0,
                        ), // Added horizontal padding too
                        // --- MODIFIED ROW ---
                        child: Row(
                          // Removed MainAxisAlignment.center
                          mainAxisSize: MainAxisSize.min, // Try to make Row take minimum space needed horizontally
                          children: [
                            if (user.avatarUrl != null)
                              CircleAvatar(backgroundImage: NetworkImage(user.avatarUrl!), radius: 16)
                            else
                              const CircleAvatar(radius: 16, child: Icon(Icons.person, size: 16)),
                            const SizedBox(width: 8),
                            Flexible(
                              // Flexible allows Text to take remaining space WITHIN the Row's bounded width
                              child: Text(
                                user.fullName ?? user.email.split('@').first,
                                overflow: TextOverflow.ellipsis, // Prevent overflow
                                textAlign: TextAlign.center, // Center text if it wraps
                              ),
                            ),
                          ],
                        ),
                        // --- END MODIFIED ROW ---
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, left: 4.0, right: 4.0), // Added horizontal padding
                        child: Text(
                          user.tenantName,
                          style: theme.textTheme.bodySmall, // Smaller text for tenant
                          textAlign: TextAlign.center, // Center tenant name
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ] else ...[
                      const Padding(
                        // Placeholder if user is null
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: CircleAvatar(radius: 16, child: Icon(Icons.person_off, size: 16)),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text('Not logged in', style: TextStyle(fontSize: 12)),
                      ),
                    ],

                    // --- Theme Toggle ---
                    IconButton(
                      icon: Icon(currentThemeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
                      tooltip: 'Toggle Theme', // Accessibility
                      onPressed: () {
                        ref
                            .read(themeModeNotifProvider.notifier)
                            .setThemeMode(currentThemeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
                      },
                    ),

                    // --- Logout Button ---
                    IconButton(
                      icon: const Icon(Icons.logout),
                      tooltip: 'Logout', // Accessibility
                      onPressed: () async {
                        // Add confirmation dialog maybe?
                        await ref.read(authProvider.notifier).logout();
                        // Navigation after logout should be handled by the auth state listener usually
                      },
                    ),
                  ],
                ),
              ),
            ),
            // You might want to adjust minWidth/minExtendedWidth based on content
            minWidth: 56, // Standard width for icon-only rail
            // minExtendedWidth: 180, // Width when labels are shown (if labelType changes)
          ),
          const VerticalDivider(thickness: 1, width: 1), // Visual separation
          // --- Main Content Area ---
          Expanded(
            // Use the selected index to show the correct screen
            child: Center(child: screens[_selectedIndex]),
          ),
        ],
      ),
    );
  }
}
