import 'package:client/features/lots/models/lot.dart';
import 'package:client/features/lots/models/enums.dart';
import 'package:client/features/lots/providers/lot_provider.dart';
import 'package:client/features/lots/widgets/editable_field.dart';
import 'package:client/features/lots/widgets/editable_field/editable_field_type.dart';
import 'package:client/features/lots/widgets/lot_item_card.dart';
import 'package:client/features/lots/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LotExpansionCard extends ConsumerStatefulWidget {
  final Lot lot;
  final bool isFirst;
  final bool isLast;

  const LotExpansionCard({super.key, required this.lot, this.isFirst = false, this.isLast = false});

  @override
  ConsumerState<LotExpansionCard> createState() => _LotExpansionCardState();
}

class _LotExpansionCardState extends ConsumerState<LotExpansionCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final overallStatus = widget.lot.overallStatus;

    return Card(
      margin: EdgeInsets.only(bottom: widget.isLast ? 0 : 12, top: widget.isFirst ? 0 : 0),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: getStatusColor(overallStatus).withValues(alpha: 0.6), width: 1.5),
      ),
      child: Column(
        children: [
          // Header row with toggle
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(child: LotHeader(lot: widget.lot)),

                  // Expansion icon
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child:
                _isExpanded
                    ? Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.lot.items.isEmpty)
                            const EmptyLotState()
                          else
                            ...widget.lot.items.map((item) => LotItemCard(item: item)),
                        ],
                      ),
                    )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

/// Widget that displays the header content for a lot
class LotHeader extends StatelessWidget {
  final Lot lot;

  const LotHeader({super.key, required this.lot});

  @override
  Widget build(BuildContext context) {
    final overallStatus = lot.overallStatus;

    return Row(
      children: [
        StatusBadge(status: overallStatus),
        const SizedBox(width: 12),
        Expanded(child: TitleDisplay(lot: lot)),
        const SizedBox(width: 12),
        ProviderPill(provider: lot.provider, lotId: lot.id),
        const SizedBox(width: 12),
        DeliveryInfo(dates: lot.formattedPlannedDeliveryDates),
      ],
    );
  }
}

/// Widget that displays the provider information in a pill
class ProviderPill extends ConsumerWidget {
  final String provider;
  final int lotId;

  const ProviderPill({super.key, required this.provider, required this.lotId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return EditableField<String>(
      value: provider,
      fieldType: EditableFieldType.text,
      label: 'Provider',
      displayBuilder: (value) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.secondary.withValues(alpha: 0.3), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.business, size: 12, color: colorScheme.secondary),
            const SizedBox(width: 4),
            Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500, 
                color: colorScheme.secondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      onUpdate: (newValue) async {
        await ref.read(lotsProvider.notifier).updateLot(lotId, {'provider': newValue});
      },
    );
  }
}

/// Widget that displays the title
class TitleDisplay extends ConsumerWidget {
  final Lot lot;

  const TitleDisplay({super.key, required this.lot});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        // Title field (editable)
        Expanded(
          child: EditableField<String>(
            value: lot.title,
            fieldType: EditableFieldType.text,
            label: 'Title',
            displayBuilder: (value) => Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onUpdate: (newValue) async {
              await ref.read(lotsProvider.notifier).updateLot(lot.id, {'title': newValue});
            },
          ),
        ),
        
        // Lot number (editable)
        const SizedBox(width: 8),
        EditableField<String>(
          value: lot.number,
          fieldType: EditableFieldType.text,
          label: 'Lot Number',
          displayBuilder: (value) => Text(
            '#$value',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          onUpdate: (newValue) async {
            await ref.read(lotsProvider.notifier).updateLot(lot.id, {'number': newValue});
          },
        ),
      ],
    );
  }
}

/// Widget that displays delivery date information
class DeliveryInfo extends StatelessWidget {
  final String dates;

  const DeliveryInfo({super.key, required this.dates});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.calendar_month, size: 16, color: colorScheme.primary),
        const SizedBox(width: 4),
        Text(dates, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
      ],
    );
  }
}

/// Widget that displays a status badge
class StatusBadge extends ConsumerWidget {
  final Status status;
  final int? itemId; // If null, this is a lot status badge (read-only)

  const StatusBadge({super.key, required this.status, this.itemId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If itemId is not provided, it's a lot status badge (computed from items), so not editable
    if (itemId == null) {
      return _buildStatusBadgeDisplay(status);
    }
    
    // Otherwise, it's an item status badge and should be editable
    return EditableField<Status>(
      value: status,
      fieldType: EditableFieldType.status,
      label: 'Status',
      displayBuilder: (value) => _buildStatusBadgeDisplay(value),
      onUpdate: (newValue) async {
        await ref.read(lotsProvider.notifier).updateLotItem(
          itemId!, 
          {'status': newValue.name},
        );
      },
    );
  }
  
  Widget _buildStatusBadgeDisplay(Status status) {
    return Builder(
      builder: (context) {
        final statusColor = getStatusColor(status);
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1),
          ),
          child: Text(
            status.displayName.toUpperCase(),
            style: TextStyle(
              color: statusColor, 
              fontSize: 10, 
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }
    );
  }
}

/// Widget that displays a message when there are no items in a lot
class EmptyLotState extends StatelessWidget {
  const EmptyLotState({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.inventory_2_outlined, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
          const SizedBox(width: 16),
          Text(
            'No items in this lot',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
