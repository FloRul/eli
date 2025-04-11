import 'package:client/features/dashboard/models/project_dashboard_summary.dart';
import 'package:client/features/lots/widgets/lot_item/rounded_progress_indicator.dart';
import 'package:flutter/material.dart';

class ProgressOverview extends StatelessWidget {
  const ProgressOverview({super.key, required this.summary});

  final ProjectDashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Progress Overview', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            RoundedProgressIndicator(label: 'Purchasing', value: summary.avgPurchasingProgress / 100),
            RoundedProgressIndicator(label: 'Engineering', value: summary.avgEngineeringProgress / 100),
            RoundedProgressIndicator(label: 'Manufacturing', value: summary.avgManufacturingProgress / 100),
          ],
        ),
      ),
    );
  }
}
