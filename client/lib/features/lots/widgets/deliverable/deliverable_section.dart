import 'package:client/features/lots/models/deliverable.dart';
import 'package:client/features/lots/widgets/deliverable/deliverable_card.dart';
import 'package:client/features/lots/widgets/deliverable/deliverable_form.dart';
import 'package:client/features/lots/widgets/lot_item/section_title.dart'; // Reusing SectionTitle
import 'package:flutter/material.dart';

class DeliverablesSection extends StatelessWidget {
  final List<Deliverable> deliverables;
  final int parentLotId;

  const DeliverablesSection({super.key, required this.deliverables, required this.parentLotId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionTitle(title: 'Deliverables', icon: Icons.checklist_rtl),
            TextButton.icon(
              icon: const Icon(Icons.add_circle_outline, size: 18),
              label: const Text('Add'),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                  builder: (_) => DeliverableForm(parentLotId: parentLotId), // No initial deliverable for creation
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (deliverables.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Text(
                'No deliverables added yet.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ),
          )
        else
          ListView.builder(
            itemCount: deliverables.length,
            shrinkWrap: true, // Important within a Column
            physics: const NeverScrollableScrollPhysics(), // Disable scrolling in the list itself
            itemBuilder: (context, index) {
              return DeliverableCard(deliverable: deliverables[index], parentLotId: parentLotId);
            },
          ),
      ],
    );
  }
}
