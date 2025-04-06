// tenant_admin_page.dart (New File)

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Import your models and providers (adjust paths as needed)
import 'package:client/features/companies_projects_roles/models/company.dart';
import 'package:client/features/companies_projects_roles/models/project.dart';
import 'package:client/features/companies_projects_roles/models/user.dart';
import 'package:client/features/companies_projects_roles/providers/tenant_management_provider.dart';

class TenantAdminPage extends StatelessWidget {
  const TenantAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Using DefaultTabController to manage tabs
    return DefaultTabController(
      length: 2, // Two main tabs: Companies/Projects and Users/Roles
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tenant Administration'),
          bottom: const TabBar(tabs: [Tab(text: 'Companies & Projects'), Tab(text: 'Users & Roles')]),
        ),
        body: const TabBarView(children: [_CompaniesProjectsTab(), _UsersRolesTab()]),
      ),
    );
  }
}

// --- Tab 1: Companies & Projects ---
class _CompaniesProjectsTab extends HookConsumerWidget {
  const _CompaniesProjectsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companiesAsync = ref.watch(companiesNotifierProvider);

    return companiesAsync.when(
      data:
          (companies) => Column(
            children: [
              Expanded(
                // Using ExpansionPanelList for a nested view
                child: ListView(
                  children: [
                    ExpansionPanelList.radio(
                      children:
                          companies
                              .map(
                                (company) => ExpansionPanelRadio(
                                  value: company.id, // Unique value for each panel
                                  headerBuilder:
                                      (context, isExpanded) => ListTile(
                                        title: Text(company.name),
                                        // Add Edit/Delete buttons for the Company
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit, size: 20),
                                              tooltip: 'Edit Company',
                                              onPressed: () => _showEditCompanyDialog(context, ref, company),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                                              tooltip: 'Delete Company',
                                              onPressed: () => _confirmDeleteCompany(context, ref, company),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.person_add_alt_1, size: 20),
                                              tooltip: 'Manage Company Access',
                                              onPressed: () => _showCompanyAccessDialog(context, ref, company),
                                            ),
                                          ],
                                        ),
                                      ),
                                  body: Column(
                                    children: [
                                      ListTile(
                                        title: Text('Projects', style: Theme.of(context).textTheme.titleSmall),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.add_circle_outline),
                                          tooltip: 'Add Project',
                                          onPressed: () => _showAddProjectDialog(context, ref, company.id),
                                        ),
                                      ),
                                      if (company.projects.isEmpty)
                                        const ListTile(dense: true, title: Text('No projects yet.'))
                                      else
                                        ...company.projects.map(
                                          (project) => ListTile(
                                            dense: true,
                                            title: Text(project.name),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.edit, size: 18),
                                                  tooltip: 'Edit Project',
                                                  onPressed: () => _showEditProjectDialog(context, ref, project),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                                  tooltip: 'Delete Project',
                                                  onPressed: () => _confirmDeleteProject(context, ref, project),
                                                ),
                                                // Potentially add project-specific access management later
                                              ],
                                            ),
                                          ),
                                        ),
                                      const Divider(),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
              // Button to add a new Company
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Company'),
                  onPressed: () => _showAddCompanyDialog(context, ref),
                ),
              ),
            ],
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error loading companies: $error')),
    );
  }

  // --- Dialogs for Company Management ---
  void _showAddCompanyDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Company'),
            content: TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Company Name'),
              autofocus: true,
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    ref.read(companiesNotifierProvider.notifier).addCompany(nameController.text);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  void _showEditCompanyDialog(BuildContext context, WidgetRef ref, Company company) {
    final nameController = TextEditingController(text: company.name);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Edit Company: ${company.name}'),
            content: TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Company Name'),
              autofocus: true,
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty && nameController.text != company.name) {
                    ref.read(companiesNotifierProvider.notifier).updateCompany(company.id, nameController.text);
                  }
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void _confirmDeleteCompany(BuildContext context, WidgetRef ref, Company company) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: Text(
              'Are you sure you want to delete company "${company.name}" and all its projects? This cannot be undone.',
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  ref.read(companiesNotifierProvider.notifier).deleteCompany(company.id);
                  Navigator.pop(context);
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  // --- Dialogs for Project Management ---
  void _showAddProjectDialog(BuildContext context, WidgetRef ref, int companyId) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Project'),
            content: TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Project Name'),
              autofocus: true,
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    // Use the extension method or call the notifier method directly
                    ref.read(companiesNotifierProvider.notifier).addProject(companyId, nameController.text);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  void _showEditProjectDialog(BuildContext context, WidgetRef ref, Project project) {
    final nameController = TextEditingController(text: project.name);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Edit Project: ${project.name}'),
            content: TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Project Name'),
              autofocus: true,
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty && nameController.text != project.name) {
                    ref.read(companiesNotifierProvider.notifier).updateProject(project.id, nameController.text);
                  }
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void _confirmDeleteProject(BuildContext context, WidgetRef ref, Project project) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: Text('Are you sure you want to delete project "${project.name}"? This cannot be undone.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  ref.read(companiesNotifierProvider.notifier).deleteProject(project.id);
                  Navigator.pop(context);
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  // --- Dialog for Company Access Management ---
  void _showCompanyAccessDialog(BuildContext context, WidgetRef ref, Company company) {
    showDialog(
      context: context,
      // Use a large dialog, maybe stateful for managing selections
      builder:
          (context) => AlertDialog(
            title: Text("Manage Access: ${company.name}"),
            contentPadding: const EdgeInsets.all(16.0),
            // Content needs to be stateful or use hooks to manage selected user
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8, // Make dialog wider
              height: MediaQuery.of(context).size.height * 0.6, // Make dialog taller
              child: _CompanyAccessManager(companyId: company.id),
            ),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
          ),
    );
  }
}

// --- Helper Widget for Company Access Dialog ---
class _CompanyAccessManager extends HookConsumerWidget {
  final int companyId;
  const _CompanyAccessManager({required this.companyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessListAsync = ref.watch(companyAccessProvider(companyId));
    final tenantUsersAsync = ref.watch(tenantUsersNotifierProvider);
    final selectedUser = useState<String?>(null); // Hook to hold selected user ID

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Users with Access:", style: Theme.of(context).textTheme.titleMedium),
        Expanded(
          child: accessListAsync.when(
            data: (accessList) {
              if (accessList.isEmpty) return const Center(child: Text("No users have access yet."));
              // Fetch user details based on accessList user IDs for better display
              return ListView.builder(
                shrinkWrap: true,
                itemCount: accessList.length,
                itemBuilder: (context, index) {
                  final access = accessList[index];
                  // Find the user details from the tenant users list
                  final user = tenantUsersAsync.value?.firstWhere(
                    (u) => u.userId == access.userId,
                    orElse: () => TenantUser(userId: access.userId, role: Role.viewer, firstName: '', lastName: ''),
                  ); // Basic fallback
                  return ListTile(
                    dense: true,
                    title: Text(user?.email ?? access.userId), // Display email or ID
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.red, size: 20),
                      tooltip: 'Revoke Access',
                      onPressed:
                          () => ref.read(accessManagerProvider.notifier).revokeCompanyAccess(access.userId, companyId),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, st) => Text("Error loading access: $err"),
          ),
        ),
        const Divider(),
        Text("Grant Access:", style: Theme.of(context).textTheme.titleMedium),
        tenantUsersAsync.when(
          data: (allUsers) {
            // Filter users who DON'T already have access
            final usersWithAccessIds = accessListAsync.value?.map((a) => a.userId).toSet() ?? {};
            final availableUsers = allUsers.where((u) => !usersWithAccessIds.contains(u.userId)).toList();

            if (availableUsers.isEmpty) {
              return const Text("All current tenant users already have access or there are no other users.");
            }

            return Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedUser.value,
                    hint: const Text("Select User to Grant Access"),
                    items:
                        availableUsers
                            .map((user) => DropdownMenuItem(value: user.userId, child: Text(user.email ?? user.userId)))
                            .toList(),
                    onChanged: (value) {
                      selectedUser.value = value; // Update the selected user using the hook
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.green),
                  tooltip: 'Grant Access',
                  onPressed:
                      selectedUser.value == null
                          ? null
                          : () {
                            // Enable button only when a user is selected
                            ref.read(accessManagerProvider.notifier).grantCompanyAccess(selectedUser.value!, companyId);
                            selectedUser.value = null; // Reset dropdown after granting
                          },
                ),
              ],
            );
          },
          loading: () => const Text("Loading users..."),
          error: (err, st) => Text("Error loading users: $err"),
        ),
      ],
    );
  }
}

class _UsersRolesTab extends ConsumerWidget {
  const _UsersRolesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(tenantUsersNotifierProvider);

    return usersAsync.when(
      data:
          (users) => ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.email ?? user.userId), // Display email or ID
                subtitle: Text('Role: ${user.role.name}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dropdown to change role
                    DropdownButton<Role>(
                      value: user.role,
                      underline: Container(), // Hide default underline
                      icon: const Icon(Icons.edit, size: 20),
                      items:
                          Role.values
                              .map((Role role) => DropdownMenuItem<Role>(value: role, child: Text(role.name)))
                              .toList(),
                      onChanged: (newRole) {
                        if (newRole != null && newRole != user.role) {
                          ref.read(tenantUsersNotifierProvider.notifier).updateUserRole(user.userId, newRole);
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    // Button to remove user from tenant
                    IconButton(
                      icon: const Icon(Icons.person_remove, size: 20, color: Colors.red),
                      tooltip: 'Remove User from Tenant',
                      onPressed: () => _confirmRemoveUser(context, ref, user),
                    ),
                  ],
                ),
              );
            },
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error loading users: $error')),
    );
  }

  void _confirmRemoveUser(BuildContext context, WidgetRef ref, TenantUser user) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Remove User'),
            content: Text(
              'Are you sure you want to remove user "${user.email ?? user.userId}" from this tenant? Their company/project access will also be removed (due to DB cascade or manual cleanup).',
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  ref.read(tenantUsersNotifierProvider.notifier).removeUserFromTenant(user.userId);
                  Navigator.pop(context);
                },
                child: const Text('Remove'),
              ),
            ],
          ),
    );
  }
}
