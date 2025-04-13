import 'package:client/features/dashboard/models/project_dashboard_summary.dart';
import 'package:client/features/lots/widgets/lot_item/rounded_progress_indicator.dart';
import 'package:flutter/material.dart';

class ProgressOverview extends StatelessWidget {
  const ProgressOverview({super.key, required this.summary});

  final ProjectDashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RoundedProgressIndicator(label: 'Purchasing', value: summary.avgPurchasingProgress / 100),
        RoundedProgressIndicator(label: 'Engineering', value: summary.avgEngineeringProgress / 100),
        RoundedProgressIndicator(label: 'Manufacturing', value: summary.avgManufacturingProgress / 100),
      ],
    );
  }
}
