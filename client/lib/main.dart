import 'package:client/theme/providers.dart';
import 'package:client/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart';
import 'core/providers/router_provider.dart';

// TODO: localization
// TODO: fix the user tenant role policy to avoid admin to "demote" themselves

// TODO: stripe integration pas necessaire pour beta mais prevoir un plan de transfert de data dans la bd production
// TODO: Pland d'import de data auto  ou manuel ?

// TODO: Contact management page + search <-- admin + member
// TODO: Companies management page <-- admin
// TODO: Projects management page <-- admin
// TODO: Reminders management page <-- user (member, admin)
// TODO: User tenant role management page  <-- admin

// TODO: Deliverable view in lots list + crud view
// TODO: Dashboard view

// TODO: Breadcrumbs navigation
// TODO: path navigation to specific lot,lot item, project, company, contact

// TODO: TBD - lots and lot items filter ??
// TODO: TBD - integrated bug/feature suggestion report ??
// TODO: TBD - Global search bar ??
// TODO: TBD - SUPABASE realtime subscription/broadcast
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
