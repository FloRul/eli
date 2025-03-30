import 'package:client/features/lots/screens/lots_screen.dart';
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
