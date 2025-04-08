import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:client/core/providers/supabase_provider.dart';
import 'package:client/features/auth/providers/auth_provider.dart';
import 'package:client/features/companies_projects_roles/models/company.dart';
import 'package:client/features/companies_projects_roles/models/user.dart';
import 'package:client/features/companies_projects_roles/models/access.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'tenant_management_provider.g.dart';

final _tenantId = Provider((ref) => ref.watch(authProvider)?.tenantId);

@Riverpod(keepAlive: true)
class CompaniesNotifier extends _$CompaniesNotifier {
  Future<List<Company>> _fetchCompanies() async {
    final tenantId = ref.read(_tenantId);
    if (tenantId == null) throw Exception("User not authenticated or tenant ID missing");

    final response = await supabase.from('companies').select('*, projects(*)').eq('tenant_id', tenantId);

    final data = response as List<dynamic>;
    return data.map((json) => Company.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<Company>> build() async {
    return _fetchCompanies();
  }

  Future<void> addCompany(String name) async {
    final tenantId = ref.read(_tenantId);
    if (tenantId == null) throw Exception("User not authenticated or tenant ID missing");

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await supabase.from('companies').insert({'name': name, 'tenant_id': tenantId});
      return _fetchCompanies();
    });
  }

  Future<void> updateCompany(int id, String newName) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await supabase.from('companies').update({'name': newName}).eq('id', id);
      return _fetchCompanies();
    });
  }

  Future<void> deleteCompany(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await supabase.from('companies').delete().eq('id', id);
      return _fetchCompanies();
    });
  }

  Future<void> addProject(int companyId, String name) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await supabase.from('projects').insert({'name': name, 'company_id': companyId});
      return _fetchCompanies();
    });
  }

  Future<void> deleteProject(int projectId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await supabase.from('projects').delete().eq('id', projectId);
      return _fetchCompanies();
    });
  }

  Future<void> updateProject(int projectId, String newName) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await supabase.from('projects').update({'name': newName}).eq('id', projectId);
      return _fetchCompanies();
    });
  }
}

@riverpod
class TenantUsersNotifier extends _$TenantUsersNotifier {
  Future<List<TenantUser>> _fetchUsers() async {
    final tenantId = ref.read(_tenantId);
    if (tenantId == null) throw Exception("User not authenticated or tenant ID missing");

    final response = await supabase
        .from('user_tenant_roles')
        .select('user_id, role, user_profiles ( email, full_name, id )')
        .eq('tenant_id', tenantId);

    final data = response as List<dynamic>;
    return data.map((json) => TenantUser.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<TenantUser>> build() async {
    return _fetchUsers();
  }

  Future<void> updateUserRole(String userId, Role newRole) async {
    final tenantId = ref.read(_tenantId);
    if (tenantId == null) throw Exception("User not authenticated or tenant ID missing");
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        await supabase
            .from('user_tenant_roles')
            .update({'role': newRole.name})
            .eq('user_id', userId)
            .eq('tenant_id', tenantId);
        return _fetchUsers();
      },
      (err) {
        if (err is PostgrestException) {
          // TODO: Handle specific Postgrest exceptions (with snackbar and cancel update)

          print("Postgrest error: ${err.message}");
          return true;
        } else {
          print("Error updating user role: $err");
          return true;
        }
      },
    );
  }

  Future<void> grantCompanyAccess(String userId, int companyId) async {
    await supabase.from('user_company_access').insert({'user_id': userId, 'company_id': companyId});

    ref.invalidate(companyAccessProvider(companyId));
  }

  Future<void> revokeCompanyAccess(String userId, int companyId) async {
    await supabase.from('user_company_access').delete().eq('user_id', userId).eq('company_id', companyId);
    ref.invalidate(companyAccessProvider(companyId));
  }

  Future<void> grantProjectAccess(String userId, int projectId) async {
    await supabase.from('user_project_access').insert({'user_id': userId, 'project_id': projectId});
    ref.invalidate(projectAccessProvider(projectId));
  }

  Future<void> revokeProjectAccess(String userId, int projectId) async {
    await supabase.from('user_project_access').delete().eq('user_id', userId).eq('project_id', projectId);
    ref.invalidate(projectAccessProvider(projectId));
  }
}

@riverpod
Future<List<UserCompanyAccess>> companyAccess(Ref ref, int companyId) async {
  final response = await supabase.from('user_company_access').select().eq('company_id', companyId);

  final data = response as List<dynamic>;
  return data.map((json) => UserCompanyAccess.fromJson(json as Map<String, dynamic>)).toList();
}

@riverpod
Future<List<UserProjectAccess>> projectAccess(Ref ref, int projectId) async {
  final response = await supabase.from('user_project_access').select().eq('project_id', projectId);

  final data = response as List<dynamic>;
  return data.map((json) => UserProjectAccess.fromJson(json as Map<String, dynamic>)).toList();
}
