import 'package:flutter/material.dart';

class OriginCountryDisplay extends StatelessWidget {
  final String value;

  const OriginCountryDisplay({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
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
}
