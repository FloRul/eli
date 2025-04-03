import 'package:client/core/providers/supabase_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'projects_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentProjectNotifier extends _$CurrentProjectNotifier {
  @override
  int? build() => 1;
}

@Riverpod(keepAlive: true)
Future<List<(int, String)>> projects(Ref ref) async {
  final projectsData =
      await supabase.from('projects').select('id, name').order('name', ascending: true) as List<dynamic>;
  if (projectsData.isEmpty) {
    print("No projects found.");
    return [];
  }
  // ignore: avoid_dynamic_calls
  return projectsData.map((projectJson) => (projectJson['id'] as int, projectJson['name'] as String)).toList();
}
