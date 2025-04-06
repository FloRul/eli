import 'package:client/core/providers/supabase_provider.dart';
import 'package:client/features/auth/providers/auth_provider.dart';
import 'package:client/features/companies_projects_roles/models/company.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'company_project_provider.g.dart';

@Riverpod(keepAlive: true)
class CompaniesProjectsNotifier extends _$CompaniesProjectsNotifier {
  @override
  Future<List<Company>> build() async {
    final companiesProjects = await supabase
        .from('companies')
        .select('id, name, projects (id, name), tenant_id')
        .eq('tenant_id', ref.read(authProvider)!.tenantId);

    return [];
  }
}
