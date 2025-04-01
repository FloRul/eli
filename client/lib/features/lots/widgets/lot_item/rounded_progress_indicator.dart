import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class RoundedProgressIndicator extends StatelessWidget {
  const RoundedProgressIndicator({super.key, required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final percentage = (value * 100).toStringAsFixed(0);
    final theme = Theme.of(context);

    // Determine color based on progress value
    Color progressColor;
    if (value < 0.3) {
      progressColor = Colors.red.shade400;
    } else if (value < 0.7) {
      progressColor = Colors.orange.shade400;
    } else {
      progressColor = Colors.green.shade400;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 4),
          CircularPercentIndicator(
            radius: 35,
            lineWidth: 5,
            percent: value,
            center: Text('$percentage%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            progressColor: progressColor,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            circularStrokeCap: CircularStrokeCap.round,
          ),
        ],
      ),
    );
  }
}
