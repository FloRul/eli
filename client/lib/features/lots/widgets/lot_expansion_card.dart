import 'package:client/features/lots/models/enums.dart';
import 'package:client/features/lots/models/lot.dart';
import 'package:client/features/lots/widgets/lot_item_card.dart';
import 'package:client/features/lots/widgets/utils.dart';
import 'package:flutter/material.dart';

class LotExpansionCard extends StatelessWidget {
  final Lot lot;
  final bool isFirst;
  final bool isLast;

  const LotExpansionCard({super.key, required this.lot, this.isFirst = false, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final overallStatus = lot.overallStatus;

    return Card(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12, top: isFirst ? 0 : 0),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: getStatusColor(overallStatus).withValues(alpha: 0.6), width: 1.5),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          title: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: getStatusColor(overallStatus), shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  lot.displayTitle,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 4, bottom: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.business, size: 14, color: colorScheme.primary),
                    const SizedBox(width: 4),
                    Text(
                      'Provider: ${lot.provider}',
                      style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_month, size: 14, color: colorScheme.primary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Delivery: ${lot.formattedPlannedDeliveryDates}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: getStatusColor(overallStatus).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: getStatusColor(overallStatus).withValues(alpha: 0.3), width: 1),
            ),
            child: Text(
              overallStatus.displayName.toUpperCase(),
              style: TextStyle(color: getStatusColor(overallStatus), fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          childrenPadding: const EdgeInsets.only(left: 12, right: 12, bottom: 16),
          children: [
            if (lot.items.isEmpty)
              _buildEmptyItemsState(context)
            else
              ...lot.items.map((item) => LotItemCard(item: item)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyItemsState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 16),
          Text(
            'No items in this lot',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
