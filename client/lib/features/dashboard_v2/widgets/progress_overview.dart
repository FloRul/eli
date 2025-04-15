import 'package:client/features/lots/widgets/lot_item/rounded_progress_indicator.dart';
import 'package:flutter/material.dart';

class ProgressOverview extends StatelessWidget {
  const ProgressOverview({super.key, required this.progresses});

  final List<(String, double)> progresses;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 24,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: progresses.map((progress) => RoundedProgressIndicator(label: progress.$1, value: progress.$2)).toList(),
    );
  }
}
