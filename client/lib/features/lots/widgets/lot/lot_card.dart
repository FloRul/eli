import 'package:client/features/lots/models/lot.dart';
import 'package:client/features/lots/models/lot_item.dart';
import 'package:client/features/lots/widgets/deliverable/deliverable_section.dart';
import 'package:client/features/lots/widgets/lot/lot_form.dart';
import 'package:client/features/lots/widgets/lot/empty_lot_state.dart';
import 'package:client/features/lots/widgets/lot/lot_header.dart';
import 'package:client/features/lots/widgets/lot_item/lot_item_card.dart';
import 'package:client/features/lots/widgets/common/utils.dart';
import 'package:client/features/lots/widgets/lot_item/section_title.dart'; // Import SectionTitle
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LotCard extends ConsumerStatefulWidget {
  final Lot lot;

  const LotCard({super.key, required this.lot});

  @override
  ConsumerState<LotCard> createState() => _LotCardState();
}

class _LotCardState extends ConsumerState<LotCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final overallStatus = widget.lot.overallStatus;
    final sortedItems = List<LotItem>.from(widget.lot.items);
    // Sort items by priority of status
    sortedItems.sortByCompare((item) => item.status, (s1, s2) => s2.priority - s1.priority);
    final hasItems = widget.lot.items.isNotEmpty;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12), // Add margin between LotCards
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: getStatusColor(overallStatus).withAlpha(150), width: 1.5), // Adjusted alpha
      ),
      child: Column(
        children: [
          // Header row with toggle
          InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)), // Match card radius
            canRequestFocus: false,
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
                FocusScope.of(context).unfocus();
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                // Using Row instead of SpacedRow for manual spacing control
                children: [
                  Expanded(child: LotHeader(lot: widget.lot)),
                  const SizedBox(width: 8), // Add space before buttons
                  // Edit Lot Button
                  IconButton(
                    visualDensity: VisualDensity.compact, // Make buttons smaller
                    tooltip: 'Edit Lot Details',
                    icon: const Icon(Icons.edit_outlined, size: 20), // Smaller icon
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                        ),
                        builder: (BuildContext context) {
                          return LotForm(initialLot: widget.lot);
                        },
                      );
                    },
                  ),
                  // Expansion icon
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: _isExpanded ? 'Collapse' : 'Expand',
                    icon: Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      size: 24,
                    ), // Slightly larger expand icon
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.topCenter,
            child:
                _isExpanded
                    ? Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8), // Adjusted padding
                      child: Column(
                        spacing: 8,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DeliverablesSection(
                            // Use the new section widget
                            deliverables: widget.lot.deliverables,
                            parentLotId: widget.lot.id,
                          ),

                          // Section for Items
                          const SectionTitle(title: 'Items', icon: Icons.inventory_2_outlined),
                          if (!hasItems)
                            const EmptyLotState() // Display if no items
                          else
                            ListView.builder(
                              itemCount: sortedItems.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => LotItemCard(item: sortedItems[index]),
                            ),

                          // Section for Deliverables
                        ],
                      ),
                    )
                    : const SizedBox.shrink(), // Collapsed state
          ),
        ],
      ),
    );
  }
}
