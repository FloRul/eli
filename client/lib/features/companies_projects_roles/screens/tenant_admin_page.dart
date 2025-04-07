// tenant_admin_page.dart (New File)

import 'package:client/features/companies_projects_roles/screens/company_access_manager.dart';
import 'package:client/features/companies_projects_roles/screens/users_roles_tab.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:client/features/companies_projects_roles/models/company.dart';
import 'package:client/features/companies_projects_roles/models/project.dart';
import 'package:client/features/companies_projects_roles/providers/tenant_management_provider.dart';

class TenantAdminPage extends StatelessWidget {
  const TenantAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two main tabs: Companies/Projects and Users/Roles
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tenant Administration'),
          bottom: const TabBar(tabs: [Tab(text: 'Companies & Projects'), Tab(text: 'Users & Roles')]),
        ),
        body: const TabBarView(children: [_CompaniesProjectsTab(), UsersRolesTab()]),
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
              child: CompanyAccessManager(companyId: company.id),
            ),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
          ),
    );
  }
}
