import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_prefs_provider.g.dart';

@Riverpod(keepAlive: true)
Future<SharedPreferences> prefs(Ref ref) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences;
}
