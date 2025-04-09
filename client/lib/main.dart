import 'package:client/theme/eli_theme.dart';
import 'package:client/theme/providers.dart';
import 'package:client/theme/theme.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart';
import 'core/providers/router_provider.dart';

// TODO: Plan d'import de data auto  ou manuel --> idealement avec un fichier csv

// TODO: 4j Dashboard view --> include deliverable due dates
// TODO: 6j Custom reporting + post meeting reporting
// TODO: 2j expediter assignment in lots
// TODO: 2j interactive lot display
// TODO: 6j stripe integration
// TODO: 2j review all input fields and forms for validation and error handling
// TODO: 2j localization
// TODO: 3j polish UI --> uniformity, colors, fonts, etc.
/*
  - check all radius
  - check all colors
  - check all font sizes
  - check all paddings
  - check all shadows
  - check all borders
*/

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
late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await Supabase.initialize(url: SupabaseConfig.supabaseUrl, anonKey: SupabaseConfig.supabaseAnonKey);

  runApp(
    ProviderScope(
      child: MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        debugShowCheckedModeBanner: false,
        home: BetterFeedback(child: MyApp()),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Eli',
      theme: EliTheme.light,
      darkTheme: EliTheme.dark,
      themeMode: ref.watch(themeModeNotifProvider),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
