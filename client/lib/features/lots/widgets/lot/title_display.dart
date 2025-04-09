import 'package:client/features/lots/models/lot.dart';
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
      spacing: 16,
      children: [
        Text(
          lot.number,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          lot.title,
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: theme.colorScheme.onSurface),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
