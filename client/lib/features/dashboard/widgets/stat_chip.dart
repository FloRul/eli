import 'package:flutter/material.dart';

class StatChip extends StatelessWidget {
  const StatChip({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    this.subtitle,
  });
  final IconData icon;
  final String title;
  final String value;
  final String? subtitle;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return IntrinsicWidth(
      child: Card(
        color: color.withValues(alpha: 0.1), // Subtle background tint
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: color.withValues(alpha: 0.3)), // Subtle border
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            spacing: 4,
            children: [
              Text(
                value,
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: color, fontSize: 24),
              ),
              Icon(icon, size: 24, color: color),
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurfaceVariant, fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null)
                    Text(subtitle!, style: textTheme.labelSmall?.copyWith(color: colorScheme.outline)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
