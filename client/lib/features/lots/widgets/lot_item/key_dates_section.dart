// Key Dates Section
import 'package:client/features/lots/models/lot_item.dart';
import 'package:client/features/lots/models/timeline_entry.dart';
import 'package:client/features/lots/widgets/lot_item/date_timeline.dart';
import 'package:flutter/material.dart';

class KeyDatesSection extends StatelessWidget {
  final LotItem item;
  const KeyDatesSection({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DateTimeline(
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
        ),
      ],
    );
  }
}
