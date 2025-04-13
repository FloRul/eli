import 'package:client/features/lots/models/lot.dart';
import 'package:client/features/lots/providers/lot_provider.dart';
import 'package:client/features/lots/widgets/lot/assigned_expeditor.dart';
import 'package:client/features/lots/widgets/lot/delivery_info.dart';
import 'package:client/features/lots/widgets/lot/provider_pill.dart';
import 'package:client/features/lots/widgets/common/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget that displays the header content for a lot
class LotHeader extends ConsumerWidget {
  final Lot lot;
  final int projectId;

  const LotHeader({super.key, required this.lot, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overallStatus = lot.overallStatus;
    final theme = Theme.of(context);
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      direction: Axis.horizontal,

      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 8,
      children: [
        Row(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          children: [
            StatusDropdown(
              currentStatus: overallStatus,
              onStatusChanged: (value) async {
                // display confirmation dialog
                final shouldUpdate = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Change Lot Status'),
                      content: const Text('Are you sure you want to change the status of the whole lot?'),
                      actions: [
                        OutlinedButton(
                          style: ButtonStyle(foregroundColor: WidgetStateProperty.all<Color>(theme.colorScheme.error)),
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Confirm')),
                      ],
                    );
                  },
                );
                if (shouldUpdate == true) {
                  // Update the lot status
                  await ref.read(lotsProvider(projectId).notifier).updateAllLotItemsStatus(lot.id, value);
                }
              },
            ),
            Text(
              lot.number,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Flexible(
              child: Text(
                lot.title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        Row(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          children: [
            IntrinsicWidth(
              child: AssignedExpeditor(
                assignedToFullName: lot.assignedToFullName,
                assignedToEmail: lot.assignedToEmail,
              ),
            ),
            ProviderPill(provider: lot.provider),
            Flexible(child: DeliveryInfo(dates: lot.formattedFirstAndLastPlannedDeliveryDates)),
          ],
        ),
      ],
    );
  }
}
