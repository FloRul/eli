import 'package:client/features/lots/models/lot_item.dart';
import 'package:client/features/lots/models/enums.dart';
import 'package:client/features/lots/providers/lot_provider.dart';
import 'package:client/features/lots/widgets/editable_field.dart';
import 'package:client/features/lots/widgets/editable_field/editable_field_type.dart';
import 'package:client/features/lots/widgets/status_badge.dart';
import 'package:client/features/lots/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class LotItemCard extends ConsumerWidget {
  final LotItem item;
  const LotItemCard({super.key, required this.item});

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StatusBadge(status: item.status, itemId: item.id),
                const SizedBox(width: 8),
                Expanded(
                  child: EditableField<String>(
                    value: item.title ?? 'No Title',
                    fieldType: EditableFieldType.text,
                    label: 'Item Title',
                    displayBuilder:
                        (value) => Text(
                          value,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                    onUpdate: (newValue) async {
                      await ref.read(lotsProvider.notifier).updateLotItem(item.id, {'title': newValue});
                    },
                  ),
                ),

                // Quantity (editable)
                const SizedBox(width: 8),
                EditableField<String>(
                  value: item.quantity ?? '',
                  fieldType: EditableFieldType.text,
                  label: 'Quantity',
                  displayBuilder:
                      (value) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          value.isEmpty ? 'Add Qty' : 'Qty: $value',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                  onUpdate: (newValue) async {
                    await ref.read(lotsProvider.notifier).updateLotItem(item.id, {'quantity': newValue});
                  },
                ),

                // Origin country (editable)
                const SizedBox(width: 8),
                EditableField<String>(
                  value: item.originCountry ?? '',
                  fieldType: EditableFieldType.text,
                  label: 'Origin Country (2-letter code)',
                  hintText: 'e.g. US, CN, DE',
                  displayBuilder: (value) {
                    if (value.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                        ),
                        child: const Text('Add origin'),
                      );
                    }

                    // Flag emoji representation using Unicode
                    final flag = value
                        .toUpperCase()
                        .split('')
                        .map((e) => String.fromCharCode(e.codeUnitAt(0) + 127397))
                        .join('');

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(flag, style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 4),
                          Text(value, style: theme.textTheme.bodySmall?.copyWith(fontSize: 10)),
                        ],
                      ),
                    );
                  },
                  onUpdate: (newValue) async {
                    await ref.read(lotsProvider.notifier).updateLotItem(item.id, {'origin_country': newValue});
                  },
                ),
                // Incoterms (editable)
                const SizedBox(width: 8),
                EditableField<Incoterm>(
                  value: item.incoterms,
                  fieldType: EditableFieldType.incoterm,
                  label: 'Incoterms',
                  displayBuilder:
                      (value) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: getIncotermsColor(value).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: getIncotermsColor(value).withValues(alpha: 0.3), width: 1),
                        ),
                        child: Text(
                          value.name.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: getIncotermsColor(value),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  onUpdate: (newValue) async {
                    await ref.read(lotsProvider.notifier).updateLotItem(item.id, {'incoterms': newValue.name});
                  },
                ),
              ],
            ),
            // Key dates and Progress sections side by side with responsive wrap
            LayoutBuilder(
              builder: (context, constraints) {
                // Determine if we should layout in a row or column based on available width
                final isWide = constraints.maxWidth > 600;
                // Check if we have enough width for 3 columns
                final isVeryWide = constraints.maxWidth > 900;
                final hasComments = item.comments != null && item.comments!.isNotEmpty;

                // We'll use a column for overall layout
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row with key dates and progress
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Key dates section
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DateTimeline(
                                primaryColor: theme.colorScheme.primary,
                                entries: [
                                  TimelineEntry(
                                    label: 'End Manufacturing',
                                    date: _formatDate(item.endManufacturingDate),
                                    isPassed:
                                        item.endManufacturingDate != null &&
                                        item.endManufacturingDate!.isBefore(DateTime.now()),
                                  ),
                                  TimelineEntry(
                                    label: 'Ready to Ship',
                                    date: _formatDate(item.readyToShipDate),
                                    isPassed:
                                        item.readyToShipDate != null && item.readyToShipDate!.isBefore(DateTime.now()),
                                  ),
                                  TimelineEntry(
                                    label: 'Planned Delivery',
                                    date: _formatDate(item.plannedDeliveryDate),
                                    isHighlighted: true,
                                    isPassed:
                                        item.plannedDeliveryDate != null &&
                                        item.plannedDeliveryDate!.isBefore(DateTime.now()),
                                  ),
                                  TimelineEntry(
                                    label: 'Required On Site',
                                    date: _formatDate(item.requiredOnSiteDate),
                                    isPassed:
                                        item.requiredOnSiteDate != null &&
                                        item.requiredOnSiteDate!.isBefore(DateTime.now()),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        if (isWide) const SizedBox(width: 24) else const SizedBox(height: 16),

                        // Progress section
                        if (isWide)
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Progress Tracking section with percentage
                                _buildSectionTitleWithProgress(
                                  context,
                                  'Progress Tracking',
                                  Icons.insights,
                                  (item.purchasingProgress + item.engineeringProgress + item.manufacturingProgress) /
                                      300.0,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildProgressIndicator(context, 'Purchasing', item.purchasingProgress / 100.0),
                                    _buildProgressIndicator(context, 'Engineering', item.engineeringProgress / 100.0),
                                    _buildProgressIndicator(
                                      context,
                                      'Manufacturing',
                                      item.manufacturingProgress / 100.0,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                        // Comments section in the 3rd column if we have enough width
                        if (isVeryWide && hasComments) ...[
                          const SizedBox(width: 24),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SectionTitle(title: 'Comments', icon: Icons.comment),
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: theme.colorScheme.outlineVariant, width: 1),
                                  ),
                                  child: Text(item.comments!, style: theme.textTheme.bodyMedium),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Second row with progress section if on mobile
                    if (!isWide) ...[
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitleWithProgress(
                            context,
                            'Progress Tracking',
                            Icons.insights,
                            (item.purchasingProgress + item.engineeringProgress + item.manufacturingProgress) / 300.0,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildProgressIndicator(context, 'Purchasing', item.purchasingProgress / 100.0),
                              _buildProgressIndicator(context, 'Engineering', item.engineeringProgress / 100.0),
                              _buildProgressIndicator(context, 'Manufacturing', item.manufacturingProgress / 100.0),
                            ],
                          ),
                        ],
                      ),
                    ],

                    // Comments section if not in very wide view but has comments
                    if (hasComments && !isVeryWide) ...[
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionTitle(title:'Comments',icon: Icons.comment),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: theme.colorScheme.outlineVariant, width: 1),
                            ),
                            child: Text(item.comments!, style: theme.textTheme.bodyMedium),
                          ),
                        ],
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitleWithProgress(BuildContext context, String title, IconData icon, double progress) {
    final theme = Theme.of(context);
    final percentage = (progress * 100).toStringAsFixed(0);

    // Determine color based on progress value
    Color progressColor;
    if (progress < 0.3) {
      progressColor = Colors.red.shade400;
    } else if (progress < 0.7) {
      progressColor = Colors.orange.shade400;
    } else {
      progressColor = Colors.green.shade400;
    }

    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: progressColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: progressColor.withValues(alpha: 0.3), width: 1),
          ),
          child: Text(
            '$percentage%',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: progressColor),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context, String label, double value) {
    final percentage = (value * 100).toStringAsFixed(0);
    final theme = Theme.of(context);

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
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 4),
          CircularPercentIndicator(
            radius: 35,
            lineWidth: 5,
            percent: value,
            center: Text('$percentage%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            progressColor: progressColor,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            circularStrokeCap: CircularStrokeCap.round,
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, required this.icon});
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
        ),
      ],
    );
  }
}
