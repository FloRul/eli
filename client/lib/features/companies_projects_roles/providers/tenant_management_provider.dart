// companies_projects_roles/providers/tenant_management_provider.dart (New or Refactored File)

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:client/core/providers/supabase_provider.dart'; // Your Supabase client provider
import 'package:client/features/auth/providers/auth_provider.dart'; // Your Auth provider
import 'package:client/features/companies_projects_roles/models/company.dart';
import 'package:client/features/companies_projects_roles/models/user.dart';
import 'package:client/features/companies_projects_roles/models/access.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'tenant_management_provider.g.dart'; // Will be generated

// Provider to get current tenant ID (ensure your authProvider exposes this)
final _tenantId = Provider((ref) => ref.watch(authProvider)?.tenantId);

// == Companies Management ==
@riverpod
class CompaniesNotifier extends _$CompaniesNotifier {
  Future<List<Company>> _fetchCompanies() async {
    final tenantId = ref.read(_tenantId);
    if (tenantId == null) throw Exception("User not authenticated or tenant ID missing");

    final response = await supabase
        .from('companies')
        .select('*, projects(*)') // Fetch companies and nested projects
        .eq('tenant_id', tenantId);

    // Error handling (basic example)
    // if (response.error != null) {
    //   throw Exception("Failed to fetch companies: ${response.error!.message}");
    // }

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
      return _fetchCompanies(); // Refetch list
    });
  }

  Future<void> updateCompany(int id, String newName) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await supabase.from('companies').update({'name': newName}).eq('id', id);
      return _fetchCompanies(); // Refetch list
    });
  }

  Future<void> deleteCompany(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await supabase.from('companies').delete().eq('id', id);
      return _fetchCompanies(); // Refetch list
    });
  }

  Future<void> addProject(int companyId, String name) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await supabase.from('projects').insert({'name': name, 'company_id': companyId});
      return _fetchCompanies(); // Refetch to update nested projects
    });
  }

  Future<void> deleteProject(int projectId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await supabase.from('projects').delete().eq('id', projectId);
      return _fetchCompanies(); // Refetch to update nested projects
    });
  }

  Future<void> updateProject(int projectId, String newName) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await supabase.from('projects').update({'name': newName}).eq('id', projectId);
      return _fetchCompanies(); // Refetch to update nested projects
    });
  }
}

// == Tenant Users & Roles Management ==
@riverpod
class TenantUsersNotifier extends _$TenantUsersNotifier {
  Future<List<TenantUser>> _fetchUsers() async {
    final tenantId = ref.read(_tenantId);
    if (tenantId == null) throw Exception("User not authenticated or tenant ID missing");

    // Fetch users with roles for the current tenant.
    // Assumes you might want user details like email from auth.users
    final response = await supabase
        .from('user_tenant_roles')
        .select(
          'user_id, role, user_profiles ( email, full_name, id )',
        ) // Adjust 'users ( email )' based on your actual auth schema/profile table
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
            .update({'role': newRole.name}) // Use the string value of the enum
            .eq('user_id', userId)
            .eq('tenant_id', tenantId);
        return _fetchUsers(); // Refetch list
      },
      (err) {
        if (err is PostgrestException) {
          // Handle specific Postgrest exceptions if needed
          print("Postgrest error: ${err.message}");
          return true;
        } else {
          // Handle other exceptions
          print("Error updating user role: $err");
          return true;
        }
      },
    );
  }

  Future<void> grantCompanyAccess(String userId, int companyId) async {
    await supabase.from('user_company_access').insert({'user_id': userId, 'company_id': companyId});
    // Invalidate relevant providers to refetch data after modification
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

// == User Access Management (Company & Project) ==

// Provider to fetch users who have access to a specific company
@riverpod
Future<List<UserCompanyAccess>> companyAccess(Ref ref, int companyId) async {
  final response = await supabase.from('user_company_access').select().eq('company_id', companyId);

  final data = response as List<dynamic>;
  return data.map((json) => UserCompanyAccess.fromJson(json as Map<String, dynamic>)).toList();
}

// Provider to fetch users who have access to a specific project
@riverpod
Future<List<UserProjectAccess>> projectAccess(Ref ref, int projectId) async {
  final response = await supabase.from('user_project_access').select().eq('project_id', projectId);

  final data = response as List<dynamic>;
  return data.map((json) => UserProjectAccess.fromJson(json as Map<String, dynamic>)).toList();
}
