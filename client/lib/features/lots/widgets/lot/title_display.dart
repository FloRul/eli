import 'package:client/features/lots/models/lot.dart';
import 'package:client/features/lots/providers/lot_provider.dart';
import 'package:client/features/lots/widgets/editable_field/editable_field.dart';
import 'package:client/features/lots/widgets/editable_field/editable_field_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget that displays the title
class TitleDisplay extends ConsumerWidget {
  final Lot lot;

  const TitleDisplay({super.key, required this.lot});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // Title field (editable)
        Expanded(
          child: EditableField<String>(
            value: lot.title,
            fieldType: EditableFieldType.text,
            label: 'Title',
            displayBuilder:
                (value) => Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            onUpdate: (newValue) async {
              await ref.read(lotsProvider.notifier).updateLot(lot.id, {'title': newValue});
            },
          ),
        ),

        // Lot number (editable)
        const SizedBox(width: 8),
        EditableField<String>(
          value: lot.number,
          fieldType: EditableFieldType.text,
          label: 'Lot Number',
          displayBuilder:
              (value) => Text(
                '#$value',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
          onUpdate: (newValue) async {
            await ref.read(lotsProvider.notifier).updateLot(lot.id, {'number': newValue});
          },
        ),
      ],
    );
  }
}


