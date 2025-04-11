import 'package:client/core/providers/supabase_provider.dart';
import 'package:client/features/dashboard/models/project_dashboard_summary.dart';
import 'package:client/features/home/providers/projects_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_summary_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<ProjectDashboardSummary?> projectDashboardSummary(Ref ref) async {
  final currentProject = ref.watch(currentProjectNotifierProvider);
  if (currentProject == null) return null; // Handle null case
  final response =
      await supabase.from('project_dashboard_summary').select('*').eq('project_id', currentProject).single();
  final Map<String, dynamic> data = response;
  return ProjectDashboardSummary.fromJson(data);
}
