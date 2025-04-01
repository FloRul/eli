import 'package:flutter/material.dart';

class DeliveryInfo extends StatelessWidget {
  final String dates;

  const DeliveryInfo({super.key, required this.dates});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.calendar_month, size: 16, color: colorScheme.primary),
        const SizedBox(width: 4),
        Text(dates, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
