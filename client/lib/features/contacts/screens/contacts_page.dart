import 'package:client/features/contacts/models/contact.dart';
import 'package:client/features/contacts/providers/contact_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Import widgets specific to this screen
import 'widgets/contact_list_item.dart';
import 'widgets/contact_search_bar.dart';

class ContactPage extends HookConsumerWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch contacts using the provider
    final contactsAsyncValue = ref.watch(contactNotifierProvider); //
    // State for the search query
    final searchQuery = useState('');
    // Controller for the search text field
    final searchController = useTextEditingController();

    // Function to filter contacts based on the search query
    List<Contact> filterContacts(List<Contact> contacts, String query) {
      //
      if (query.isEmpty) {
        return contacts;
      }
      final lowerCaseQuery = query.toLowerCase();
      return contacts.where((contact) {
        //
        final firstNameMatch = contact.firstName?.toLowerCase().contains(lowerCaseQuery) ?? false; //
        final lastNameMatch = contact.lastName?.toLowerCase().contains(lowerCaseQuery) ?? false; //
        final emailMatch = contact.email.toLowerCase().contains(lowerCaseQuery); //
        return firstNameMatch || lastNameMatch || emailMatch;
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        // Optional: Add refresh button
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(contactNotifierProvider.notifier).refreshContacts(), //
            tooltip: 'Refresh Contacts',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to Add Contact screen
            },
            tooltip: 'Add Contact',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          ContactSearchBar(
            controller: searchController,
            onChanged: (value) {
              searchQuery.value = value; // Update search query state
            },
          ),
          // Contact List Area
          Expanded(
            // Handle loading, error, and data states from the provider
            child: contactsAsyncValue.when(
              data: (contacts) {
                final filteredContacts = filterContacts(contacts, searchQuery.value); // Filter the contacts

                if (filteredContacts.isEmpty) {
                  return Center(
                    child: Text(searchQuery.value.isEmpty ? 'No contacts found.' : 'No contacts match your search.'),
                  );
                }

                // Display the list using ListView.builder
                return ListView.builder(
                  itemCount: filteredContacts.length,
                  itemBuilder: (context, index) {
                    final contact = filteredContacts[index]; //
                    return ContactListItem(contact: contact);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error:
                  (error, stackTrace) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Failed to load contacts: $error', textAlign: TextAlign.center),
                    ),
                  ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Contact screen
        },
        tooltip: 'Add Contact',
        child: const Icon(Icons.add),
      ),
    );
  }
}
