import 'package:client/features/contacts/models/contact.dart';
import 'package:client/features/contacts/providers/contact_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; // Import riverpod

// Adjust import paths as necessary
import 'contact_form_dialog.dart'; // Import the dialog

// Make it a ConsumerWidget to access ref
class ContactListItem extends ConsumerWidget {
  final Contact contact;

  const ContactListItem({super.key, required this.contact});

  // --- Delete Confirmation Dialog ---
  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Contact'),
          content: Text('Are you sure you want to delete ${contact.fullName}? This action cannot be undone.'), //
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false), // Return false
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true), // Return true
            ),
          ],
        );
      },
    );
  }

  // --- Delete Action ---
  Future<void> _deleteContact(BuildContext context, WidgetRef ref) async {
    final bool? confirmed = await _showDeleteConfirmationDialog(context);
    if (confirmed == true) {
      try {
        await ref.read(contactNotifierProvider.notifier).deleteContact(contact.id); //
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contact deleted')));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error deleting contact: ${e.toString()}')));
        }
      }
    }
  }

  // --- Edit Action ---
  void _editContact(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => ContactFormDialog(contactToEdit: contact), // Pass the contact
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Add ref here
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: colorScheme.primaryContainer,
        child: Text(
          contact.firstName?.isNotEmpty == true
              ? contact.firstName![0].toUpperCase()
              : //
              contact.lastName?.isNotEmpty == true
              ? contact.lastName![0].toUpperCase()
              : //
              contact.email.isNotEmpty == true
              ? contact.email[0].toUpperCase()
              : '?', //
          style: TextStyle(color: colorScheme.onPrimaryContainer),
        ),
      ),
      title: Text(contact.fullName, style: textTheme.titleMedium), //
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(contact.email), //
          if (contact.companyName != 'Unknown Company') //
            Text(contact.companyName, style: textTheme.bodySmall), //
          if (contact.cellphoneNumber != null) //
            Text('Cell: ${contact.cellphoneNumber}', style: textTheme.bodySmall), //
          if (contact.officePhoneNumber != null) //
            Text('Office: ${contact.officePhoneNumber}', style: textTheme.bodySmall), //
        ],
      ),
      // Adjust based on content, ensure enough space for buttons
      isThreeLine: true,
      // --- Add Trailing Buttons ---
      trailing: Row(
        mainAxisSize: MainAxisSize.min, // Important to keep row narrow
        children: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Contact',
            onPressed: () => _editContact(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: Colors.red[700],
            tooltip: 'Delete Contact',
            onPressed: () => _deleteContact(context, ref),
          ),
        ],
      ),
      // Keep onTap null or use it for navigating to a detailed view if you prefer
      // onTap: () { /* Navigate to detail page */ },
    );
  }
}
