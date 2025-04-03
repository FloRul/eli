import 'package:client/features/lots/models/enums.dart'; // Assuming Status enum is here
import 'package:client/features/lots/widgets/common/utils.dart'; // Assuming getStatusColor is here
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget that displays an editable status dropdown with a pill-like appearance.
class StatusDropdown extends ConsumerWidget {
  final Status currentStatus;
  final ValueChanged<Status> onStatusChanged; // Callback when status is changed

  const StatusDropdown({super.key, required this.currentStatus, required this.onStatusChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = getStatusColor(currentStatus);
    final borderRadius = BorderRadius.circular(16);

    return Container(
      decoration: BoxDecoration(
        color: statusColor.withAlpha(38), // approx 0.15 opacity
        borderRadius: borderRadius,
        border: Border.all(
          color: statusColor.withAlpha(77), // approx 0.3 opacity
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Status>(
            value: currentStatus,
            isDense: true,
            icon: Icon(Icons.arrow_drop_down, color: statusColor),
            dropdownColor: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
            onChanged: (Status? newValue) {
              if (newValue != null && newValue != currentStatus) {
                onStatusChanged(newValue);
                FocusScope.of(context).unfocus();
              }
            },
            items:
                Status.values.map<DropdownMenuItem<Status>>((Status status) {
                  return DropdownMenuItem<Status>(
                    value: status,
                    child: Text(status.displayName, style: TextStyle(color: getStatusColor(status))),
                  );
                }).toList(),
            selectedItemBuilder: (BuildContext context) {
              return Status.values.map<Widget>((Status status) {
                final color = getStatusColor(status);
                return Center(
                  child: Text(
                    status.displayName.toUpperCase(),
                    style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
