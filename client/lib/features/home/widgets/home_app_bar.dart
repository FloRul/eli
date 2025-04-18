﻿import 'package:client/features/auth/providers/auth_provider.dart';
import 'package:client/features/home/providers/companies_provider.dart';
import 'package:client/features/home/providers/projects_provider.dart';
import 'package:client/features/home/widgets/home_search_widget.dart';
import 'package:client/features/home/widgets/pill_dropdown.dart';
import 'package:client/features/home/widgets/user_info.dart';
import 'package:client/theme/providers.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeAppBar extends ConsumerWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companyListAsync = ref.watch(companiesProvider);
    final projectListAsync = ref.watch(projectsProvider);
    final selectedCompanyId = ref.watch(currentCompanyNotifierProvider);
    final selectedProjectId = ref.watch(currentProjectNotifierProvider);

    // Get access to the notifiers to update the state
    final companyNotifier = ref.read(currentCompanyNotifierProvider.notifier);
    final projectNotifier = ref.read(currentProjectNotifierProvider.notifier);
    final currentThemeMode = ref.watch(themeModeNotifProvider);
    return AppBar(
      centerTitle: true,
      title: Row(
        spacing: 8,
        children: [
          Expanded(
            child: PillDropdownWidget(
              itemsProvider: companyListAsync,
              currentSelectedId: selectedCompanyId,
              onSelected: (id) => companyNotifier.setCompany(id),
              hintText: 'Select a Company',
              noItemsText: 'No companies found',
              addNoneOption: false,
            ),
          ),
          Expanded(
            child: PillDropdownWidget(
              itemsProvider: projectListAsync,
              currentSelectedId: selectedProjectId,
              onSelected: (id) => projectNotifier.setProject(id),
              hintText: 'Select a Project',
              noItemsText: 'No projects found',
              addNoneOption: false, // Allow clearing the selection
            ),
          ),
          Expanded(child: HomeSearchWidget()),
        ],
      ),
      actions: [
        UserInfo(),
        SizedBox(width: 8),
        IconButton(
          icon: Icon(currentThemeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
          tooltip: 'Toggle Theme',
          onPressed: () {
            ref
                .read(themeModeNotifProvider.notifier)
                .setThemeMode(currentThemeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
          },
        ),
        SizedBox(width: 8),

        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Logout',
          onPressed: () async {
            await ref.read(authProvider.notifier).logout();
          },
        ),
        SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.bug_report),
          tooltip: 'Report an issue or suggestion',
          onPressed: () async {
            BetterFeedback.of(context).show((feedback) async {
              // REQUIRED - https://github.com/ueman/feedback/issues/169
              await Future.delayed(const Duration(seconds: 2));
              // TODO: Handle the feedback submission
              // Handle the feedback submission
              // You can send the feedback to your server or handle it as needed
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Feedback submitted')));
            });
          },
        ),
        SizedBox(width: 8),
      ],
    );
  }
}
