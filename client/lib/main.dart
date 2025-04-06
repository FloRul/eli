import 'package:client/theme/providers.dart';
import 'package:client/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart';
import 'core/providers/router_provider.dart';

// TODO: localization
// TODO: test fix the user tenant role policy to avoid admin to "demote" themselves

// TODO: Plan d'import de data auto  ou manuel --> idealement avec un fichier csv

// TODO: define initial selected company and project 
// TODO: 6j Companies, project and user rol management page <-- admin
// TODO: 3j Reminders management page <-- user (member, admin)
// TODO: 6j stripe integration

// TODO: 2j Deliverable view in lots list + crud view
// TODO: 6j Dashboard view --> include deliverable due dates
// TODO: 2j - integrated bug/feature suggestion report

// TODO: TBD - lots and lot items filter ??
// TODO: TBD - Breadcrumbs navigation
// TODO: TBD - Global search bar ??
// TODO: TBD - Custom reporting ????????
// TODO: TBD - SUPABASE plan upgrade

/* TODO: 1. Finir les todo  
         2. Marianne MUST try to use the software 
         3. landing page
         4. setup bd production
         5. lancer la beta
         6. stripe integration
         7. lancement de la version 1.0
 */

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
