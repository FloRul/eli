import 'package:client/features/lots/models/lot.dart';
import 'package:client/features/lots/models/enums.dart';
import 'package:client/features/lots/widgets/lot_item_card.dart';
import 'package:client/features/lots/widgets/utils.dart';
import 'package:flutter/material.dart';

class LotExpansionCard extends StatefulWidget {
  final Lot lot;
  final bool isFirst;
  final bool isLast;

  const LotExpansionCard({
    super.key, 
    required this.lot, 
    this.isFirst = false, 
    this.isLast = false
  });

  @override
  State<LotExpansionCard> createState() => _LotExpansionCardState();
}

class _LotExpansionCardState extends State<LotExpansionCard> {
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
                  Expanded(
                    child: LotHeader(lot: widget.lot),
                  ),
                  
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
            child: _isExpanded 
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
        // Status dot
        StatusDot(status: overallStatus),
        const SizedBox(width: 12),
        
        // Title
        Expanded(
          child: TitleDisplay(lot: lot),
        ),
        
        // Provider pill
        ProviderPill(provider: lot.provider),
        
        const SizedBox(width: 12),
        
        // Delivery dates
        DeliveryInfo(dates: lot.formattedPlannedDeliveryDates),
        
        const SizedBox(width: 16),
        
        // Status badge
        StatusBadge(status: overallStatus),
      ],
    );
  }
}

/// Widget that displays the provider information in a pill
class ProviderPill extends StatelessWidget {
  final String provider;
  
  const ProviderPill({super.key, required this.provider});
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
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
            provider,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.secondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Widget that displays a colored status dot
class StatusDot extends StatelessWidget {
  final Status status;
  
  const StatusDot({super.key, required this.status});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: getStatusColor(status), 
        shape: BoxShape.circle
      ),
    );
  }
}

/// Widget that displays the title
class TitleDisplay extends StatelessWidget {
  final Lot lot;
  
  const TitleDisplay({super.key, required this.lot});
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Only show the title, provider is now displayed separately
    return Text(
      lot.displayTitle,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
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
        Text(
          dates,
          style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

/// Widget that displays a status badge
class StatusBadge extends StatelessWidget {
  final Status status;
  
  const StatusBadge({super.key, required this.status});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: getStatusColor(status).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: getStatusColor(status).withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        status.displayName.toUpperCase(),
        style: TextStyle(
          color: getStatusColor(status), 
          fontSize: 10, 
          fontWeight: FontWeight.bold
        ),
      ),
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
          Icon(
            Icons.inventory_2_outlined,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 16),
          Text(
            'No items in this lot',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant
            ),
          ),
        ],
      ),
    );
  }
}