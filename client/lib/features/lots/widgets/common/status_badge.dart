import 'package:client/features/lots/models/enums.dart';
import 'package:client/features/lots/providers/lot_provider.dart';
import 'package:client/features/lots/widgets/editable_field/editable_field.dart';
import 'package:client/features/lots/widgets/editable_field/editable_field_type.dart';
import 'package:client/features/lots/widgets/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatusBadge extends ConsumerWidget {
  final Status status;
  final int? itemId; // If null, this is a lot status badge (read-only)

  const StatusBadge({super.key, required this.status, this.itemId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If itemId is not provided, it's a lot status badge (computed from items), so not editable
    if (itemId == null) {
      return _buildStatusBadgeDisplay(status);
    }

    // Otherwise, it's an item status badge and should be editable
    return EditableField<Status>(
      value: status,
      fieldType: EditableFieldType.status,
      label: 'Status',
      displayBuilder: (value) => _buildStatusBadgeDisplay(value),
      onUpdate: (newValue) async {
        await ref.read(lotsProvider.notifier).updateLotItem(itemId!, {'status': newValue.name});
      },
    );
  }

  Widget _buildStatusBadgeDisplay(Status status) {
    return Builder(
      builder: (context) {
        final statusColor = getStatusColor(status);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1),
          ),
          child: Text(
            status.displayName.toUpperCase(),
            style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}
