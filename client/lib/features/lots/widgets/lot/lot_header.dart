import 'package:client/features/lots/models/lot.dart';
import 'package:client/features/lots/widgets/lot/assigned_expeditor.dart';
import 'package:client/features/lots/widgets/lot/delivery_info.dart';
import 'package:client/features/lots/widgets/lot/provider_pill.dart';
import 'package:client/features/lots/widgets/common/status_badge.dart';
import 'package:flutter/material.dart';

/// Widget that displays the header content for a lot
class LotHeader extends StatelessWidget {
  final Lot lot;

  const LotHeader({super.key, required this.lot});

  @override
  Widget build(BuildContext context) {
    final overallStatus = lot.overallStatus;
    final theme = Theme.of(context);
    return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 8,
      children: [
        StatusDropdown(currentStatus: overallStatus, onStatusChanged: (value) {}),
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
        IntrinsicWidth(
          child: AssignedExpeditor(assignedToFullName: lot.assignedToFullName, assignedToEmail: lot.assignedToEmail),
        ),
        ProviderPill(provider: lot.provider),
        DeliveryInfo(dates: lot.formattedFirstAndLastPlannedDeliveryDates),
      ],
    );
  }
}
