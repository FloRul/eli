// Header Section - Needs Ref for updates
import 'package:client/features/lots/models/lot_item.dart';
import 'package:client/features/lots/widgets/common/status_badge.dart';
import 'package:client/features/lots/widgets/lot_item/incoterms_selector.dart';
import 'package:client/features/lots/widgets/lot_item/origin_country_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HeaderSection extends ConsumerWidget {
  final LotItem item;
  const HeaderSection({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Row(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StatusDropdown(currentStatus: item.status, onStatusChanged: (value) {}),

        Expanded(
          child: Text(
            item.title ?? 'N/A',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            item.quantity?.isEmpty ?? true ? 'Add Qty' : 'Qty: ${item.quantity}',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),

        OriginCountryDisplay(value: item.originCountry ?? ''),
        IncotermSelector(value: item.incoterms),
      ],
    );
  }
}
