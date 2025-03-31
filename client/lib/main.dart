import 'package:client/theme/providers.dart';
import 'package:client/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart';
import 'core/providers/router_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(url: SupabaseConfig.supabaseUrl, anonKey: SupabaseConfig.supabaseAnonKey);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Eli',
      theme: theme,
      darkTheme: darkTheme,
      themeMode: ref.watch(themeModeNotifProvider),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
