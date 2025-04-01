import 'package:flutter/material.dart';

class ProgressPill extends StatelessWidget {
  const ProgressPill({super.key, required this.progress, required this.label, required this.icon, required this.title});
  final double progress;
  final String label;
  final IconData icon;
  final String title;
  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).toStringAsFixed(0);

    // Determine color based on progress value
    Color progressColor;
    if (progress < 0.3) {
      progressColor = Colors.red.shade400;
    } else if (progress < 0.7) {
      progressColor = Colors.orange.shade400;
    } else {
      progressColor = Colors.green.shade400;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: progressColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: progressColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        '$title $percentage%',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: progressColor),
      ),
    );
  }
}
