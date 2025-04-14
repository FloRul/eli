import 'package:client/features/dashboard_v2/widgets/progress_overview.dart';
import 'package:client/features/dashboard_v2/widgets/stat_chip.dart';
import 'package:client/features/home/providers/projects_provider.dart';
import 'package:client/features/lots/providers/lot_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DashboardV2Page extends ConsumerWidget {
  const DashboardV2Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lots = ref.watch(lotsProvider(ref.read(currentProjectNotifierProvider)));
    return lots.when(
      data: (lots) {
        final purchasingProgress = lots.fold<double>(0, (sum, lot) => sum + lot.purchasingProgress) / lots.length;
        final engineeringProgress = lots.fold<double>(0, (sum, lot) => sum + lot.engineeringProgress) / lots.length;
        final manufacturingProgress = lots.fold<double>(0, (sum, lot) => sum + lot.manufacturingProgress) / lots.length;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Project Progress',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    ProgressOverview(
                      progresses: [
                        ('Purchasing', purchasingProgress / 100),
                        ('Engineering', engineeringProgress / 100),
                        ('Manufacturing', manufacturingProgress / 100),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      error: (error, stack) => Center(child: Text('Error loading lots: $error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
