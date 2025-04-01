import 'package:client/features/lots/models/lot.dart';
import 'package:client/features/lots/widgets/lot/lot_card.dart';
import 'package:client/features/lots/widgets/lot/provider_pill.dart';
import 'package:flutter/material.dart';

/// Widget that displays the header content for a lot
class LotHeader extends StatelessWidget {
  final Lot lot;

  const LotHeader({super.key, required this.lot});

  @override
  Widget build(BuildContext context) {
    final overallStatus = lot.overallStatus;

    return Row(
      spacing: 12,
      children: [
        StatusBadge(status: overallStatus),
        Expanded(child: TitleDisplay(lot: lot)),
        ProviderPill(provider: lot.provider, lotId: lot.id),
        DeliveryInfo(dates: lot.formattedPlannedDeliveryDates),
      ],
    );
  }
}
