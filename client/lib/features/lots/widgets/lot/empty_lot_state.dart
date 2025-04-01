import 'package:flutter/material.dart';

/// Widget that displays a message when there are no items in a lot
class EmptyLotState extends StatelessWidget {
  const EmptyLotState({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.inventory_2_outlined, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
          const SizedBox(width: 16),
          Text(
            'No items in this lot',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
