import 'package:client/features/lots/models/enums.dart';
import 'package:client/features/lots/widgets/common/utils.dart';
import 'package:flutter/material.dart';

class IncotermSelector extends StatelessWidget {
  const IncotermSelector({super.key, required this.value});
  final Incoterm value;
  @override
  Widget build(BuildContext context) {
    final color = getIncotermsColor(value);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        value.name.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
