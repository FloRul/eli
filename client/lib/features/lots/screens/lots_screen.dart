import 'package:client/features/lots/models/enums.dart';
import 'package:client/features/lots/models/lot.dart';
import 'package:client/features/lots/models/lot_item.dart';
import 'package:client/features/lots/providers/lot_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// --- Main Screen Widget ---
class LotsScreen extends ConsumerWidget {
  const LotsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the state provided by the Lots notifier
    final lotsAsyncValue = ref.watch(lotsProvider); // Use the generated provider name

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lots Overview (Direct Provider)'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => ref.read(lotsProvider.notifier).refreshLots()),
        ],
      ),
      body: lotsAsyncValue.when(
        data:
            (lots) =>
                lots.isEmpty
                    ? const Center(child: Text('No lots found.'))
                    : ListView.builder(
                      itemCount: lots.length,
                      itemBuilder: (context, index) {
                        // Pass the Lot object directly
                        return LotExpansionTile(lot: lots[index]);
                      },
                    ),
        error: (error, stackTrace) => Center(child: Text('Error loading lots: ${error.toString()}')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class LotExpansionTile extends StatelessWidget {
  // Now takes a Lot object directly
  final Lot lot;

  const LotExpansionTile({super.key, required this.lot});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Use computed properties directly from the Lot model
    final overallStatus = lot.overallStatus;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          lot.displayTitle, // Use computed title from Lot model
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Provider: ${lot.provider}'), // Direct access
            Text(
              'Planned Delivery: ${lot.formattedPlannedDeliveryDates}', // Use computed formatted dates
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Chip(
          label: Text(overallStatus.name.toUpperCase()),
          backgroundColor: _getStatusColor(overallStatus),
          labelStyle: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        ),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        // Iterate over lot.items directly
        children:
            lot.items.isEmpty
                ? [const ListTile(title: Text('No items in this lot.'))]
                : lot.items.map((item) => LotItemCard(item: item)).toList(),
      ),
    );
  }

  // Helper to get status color (same as before)
  Color _getStatusColor(Status status) {
    switch (status) {
      case Status.critical:
        return Colors.red.shade700;
      case Status.closefollowuprequired:
        return Colors.orange.shade700;
      case Status.ongoing:
        return Colors.blue.shade700;
      case Status.onhold:
        return Colors.grey.shade600;
      case Status.completed:
        return Colors.green.shade700;
      case Status.unknown:
        return Colors.black;
    }
  }
}

// --- Custom Card for a Single Lot Item ---
// NO CHANGES NEEDED HERE, it already takes LotItem
class LotItemCard extends StatelessWidget {
  final LotItem item;
  const LotItemCard({super.key, required this.item});

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // ... (rest of the LotItemCard implementation is identical to previous version)
    // Example snippet:
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title ?? 'No Title', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            if (item.quantity != null) Text('Quantity: ${item.quantity}', style: theme.textTheme.bodySmall),
            const Divider(height: 16),
            _buildDateRow('End Mfg:', _formatDate(item.endManufacturingDate)),
            _buildDateRow('Ready Ship:', _formatDate(item.readyToShipDate)),
            _buildDateRow('Planned Delivery:', _formatDate(item.plannedDeliveryDate)),
            _buildDateRow('Required On Site:', _formatDate(item.requiredOnSiteDate)),
            const SizedBox(height: 8),
            _buildProgressTracking(theme), // Pass item if progress comes from it
            const SizedBox(height: 8),

            // Origin and Incoterms
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Origin: ${item.originCountry ?? 'N/A'}', style: theme.textTheme.bodySmall),
                Chip(
                  label: Text(item.incoterms.name),
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                  labelStyle: theme.textTheme.labelSmall,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Comments
            if (item.comments != null && item.comments!.isNotEmpty) ...[
              Text('Comments:', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
              Text(item.comments!, style: theme.textTheme.bodySmall),
              const SizedBox(height: 8),
            ],

            // Optional: Display other fields like ITP, CWP status if needed
            // Text('ITP Required: ${item.itp ? 'Yes' : 'No'}', style: theme.textTheme.bodySmall),
            // Text('CWP: ${item.cwp == null ? 'N/A' : (item.cwp! ? 'Yes' : 'No')}', style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  // Helper widget for displaying dates neatly
  Widget _buildDateRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // Helper widget for combined progress display
  Widget _buildProgressTracking(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Progress:', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        _buildProgressIndicator('Purchasing:', item.purchasingProgress / 100.0),
        _buildProgressIndicator('Engineering:', item.engineeringProgress / 100.0),
        _buildProgressIndicator('Manufacturing:', item.manufacturingProgress / 100.0),
      ],
    );
  }

  // Helper for individual progress indicator row
  Widget _buildProgressIndicator(String label, double value) {
    final percentage = (value * 100).toStringAsFixed(0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(width: 90, child: Text(label, style: const TextStyle(fontSize: 11))),
          Expanded(child: LinearProgressIndicator(value: value, minHeight: 8, borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 8),
          SizedBox(width: 30, child: Text('$percentage%', style: const TextStyle(fontSize: 11))),
        ],
      ),
    );
  }
}
