// Header Section - Needs Ref for updates
import 'package:client/features/lots/models/enums.dart';
import 'package:client/features/lots/models/lot_item.dart';
import 'package:client/features/lots/providers/lot_provider.dart';
import 'package:client/features/lots/widgets/editable_field/editable_field.dart';
import 'package:client/features/lots/widgets/editable_field/editable_field_type.dart';
import 'package:client/features/lots/widgets/lot_expansion_card.dart';
import 'package:client/features/lots/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HeaderSection extends ConsumerWidget {
  final LotItem item;
  const HeaderSection({super.key, required this.item});

  Future<void> _updateItem(WidgetRef ref, Map<String, dynamic> data) async {
    // This now lives inside the widget that needs it
    await ref.read(lotsProvider.notifier).updateLotItem(item.id, data);
  }

  Widget _buildOriginCountryDisplay(BuildContext context, String value) {
    // Display helpers moved here
    final theme = Theme.of(context);
    if (value.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Text('Add origin', style: theme.textTheme.bodySmall),
      );
    }
    final flag = value.toUpperCase().split('').map((e) => String.fromCharCode(e.codeUnitAt(0) + 127397)).join('');
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
  }

  Widget _buildIncotermDisplay(BuildContext context, Incoterm value) {
    // Display helpers moved here
    final theme = Theme.of(context);
    final color = getIncotermsColor(value); // Assuming this utility function is accessible
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        value.name.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Row(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StatusBadge(status: item.status, itemId: item.id),
        
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
                  overflow: TextOverflow.ellipsis,
                ),
            onUpdate: (newValue) => _updateItem(ref, {'title': newValue}),
          ),
        ),
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
          onUpdate: (newValue) => _updateItem(ref, {'quantity': newValue}),
        ),
        EditableField<String>(
          value: item.originCountry ?? '',
          fieldType: EditableFieldType.text,
          label: 'Origin Country (2-letter code)',
          hintText: 'e.g. US, CN, DE',
          displayBuilder: (value) => _buildOriginCountryDisplay(context, value),
          onUpdate: (newValue) => _updateItem(ref, {'origin_country': newValue}),
        ),
        EditableField<Incoterm>(
          value: item.incoterms,
          fieldType: EditableFieldType.incoterm,
          label: 'Incoterms',
          displayBuilder: (value) => _buildIncotermDisplay(context, value),
          onUpdate: (newValue) => _updateItem(ref, {'incoterms': newValue.name}),
        ),
      ],
    );
  }
}
