import 'package:client/features/home/providers/projects_provider.dart';
import 'package:client/features/lots/providers/lot_provider.dart';
import 'package:client/features/lots/widgets/editable_field/editable_field.dart';
import 'package:client/features/lots/widgets/editable_field/editable_field_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget that displays the provider information in a pill
class ProviderPill extends ConsumerWidget {
  final String provider;
  final int lotId;

  const ProviderPill({super.key, required this.provider, required this.lotId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return EditableField<String>(
      value: provider,
      fieldType: EditableFieldType.text,
      label: 'Provider',
      displayBuilder:
          (value) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.secondary.withValues(alpha: 0.3), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.business, size: 12, color: colorScheme.secondary),
                const SizedBox(width: 4),
                Text(
                  value,
                  style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500, color: colorScheme.secondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
      onUpdate: (newValue) async {
        await ref.read(lotsProvider(ref.watch(currentProjectNotifierProvider)).notifier).updateLot(lotId, {'provider': newValue});
      },
    );
  }
}
