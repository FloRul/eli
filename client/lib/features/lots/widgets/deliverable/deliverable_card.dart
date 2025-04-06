import 'package:client/features/home/providers/projects_provider.dart';
import 'package:client/features/lots/models/deliverable.dart';
import 'package:client/features/lots/providers/lot_provider.dart';
import 'package:client/features/lots/widgets/deliverable/deliverable_form.dart'; // To be created
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DeliverableCard extends ConsumerWidget {
  final Deliverable deliverable;
  final int parentLotId;

  const DeliverableCard({super.key, required this.deliverable, required this.parentLotId});

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isLate = !deliverable.isReceived && deliverable.dueDate.isBefore(DateTime.now());
    final projectId = ref.watch(currentProjectNotifierProvider); // Needed for provider

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: theme.colorScheme.outlineVariant, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          children: [
            Checkbox(
              value: deliverable.isReceived,
              onChanged: (bool? value) {
                if (value != null && projectId != null) {
                  ref.read(lotsProvider(projectId).notifier).updateDeliverable(deliverable.id, {'is_received': value});
                }
              },
              activeColor: theme.colorScheme.primary,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deliverable.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      decoration: deliverable.isReceived ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  Text(
                    'Due: ${_formatDate(deliverable.dueDate)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isLate ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant,
                      fontWeight: isLate ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              tooltip: 'Edit Deliverable',
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                  builder: (_) => DeliverableForm(initialDeliverable: deliverable, parentLotId: parentLotId),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, size: 20, color: theme.colorScheme.error),
              tooltip: 'Delete Deliverable',
              onPressed: () async {
                if (projectId == null) return;
                // Optional: Show confirmation dialog
                final confirm = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Delete Deliverable?'),
                        content: Text('Are you sure you want to delete "${deliverable.title}"?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                          ),
                        ],
                      ),
                );
                if (confirm == true) {
                  try {
                    await ref.read(lotsProvider(projectId).notifier).deleteDeliverable(deliverable.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Deliverable deleted.'), duration: Duration(seconds: 2)),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Error deleting deliverable: $e')));
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
