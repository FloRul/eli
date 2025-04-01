import 'package:client/features/lots/models/lot.dart';
import 'package:client/features/lots/widgets/lot/empty_lot_state.dart';
import 'package:client/features/lots/widgets/lot/lot_header.dart';
import 'package:client/features/lots/widgets/lot_item/lot_item_card.dart';
import 'package:client/features/lots/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LotCard extends ConsumerStatefulWidget {
  final Lot lot;
  final bool isFirst;
  final bool isLast;

  const LotCard({super.key, required this.lot, this.isFirst = false, this.isLast = false});

  @override
  ConsumerState<LotCard> createState() => _LotCardState();
}

class _LotCardState extends ConsumerState<LotCard> {
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
