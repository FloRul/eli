import 'package:client/features/lots/models/lot.dart';
import 'package:client/features/lots/models/enums.dart';
import 'package:client/features/lots/widgets/lot_item_card.dart';
import 'package:client/features/lots/widgets/utils.dart';
import 'package:flutter/material.dart';

class LotExpansionCard extends StatefulWidget {
  final Lot lot;
  final bool isFirst;
  final bool isLast;

  const LotExpansionCard({super.key, required this.lot, this.isFirst = false, this.isLast = false});

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
                  _buildHeaderContent(colorScheme, theme),
                  
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
                        _buildEmptyItemsState(context)
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
  
  /// Builds the main content of the header row
  Widget _buildHeaderContent(ColorScheme colorScheme, ThemeData theme) {
    final overallStatus = widget.lot.overallStatus;
    
    return Expanded(
      child: Row(
        children: [
          _buildStatusDot(overallStatus),
          const SizedBox(width: 12),
          
          _buildTitleAndProvider(widget.lot, theme, colorScheme),
          
          _buildDeliveryDates(widget.lot, colorScheme, theme),
          
          const SizedBox(width: 16),
          
          _buildStatusBadge(overallStatus),
        ],
      ),
    );
  }
  
  /// Builds the status indicator dot
  Widget _buildStatusDot(Status status) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: getStatusColor(status), 
        shape: BoxShape.circle
      ),
    );
  }
  
  /// Builds the title and provider section (left side)
  Widget _buildTitleAndProvider(Lot lot, ThemeData theme, ColorScheme colorScheme) {
    return Expanded(
      child: Row(
        children: [
          // Title
          Flexible(
            child: Text(
              lot.displayTitle,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Provider info
          Icon(Icons.business, size: 14, color: colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            lot.provider,
            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
  
  /// Builds the delivery date section (middle)
  Widget _buildDeliveryDates(Lot lot, ColorScheme colorScheme, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.calendar_month, size: 16, color: colorScheme.primary),
        const SizedBox(width: 4),
        Text(
          lot.formattedPlannedDeliveryDates,
          style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
  
  /// Builds the status badge (right side)
  Widget _buildStatusBadge(Status status) {
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

  /// Builds the empty state when there are no items
  Widget _buildEmptyItemsState(BuildContext context) {
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