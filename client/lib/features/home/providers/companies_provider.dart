import 'package:client/core/providers/supabase_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'companies_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<(int, String)>> companies(Ref ref) async {
  final companiesData =
      await supabase.from('companies').select('id, name').order('name', ascending: true) as List<dynamic>;
  if (companiesData.isEmpty) {
    print("No companies found.");
    return [];
  }
  // ignore: avoid_dynamic_calls
  return companiesData.map((companyJson) => (companyJson['id'] as int, companyJson['name'] as String)).toList();
}
