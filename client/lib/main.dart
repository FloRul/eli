import 'package:client/theme/providers.dart';
import 'package:client/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart';
import 'core/providers/router_provider.dart';

// TODO: Plan d'import de data auto  ou manuel --> idealement avec un fichier csv

// TODO: 4j Companies, project and user role management page <-- admin
// TODO: 3j Reminders management page <-- user (member, admin)
// TODO: 2j Deliverable view in lots list + crud view
// TODO: 4j Dashboard view --> include deliverable due dates
// TODO: 2j integrated bug/feature suggestion report
// TODO: 6j Custom reporting + post meeting reporting
// TODO: 1j define initial selected company and project
// TODO: 6j stripe integration
// TODO: 2j localization

// total: 30j

// TODO: TBD - Global search bar

/* TODO: - Finir les todo  
         - Marianne MUST try to use the software 
         - landing page
         - stripe integration
         - setup bd production
         - lancer la beta
         - feedback - iterations
         - faire un audit de sécurité
         - lancement de la version 1.0

         - analytics with amplitude
         
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
