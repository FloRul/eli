import 'package:client/features/lots/models/lot.dart';
import 'package:client/features/lots/models/lot_item.dart';
import 'package:client/features/lots/widgets/deliverable/deliverable_section.dart';
import 'package:client/features/lots/widgets/lot/lot_form.dart';
import 'package:client/features/lots/widgets/lot/empty_lot_state.dart';
import 'package:client/features/lots/widgets/lot/lot_header.dart';
import 'package:client/features/lots/widgets/lot_item/lot_item_card.dart';
import 'package:client/features/lots/widgets/common/utils.dart';
import 'package:client/features/lots/widgets/lot_item/section_title.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Changed to ConsumerWidget as ExpansionTile manages its own state
class LotCard extends ConsumerWidget {
  final Lot lot;
  final int projectId;

  const LotCard({super.key, required this.lot, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Added WidgetRef ref
    final overallStatus = lot.overallStatus;
    final sortedItems = List<LotItem>.from(lot.items);
    // Sort items by priority of status
    sortedItems.sortByCompare((item) => item.status, (s1, s2) => s2.priority - s1.priority);
    final hasItems = lot.items.isNotEmpty;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12), // Keep margin between LotCards
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: getStatusColor(overallStatus).withAlpha(150), width: 1.5), // Keep status border
      ),
      // Use ExpansionTile directly inside the Card
      child: ExpansionTile(
        // Maintain header padding
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        // Maintain content padding
        childrenPadding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16,
          top: 8,
        ), // Adjusted top padding slightly
        // Remove default dividers/borders for seamless look within the Card
        shape: const Border(),
        collapsedShape: const Border(),
        // Use Card's background color
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        // Maintain the focus clearing behavior
        onExpansionChanged: (isExpanding) {
          FocusScope.of(context).unfocus();
        },
        // Keep the header content (LotHeader + Edit Button)
        title: Row(
          children: [
            Expanded(child: LotHeader(lot: lot, projectId: projectId)),
            const SizedBox(width: 8), // Space before button
            // Edit Lot Button - needs to be wrapped? Often IconButton handles tap itself. Test this.
            IconButton(
              visualDensity: VisualDensity.compact,
              tooltip: 'Edit Lot Details',
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.0))),
                  builder: (BuildContext context) {
                    return LotForm(initialLot: lot);
                  },
                );
              },
            ),
            // Note: ExpansionTile adds its own trailing icon by default (usually a dropdown arrow)
            // If you need to hide it, uncomment the next line:
            // trailing: const SizedBox.shrink(),
          ],
        ),
        // Define the expandable content
        children: <Widget>[
          // Explicit type recommended
          Column(
            // Replicate layout using standard Column properties
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DeliverablesSection(deliverables: lot.deliverables, parentLotId: lot.id),

              const SizedBox(height: 12), // Add spacing before Items section title
              // Section for Items
              const SectionTitle(title: 'Items', icon: Icons.inventory_2_outlined),
              const SizedBox(height: 8), // Add spacing after title

              if (!hasItems)
                const EmptyLotState() // Display if no items
              else
                ListView.builder(
                  itemCount: sortedItems.length,
                  shrinkWrap: true, // Important for ListView inside Column/ExpansionTile
                  physics: const NeverScrollableScrollPhysics(), // Important for ListView inside Column/ExpansionTile
                  itemBuilder: (context, index) {
                    final item = sortedItems[index];
                    return LotItemCard(item: item, projectId: projectId);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
