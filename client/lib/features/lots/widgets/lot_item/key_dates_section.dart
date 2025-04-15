// Key Dates Section
import 'package:client/features/lots/models/lot_item.dart';
import 'package:client/features/lots/models/timeline_entry.dart';
import 'package:client/features/lots/widgets/lot_item/date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KeyDatesSection extends StatelessWidget {
  final LotItem item;
  const KeyDatesSection({super.key, required this.item});

  // Date formatting can live here or be passed in/imported
  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM d, yyyy').format(date); // Use 'yyyy' for clarity
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Optional: SectionTitle can be added here if desired
        DateTimeline(
          onDateUpdate: (entry, newDate) {},
          primaryColor: Theme.of(context).colorScheme.primary,
          entries: [
            TimelineEntry(
              label: 'End Manufacturing',
              date: _formatDate(item.endManufacturingDate),
              isPassed: item.endManufacturingDate != null && item.endManufacturingDate!.isBefore(now),
            ),
            TimelineEntry(
              label: 'Ready to Ship',
              date: _formatDate(item.readyToShipDate),
              isPassed: item.readyToShipDate != null && item.readyToShipDate!.isBefore(now),
            ),
            TimelineEntry(
              label: 'Planned Delivery',
              date: _formatDate(item.plannedDeliveryDate),
              isHighlighted: true,
              isPassed: item.plannedDeliveryDate != null && item.plannedDeliveryDate!.isBefore(now),
            ),
            TimelineEntry(
              label: 'Required On Site',
              date: _formatDate(item.requiredOnSiteDate),
              isPassed: item.requiredOnSiteDate != null && item.requiredOnSiteDate!.isBefore(now),
            ),
          ],
        ),
      ],
    );
  }
}
