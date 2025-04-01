// Header Section - Needs Ref for updates
import 'package:client/features/lots/models/enums.dart';
import 'package:client/features/lots/models/lot_item.dart';
import 'package:client/features/lots/providers/lot_provider.dart';
import 'package:client/features/lots/widgets/editable_field/editable_field.dart';
import 'package:client/features/lots/widgets/editable_field/editable_field_type.dart';
import 'package:client/features/lots/widgets/lot_card.dart';
import 'package:client/features/lots/widgets/lot_item/incoterms_selector.dart';
import 'package:client/features/lots/widgets/lot_item/origin_country_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class HeaderSection extends ConsumerWidget {
  final LotItem item;
  const HeaderSection({super.key, required this.item});

  Future<void> _updateItem(WidgetRef ref, Map<String, dynamic> data) async {
    // This now lives inside the widget that needs it
    await ref.read(lotsProvider.notifier).updateLotItem(item.id, data);
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
          displayBuilder: (value) => OriginCountryDisplay(value: value),
          onUpdate: (newValue) => _updateItem(ref, {'origin_country': newValue}),
        ),
        EditableField<Incoterm>(
          value: item.incoterms,
          fieldType: EditableFieldType.incoterm,
          label: 'Incoterms',
          displayBuilder: (value) => IncotermSelector(value: value),
          onUpdate: (newValue) => _updateItem(ref, {'incoterms': newValue.name}),
        ),
      ],
    );
  }
}
