import 'package:flutter/material.dart';
import 'package:client/features/lots/models/enums.dart'; // Assuming Status and Incoterm are here
import 'package:client/features/lots/widgets/common/utils.dart'; // Assuming getStatusColor etc. are here
import 'package:client/features/lots/widgets/editable_field/editors/editor_actions.dart';

Widget buildStatusEditor({
  required BuildContext context,
  required String? label,
  required tempValue, // Should be Status?
  required ValueChanged<Status?> onTempValueChanged, // Callback
  required VoidCallback onSave,
  required VoidCallback onCancel,
  required bool isSubmitting,
}) {
  final Status? currentStatus = tempValue is Status ? tempValue : null;

  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Text(label, style: Theme.of(context).textTheme.labelMedium),
          ),
        Material(
          color: Theme.of(context).colorScheme.surfaceContainerHighest, // Changed background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(color: Theme.of(context).dividerColor),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                Status.values.where((s) => s != Status.unknown).map((status) {
                  // Exclude 'unknown'
                  final bool isSelected = currentStatus == status;
                  final Color statusColor = getStatusColor(status);

                  return InkWell(
                    onTap: () => onTempValueChanged(status),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(status.displayName)),
                          if (isSelected) Icon(Icons.check, color: Theme.of(context).colorScheme.primary, size: 18),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
        buildEditorActions(context: context, isSubmitting: isSubmitting, onCancel: onCancel, onSave: onSave),
      ],
    ),
  );
}

Widget buildIncotermEditor({
  required BuildContext context,
  required String? label,
  required tempValue, // Should be Incoterm?
  required ValueChanged<Incoterm?> onTempValueChanged, // Callback
  required VoidCallback onSave,
  required VoidCallback onCancel,
  required bool isSubmitting,
}) {
  final Incoterm? currentIncoterm = tempValue is Incoterm ? tempValue : null;

  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Text(label, style: Theme.of(context).textTheme.labelMedium),
          ),
        Material(
          color: Theme.of(context).colorScheme.surfaceContainerHighest, // Changed background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(color: Theme.of(context).dividerColor),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                Incoterm.values.where((i) => i != Incoterm.unknown).map((incoterm) {
                  // Exclude 'unknown'
                  final bool isSelected = currentIncoterm == incoterm;
                  final Color incotermColor = getIncotermsColor(incoterm);

                  return InkWell(
                    onTap: () => onTempValueChanged(incoterm),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              // Assuming ColorExt exists in utils.dart or similar
                              color: incotermColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: incotermColor.withValues(alpha: 0.3), width: 1),
                            ),
                            child: Text(
                              incoterm.name.toUpperCase(),
                              style: TextStyle(color: incotermColor, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (isSelected) Icon(Icons.check, color: Theme.of(context).colorScheme.primary, size: 18),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
        buildEditorActions(context: context, isSubmitting: isSubmitting, onCancel: onCancel, onSave: onSave),
      ],
    ),
  );
}
