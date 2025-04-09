import 'package:flutter/material.dart';

/// Widget that displays the assigned expeditor information
class AssignedExpeditor extends StatelessWidget {
  const AssignedExpeditor({super.key, this.assignedToFullName, this.assignedToEmail});

  final String? assignedToFullName;
  final String? assignedToEmail;
  @override
  Widget build(BuildContext context) {
    String nameToDisplay = 'Unassigned';
    if (assignedToFullName != null && assignedToFullName!.isNotEmpty) {
      nameToDisplay = assignedToFullName!;
    } else if (assignedToEmail != null && assignedToEmail!.isNotEmpty) {
      nameToDisplay = assignedToEmail!.split('@').first;
    }
    return Row(
      spacing: 4,
      children: [
        const Icon(Icons.person, size: 12),
        const SizedBox(width: 4),
        Text(nameToDisplay, style: Theme.of(context).textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}
