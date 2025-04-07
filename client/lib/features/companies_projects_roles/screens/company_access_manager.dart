// tenant_admin_page.dart (New File)

import 'package:client/features/companies_projects_roles/models/user.dart';
import 'package:client/features/companies_projects_roles/providers/tenant_management_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CompanyAccessManager extends HookConsumerWidget {
  final int companyId;
  const CompanyAccessManager({super.key, required this.companyId});

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
                    orElse: () => TenantUser(userId: access.userId, role: Role.viewer, fullName: null, email: ''),
                  ); // Basic fallback
                  return ListTile(
                    dense: true,
                    title: Text(user?.email ?? access.userId), // Display email or ID
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.red, size: 20),
                      tooltip: 'Revoke Access',
                      onPressed:
                          () => ref
                              .read(tenantUsersNotifierProvider.notifier)
                              .revokeCompanyAccess(access.userId, companyId),
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
                            .map((user) => DropdownMenuItem(value: user.userId, child: Text(user.email)))
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
                            ref
                                .read(tenantUsersNotifierProvider.notifier)
                                .grantCompanyAccess(selectedUser.value!, companyId);
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
