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
    // Get the color for the currently selected status
    final statusColor = getStatusColor(currentStatus);
    // Define the border radius consistently
    final borderRadius = BorderRadius.circular(16);

    // Use a Container to create the background, border, and shape
    return Container(
      // No padding here, let the Material handle clipping
      decoration: BoxDecoration(
        // Use current status color for background with low opacity
        color: statusColor.withAlpha(38), // approx 0.15 opacity (0.15 * 255)
        borderRadius: borderRadius, // Use the defined radius
        // Use current status color for border with low opacity
        border: Border.all(
          color: statusColor.withAlpha(77), // approx 0.3 opacity (0.3 * 255)
          width: 1,
        ),
      ),
      // *** Add Material Widget here ***
      child: Material(
        // Make Material transparent to see Container's color
        color: Colors.transparent,
        // Apply the same border radius
        borderRadius: borderRadius,
        // *** Crucial: Clip the ink splash to the rounded shape ***
        clipBehavior: Clip.antiAlias, // or Clip.hardEdge
        child: DropdownButtonHideUnderline(
          // Hide the default underline of the dropdown
          child: DropdownButton<Status>(
            value: currentStatus,
            isDense: true, // Keep it compact
            icon: Icon(Icons.arrow_drop_down, color: statusColor),
            dropdownColor: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8), // Dropdown menu radius (can be different)
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0), // Adjust horizontal padding as needed
            onChanged: (Status? newValue) {
              // Ensure a new value was selected and it's different from the current one
              if (newValue != null && newValue != currentStatus) {
                onStatusChanged(newValue);
              }
            },

            // Generate the list of items for the dropdown menu
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
                // Center the text vertically within the dropdown button space
                // No extra padding needed here if isDense is true and DropdownButton padding is set
                return Center(
                  child: Text(
                    status.displayName.toUpperCase(),
                    style: TextStyle(
                      color: color, // Use the color matching the selected status
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis, // Prevent overflow if text is too long
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
