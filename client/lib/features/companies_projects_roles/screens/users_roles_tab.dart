// tenant_admin_page.dart (New File)

import 'package:client/features/companies_projects_roles/models/user.dart';
import 'package:client/features/companies_projects_roles/providers/tenant_management_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UsersRolesTab extends ConsumerWidget {
  const UsersRolesTab({super.key});

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
                title: Text(user.email), // Display email or ID
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
                  ],
                ),
              );
            },
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error loading users: $error')),
    );
  }
}
