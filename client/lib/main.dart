import 'package:client/theme/providers.dart';
import 'package:client/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart';
import 'core/providers/router_provider.dart';

// TODO: localization
// TODO: fix the user tenant role policy to avoid admin to "demote" themselves

// TODO: 1. lister toutes les fonctionnalités et valider les done et todo required --> when will beta be ready?
// TODO: 2. stripe integration pas necessaire pour beta mais prevoir un plan de transfert de data dans la bd production
// TODO: 3. Pland d'import de data auto ?
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
