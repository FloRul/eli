import 'package:client/features/lots/screens/lots_screen.dart';
import 'package:client/theme/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/features/auth/providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eli'),
        actions: [
          if (user != null) ...[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                children: [
                  if (user.avatarUrl != null)
                    CircleAvatar(backgroundImage: NetworkImage(user.avatarUrl!), radius: 16)
                  else
                    const CircleAvatar(radius: 16, child: Icon(Icons.person, size: 16)),
                  const SizedBox(width: 8),
                  Text(user.fullName ?? user.email.split('@').first),
                ],
              ),
            ),
            IconButton(
              icon: Icon(ref.watch(themeModeNotifProvider) == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                ref
                    .read(themeModeNotifProvider.notifier)
                    .setThemeMode(
                      ref.read(themeModeNotifProvider) == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
                    );
              },
            ),
          ],
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: Center(
        child:
            // user != null
            //     ? Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Text('Welcome, ${user.fullName ?? user.email}!'),
            //         const SizedBox(height: 20),
            //         Text('Email: ${user.email}'),
            //         Text('User ID: ${user.id}'),
            //       ],
            //     )
            //     : const CircularProgressIndicator(),
            LotsScreen(),
      ),
    );
  }
}
