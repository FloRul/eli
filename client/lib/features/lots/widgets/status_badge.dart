import 'package:client/features/lots/models/enums.dart';
import 'package:client/features/lots/widgets/utils.dart';
import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final Status status;

  @override
  Widget build(BuildContext context) {
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
