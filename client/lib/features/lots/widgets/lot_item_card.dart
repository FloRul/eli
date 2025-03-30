import 'package:client/features/lots/models/lot_item.dart';
import 'package:client/features/lots/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

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
                            color: colorScheme.primaryContainer.withValues(alpha: 0.4),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: getIncotermsColor(item.incoterms).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: getIncotermsColor(item.incoterms).withValues(alpha: 0.3), width: 1),
                      ),
                      child: Text(
                        item.incoterms.name,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: getIncotermsColor(item.incoterms),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (item.originCountry != null && item.originCountry!.isNotEmpty) ...[  
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Flag emoji representation using Unicode
                            Text(
                              item.originCountry!.toUpperCase().split('').map((e) => 
                                String.fromCharCode(e.codeUnitAt(0) + 127397)).join(''),
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.originCountry!,
                              style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),

            const Divider(height: 24),

            // Key dates and Progress sections side by side with responsive wrap
            LayoutBuilder(
              builder: (context, constraints) {
                // Determine if we should layout in a row or column based on available width
                final isWide = constraints.maxWidth > 600;
                return Flex(
                  direction: isWide ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Key dates section
                          _buildSectionTitle(context, 'Key Dates', Icons.event),
                          const SizedBox(height: 8),
                          _buildDateRow(context, 'End Manufacturing', _formatDate(item.endManufacturingDate)),
                          _buildDateRow(context, 'Ready to Ship', _formatDate(item.readyToShipDate)),
                          _buildDateRow(
                            context,
                            'Planned Delivery',
                            _formatDate(item.plannedDeliveryDate),
                            isHighlighted: true,
                          ),
                          _buildDateRow(context, 'Required On Site', _formatDate(item.requiredOnSiteDate)),
                        ],
                      ),
                    ),
                    if (isWide) const SizedBox(width: 24) else const SizedBox(height: 16),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Progress Tracking section
                          _buildSectionTitle(context, 'Progress Tracking', Icons.insights),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildProgressIndicator(context, 'Purchasing', item.purchasingProgress / 100.0),
                              _buildProgressIndicator(context, 'Engineering', item.engineeringProgress / 100.0),
                              _buildProgressIndicator(context, 'Manufacturing', item.manufacturingProgress / 100.0),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildOverallProgress(context, item),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),


            // Comments section (if available)
            if (item.comments != null && item.comments!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildSectionTitle(context, 'Comments', Icons.comment),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
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
              color: isHighlighted ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration:
                isHighlighted
                    ? BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(alpha: 0.4),
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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 4),
          CircularPercentIndicator(
            radius: 35,
            lineWidth: 5,
            percent: value,
            center: Text('$percentage%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            progressColor: progressColor,
            backgroundColor: colorScheme.surfaceContainerHighest,
            circularStrokeCap: CircularStrokeCap.round,
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
        color: colorScheme.primaryContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3), width: 1),
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
}
