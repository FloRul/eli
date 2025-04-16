// lot_item_card.dart

import 'package:client/features/lots/models/lot_item.dart';
import 'package:client/features/lots/models/timeline_entry.dart';
import 'package:client/features/lots/providers/lot_provider.dart';
import 'package:client/features/lots/widgets/lot_item/comment_section.dart';
import 'package:client/features/lots/widgets/lot_item/date_timeline.dart';
import 'package:client/features/lots/widgets/lot_item/header_section.dart';
import 'package:client/features/lots/widgets/lot_item/progress_section.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LotItemCard extends ConsumerWidget {
  final LotItem item;
  final int projectId;
  const LotItemCard({super.key, required this.item, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final hasComments = item.comments != null && item.comments!.isNotEmpty;

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderSection(item: item),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                final showCommentsInline = isWide && hasComments;

                // Instantiate section widgets
                final now = DateTime.now();
                final keyDatesSection = DateTimeline(
                  onDateUpdate: (entry, newDate) {},
                  entries: [
                    TimelineEntry(
                      label: 'End Manufacturing',
                      date: item.endManufacturingDate,
                      isPassed: item.endManufacturingDate != null && item.endManufacturingDate!.isBefore(now),
                    ),
                    TimelineEntry(
                      label: 'Ready to Ship',
                      date: item.readyToShipDate,
                      isPassed: item.readyToShipDate != null && item.readyToShipDate!.isBefore(now),
                    ),
                    TimelineEntry(
                      label: 'Planned Delivery',
                      date: item.plannedDeliveryDate,
                      isHighlighted: true,
                      isPassed: item.plannedDeliveryDate != null && item.plannedDeliveryDate!.isBefore(now),
                    ),
                    TimelineEntry(
                      label: 'Required On Site',
                      date: item.requiredOnSiteDate,
                      isPassed: item.requiredOnSiteDate != null && item.requiredOnSiteDate!.isBefore(now),
                    ),
                  ],
                );
                final progressSection = ProgressSection(item: item);
                final commentsSection =
                    hasComments
                        ? CommentsSection(
                          key: ValueKey(item.id),
                          comments: item.comments!,
                          onCommentsChanged: (comments) async {
                            await ref.read(lotsProvider(projectId).notifier).updateLotItem(item.id, {
                              'comments': comments,
                            });
                            if (context.mounted) {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(const SnackBar(content: Text('Comments updated')));
                            }
                          },
                        )
                        : null;

                // Arrange sections based on width
                if (isWide) {
                  return Row(
                    spacing: 12,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: keyDatesSection),
                      Expanded(child: progressSection),
                      if (showCommentsInline) ...[Expanded(child: commentsSection!)],
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      keyDatesSection,
                      const SizedBox(height: 16),
                      progressSection,
                      if (commentsSection != null) ...[const SizedBox(height: 16), commentsSection],
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
