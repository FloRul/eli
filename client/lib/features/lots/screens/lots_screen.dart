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
    final lotsAsyncValue = ref.watch(lotsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lots Overview'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Lots',
            onPressed: () => ref.read(lotsProvider.notifier).refreshLots(),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter Lots',
            onPressed: () {
              // For future implementation of filters
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Filtering coming soon!')));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // For future implementation of adding new lots
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add new lot feature coming soon!')));
        },
        tooltip: 'Add New Lot',
        child: const Icon(Icons.add),
      ),
      body: lotsAsyncValue.when(
        data: (lots) => _buildLotsList(context, lots),
        error: (error, stackTrace) => _buildErrorState(context, error),
        loading: () => _buildLoadingState(),
      ),
    );
  }

  Widget _buildLotsList(BuildContext context, List<Lot> lots) {
    if (lots.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text('No lots found', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Try refreshing or adding a new lot',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: lots.length,
      itemBuilder: (context, index) {
        return LotExpansionCard(lot: lots[index], isFirst: index == 0, isLast: index == lots.length - 1);
      },
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text('Something went wrong', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(error.toString(), style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton.icon(onPressed: () => {}, icon: const Icon(Icons.refresh), label: const Text('Try Again')),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Loading lots...')],
      ),
    );
  }
}

class LotExpansionCard extends StatelessWidget {
  final Lot lot;
  final bool isFirst;
  final bool isLast;

  const LotExpansionCard({super.key, required this.lot, this.isFirst = false, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final overallStatus = lot.overallStatus;

    return Card(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12, top: isFirst ? 0 : 0),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _getStatusColor(overallStatus).withOpacity(0.6), width: 1.5),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          title: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: _getStatusColor(overallStatus), shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  lot.displayTitle,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 4, bottom: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.business, size: 14, color: colorScheme.primary),
                    const SizedBox(width: 4),
                    Text(
                      'Provider: ${lot.provider}',
                      style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_month, size: 14, color: colorScheme.primary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Delivery: ${lot.formattedPlannedDeliveryDates}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(overallStatus).withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _getStatusColor(overallStatus).withOpacity(0.3), width: 1),
            ),
            child: Text(
              overallStatus.displayName.toUpperCase(),
              style: TextStyle(color: _getStatusColor(overallStatus), fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          childrenPadding: const EdgeInsets.only(left: 12, right: 12, bottom: 16),
          children: [
            if (lot.items.isEmpty)
              _buildEmptyItemsState(context)
            else
              ...lot.items.map((item) => LotItemCard(item: item)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyItemsState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.inventory_2_outlined, color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7)),
          const SizedBox(width: 16),
          Text(
            'No items in this lot',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

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
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title ?? 'No Title',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      if (item.quantity != null) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Qty: ${item.quantity}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getIncotermsColor(item.incoterms).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _getIncotermsColor(item.incoterms).withOpacity(0.3), width: 1),
                  ),
                  child: Text(
                    item.incoterms.name,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: _getIncotermsColor(item.incoterms),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            // Key dates section
            _buildSectionTitle(context, 'Key Dates', Icons.event),
            const SizedBox(height: 8),
            _buildDateRow(context, 'End Manufacturing', _formatDate(item.endManufacturingDate)),
            _buildDateRow(context, 'Ready to Ship', _formatDate(item.readyToShipDate)),
            _buildDateRow(context, 'Planned Delivery', _formatDate(item.plannedDeliveryDate), isHighlighted: true),
            _buildDateRow(context, 'Required On Site', _formatDate(item.requiredOnSiteDate)),

            const SizedBox(height: 16),

            // Progress Tracking section
            _buildSectionTitle(context, 'Progress Tracking', Icons.insights),
            const SizedBox(height: 8),
            _buildProgressIndicator(context, 'Purchasing', item.purchasingProgress / 100.0),
            _buildProgressIndicator(context, 'Engineering', item.engineeringProgress / 100.0),
            _buildProgressIndicator(context, 'Manufacturing', item.manufacturingProgress / 100.0),
            const SizedBox(height: 8),
            _buildOverallProgress(context, item),

            const SizedBox(height: 16),

            // Origin information section
            _buildSectionTitle(context, 'Origin Information', Icons.public),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, size: 20, color: colorScheme.primary),
                  const SizedBox(width: 12),
                  Text(
                    'Origin: ${item.originCountry ?? 'N/A'}',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            // Comments section (if available)
            if (item.comments != null && item.comments!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildSectionTitle(context, 'Comments', Icons.comment),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colorScheme.outlineVariant, width: 1),
                ),
                child: Text(item.comments!, style: theme.textTheme.bodyMedium),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 16, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
        ),
      ],
    );
  }

  Widget _buildDateRow(BuildContext context, String label, String value, {bool isHighlighted = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isHighlighted ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration:
                isHighlighted
                    ? BoxDecoration(
                      color: colorScheme.primaryContainer.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4),
                    )
                    : null,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                color: isHighlighted ? colorScheme.primary : colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, String label, double value) {
    final percentage = (value * 100).toStringAsFixed(0);
    final colorScheme = Theme.of(context).colorScheme;

    // Determine color based on progress value
    Color progressColor;
    if (value < 0.3) {
      progressColor = Colors.red.shade400;
    } else if (value < 0.7) {
      progressColor = Colors.orange.shade400;
    } else {
      progressColor = Colors.green.shade400;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ),
              Text('$percentage%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: progressColor)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 8,
              backgroundColor: colorScheme.surfaceContainerHighest,
              color: progressColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallProgress(BuildContext context, LotItem item) {
    // Calculate overall progress as average of the three progress types
    final overallProgress = (item.purchasingProgress + item.engineeringProgress + item.manufacturingProgress) / 300.0;
    final percentage = (overallProgress * 100).toStringAsFixed(0);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.primary.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overall Progress',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: colorScheme.primary),
              ),
              Text(
                '$percentage%',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: overallProgress,
              minHeight: 10,
              backgroundColor: colorScheme.surfaceContainerHighest,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getIncotermsColor(Incoterm incoterms) {
    // Example mapping of incoterms to colors
    // You may want to adjust these based on your actual incoterms values
    String name = incoterms.name.toString().toLowerCase();
    if (name.contains('fob')) return Colors.purple.shade700;
    if (name.contains('cif')) return Colors.blue.shade700;
    if (name.contains('ex')) return Colors.teal.shade700;
    if (name.contains('dap')) return Colors.indigo.shade700;
    return Colors.blueGrey.shade700;
  }
}
