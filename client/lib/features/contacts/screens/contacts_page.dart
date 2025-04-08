import 'package:client/features/contacts/models/contact.dart';
import 'package:client/features/contacts/providers/contact_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Import your providers and models - adjust paths as necessary

// Import widgets specific to this screen
import 'widgets/contact_list_item.dart';
import 'widgets/contact_search_bar.dart';
import 'widgets/contact_form_dialog.dart'; // Import the dialog

class ContactPage extends HookConsumerWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsyncValue = ref.watch(contactNotifierProvider);
    final searchQuery = useState('');
    final searchController = useTextEditingController();

    List<Contact> filterContacts(List<Contact> contacts, String query) {
      if (query.isEmpty) {
        return contacts;
      }
      final lowerCaseQuery = query.toLowerCase();
      return contacts.where((contact) {
        final firstNameMatch = contact.firstName?.toLowerCase().contains(lowerCaseQuery) ?? false;
        final lastNameMatch = contact.lastName?.toLowerCase().contains(lowerCaseQuery) ?? false;
        final emailMatch = contact.email.toLowerCase().contains(lowerCaseQuery);
        return firstNameMatch || lastNameMatch || emailMatch;
      }).toList();
    }

    // --- Function to show the add/edit dialog ---
    void showContactFormDialog({Contact? contact}) {
      showDialog(
        context: context,
        // Use builder to ensure the dialog rebuilds if needed, though less critical here
        builder: (_) => Consumer(builder: (context, ref, child) => ContactFormDialog(contactToEdit: contact, ref: ref)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(contactNotifierProvider.notifier).refreshContacts(),
            tooltip: 'Refresh Contacts',
          ),
          // Remove the Add button from AppBar if using FAB
        ],
      ),
      body: Column(
        children: [
          ContactSearchBar(
            controller: searchController,
            onChanged: (value) {
              searchQuery.value = value;
            },
          ),
          Expanded(
            child: contactsAsyncValue.when(
              data: (contacts) {
                final filteredContacts = filterContacts(contacts, searchQuery.value);

                if (filteredContacts.isEmpty) {
                  return Center(
                    child: Text(searchQuery.value.isEmpty ? 'No contacts found.' : 'No contacts match your search.'),
                  );
                }

                return RefreshIndicator(
                  // Optional: Add pull-to-refresh
                  onRefresh: () => ref.read(contactNotifierProvider.notifier).refreshContacts(),
                  child: ListView.builder(
                    itemCount: filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = filteredContacts[index];
                      // Use key for better list item state management if needed
                      // return ContactListItem(key: ValueKey(contact.id), contact: contact);
                      return ContactListItem(contact: contact);
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error:
                  (error, stackTrace) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        // Allow button below text
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Failed to load contacts: $error', textAlign: TextAlign.center),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => ref.read(contactNotifierProvider.notifier).refreshContacts(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
            ),
          ),
        ],
      ),
      // --- Add FloatingActionButton ---
      floatingActionButton: FloatingActionButton(
        onPressed: () => showContactFormDialog(), // Show dialog without contact
        tooltip: 'Add Contact',
        child: const Icon(Icons.add),
      ),
    );
  }
}
