import 'package:client/features/dashboard_v2/widgets/progress_overview.dart';
import 'package:client/features/home/providers/projects_provider.dart';
import 'package:client/features/lots/providers/lot_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DashboardV2Page extends ConsumerWidget {
  const DashboardV2Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lots = ref.watch(lotsProvider(ref.watch(currentProjectNotifierProvider)));
    return lots.when(
      data: (lots) {
        final purchasingProgress = lots.fold<double>(0, (sum, lot) => sum + lot.purchasingProgress) / lots.length;
        final engineeringProgress = lots.fold<double>(0, (sum, lot) => sum + lot.engineeringProgress) / lots.length;
        final manufacturingProgress = lots.fold<double>(0, (sum, lot) => sum + lot.manufacturingProgress) / lots.length;

        final pendingDeliveries = lots.fold<List<String>>(
          [],
          (list, lot) => list + lot.pendingItemsNameDeliveryThisWeek,
        );

        final itemsBehindSchedule = lots.fold<List<String>>([], (list, lot) => list + lot.itemsBehindSchedule);

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: [
                    Row(
                      spacing: 16,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          child: Text(
                            '${pendingDeliveries.length}',
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        Text(
                          'Pending Deliveries (This Week)',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.local_shipping_outlined, size: 48, color: Theme.of(context).colorScheme.secondary),
                      ],
                    ),
                    Row(
                      spacing: 16,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [...pendingDeliveries.map((item) => Text(item))],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 8,
                  children: [
                    Column(
                      spacing: 16,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          spacing: 16,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.warning_amber_rounded, size: 48, color: Theme.of(context).colorScheme.error),
                            Text(
                              'Problematic Lots',
                              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 16,
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.error,
                              child: Text(
                                '${itemsBehindSchedule.length}',
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            Text('Item(s) Behind Schedule', style: Theme.of(context).textTheme.bodyLarge!),
                          ],
                        ),
                        if (itemsBehindSchedule.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [...itemsBehindSchedule.map((item) => Text(item))],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 8,
                  children: [
                    Row(
                      spacing: 16,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.notification_important_outlined,
                          size: 48,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        Text(
                          'Important Reminders',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                        ),
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
