// Progress Section
import 'package:client/features/lots/models/lot_item.dart';
import 'package:client/features/lots/widgets/lot_item/progress_pill.dart';
import 'package:client/features/lots/widgets/lot_item/rounded_progress_indicator.dart';
import 'package:flutter/material.dart';

class ProgressSection extends StatelessWidget {
  final LotItem item;
  const ProgressSection({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final overallProgress = (item.purchasingProgress + item.engineeringProgress + item.manufacturingProgress) / 300.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProgressPill(
          progress: overallProgress,
          label: 'Progress Tracking',
          icon: Icons.insights,
          title: 'Overall Progress',
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RoundedProgressIndicator(label: 'Purchasing', value: item.purchasingProgress / 100.0),
            RoundedProgressIndicator(label: 'Engineering', value: item.engineeringProgress / 100.0),
            RoundedProgressIndicator(label: 'Manufacturing', value: item.manufacturingProgress / 100.0),
          ],
        ),
      ],
    );
  }
}
