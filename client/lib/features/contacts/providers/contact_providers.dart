import 'dart:async';
import 'package:client/core/providers/supabase_provider.dart';
import 'package:client/features/contacts/models/company.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Make sure your global client and models are accessible
import 'package:client/features/contacts/models/contact.dart';

part 'contact_providers.g.dart';

@Riverpod(keepAlive: true)
class ContactNotifier extends _$ContactNotifier {
  @override
  FutureOr<List<Contact>> build() async {
    return _fetchContacts();
  }

  // Internal method to fetch contacts
  Future<List<Contact>> _fetchContacts() async {
    try {
      final response = await supabase // Use global client
          .from('contacts')
          .select('*, companies(id, name)')
          .order('last_name', ascending: true)
          .order('first_name', ascending: true);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => Contact.fromJson(json)).toList();
    } catch (e, stackTrace) {
      print('Error fetching contacts: $e\n$stackTrace');
      // Re-throw to allow AsyncValue.guard or build() to catch it
      throw Exception('Failed to load contacts: $e');
    }
  }

  // Method to fetch companies (doesn't directly modify the primary state)
  // The UI will call this method when needed.
  Future<List<Company>> fetchCompaniesSimple() async {
    try {
      final response = await supabase // Use global client
          .from('companies')
          .select('id, name')
          .order('name', ascending: true);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => Company.fromJson(json)).toList();
    } catch (e, stackTrace) {
      print('Error fetching simple companies: $e\n$stackTrace');
      throw Exception('Failed to load companies: $e');
    }
  }

  // --- Mutation Methods ---

  Future<void> addContact({
    required String email,
    required int companyId,
    String? firstName,
    String? lastName,
    String? cellphoneNumber,
    String? officePhoneNumber,
  }) async {
    // Optimistic update or loading state (optional)
    // state = const AsyncLoading(); // You could show loading on the list
    try {
      final response =
          await supabase // Use global client
              .from('contacts')
              .insert({
                'email': email,
                'company_id': companyId,
                'first_name': firstName,
                'last_name': lastName,
                'cellphone_number': cellphoneNumber,
                'office_phone_number': officePhoneNumber,
              })
              .select('*, companies(id, name)') // Return the new contact
              .single();

      final newContact = Contact.fromJson(response);

      // Update state directly if current state is data
      final currentState = state;
      if (currentState is AsyncData<List<Contact>>) {
        state = AsyncData([...currentState.value, newContact]..sort(_sortContacts)); // Add and sort
      } else {
        // If state wasn't data (e.g., error), refetch
        await refreshContacts();
      }
    } catch (e, stackTrace) {
      print('Error adding contact: $e\n$stackTrace');
      // Optionally reset state to previous state or set error state explicitly
      // state = AsyncError(e, stackTrace);
      throw Exception('Failed to add contact: $e'); // Re-throw for UI handling
    }
  }

  Future<void> updateContact(Contact contactToUpdate) async {
    try {
      final response =
          await supabase // Use global client
              .from('contacts')
              .update({
                'email': contactToUpdate.email,
                'company_id': contactToUpdate.companyId,
                'first_name': contactToUpdate.firstName,
                'last_name': contactToUpdate.lastName,
                'cellphone_number': contactToUpdate.cellphoneNumber,
                'office_phone_number': contactToUpdate.officePhoneNumber,
              })
              .eq('id', contactToUpdate.id)
              .select('*, companies(id, name)') // Return the updated contact
              .single();

      final updatedContact = Contact.fromJson(response);

      // Update state directly
      final currentState = state;
      if (currentState is AsyncData<List<Contact>>) {
        state = AsyncData(
          [
            for (final contact in currentState.value)
              if (contact.id == updatedContact.id) updatedContact else contact,
          ]..sort(_sortContacts),
        ); // Replace and sort
      } else {
        await refreshContacts(); // Refetch if not in data state
      }
    } catch (e, stackTrace) {
      print('Error updating contact: $e\n$stackTrace');
      throw Exception('Failed to update contact: $e');
    }
  }

  Future<void> deleteContact(int id) async {
    try {
      await supabase // Use global client
          .from('contacts')
          .delete()
          .eq('id', id);

      // Update state directly
      final currentState = state;
      if (currentState is AsyncData<List<Contact>>) {
        state = AsyncData(
          currentState.value.where((contact) => contact.id != id).toList(),
        ); // No need to re-sort after removal
      } else {
        await refreshContacts(); // Refetch if not in data state
      }
    } catch (e, stackTrace) {
      print('Error deleting contact: $e\n$stackTrace');
      if (e is PostgrestException && e.code == '23503') {
        throw Exception('Cannot delete contact. It might be linked to other records.');
      }
      throw Exception('Failed to delete contact: $e');
    }
  }

  // --- Helper Methods ---

  // Public method to allow manual refresh from UI
  Future<void> refreshContacts() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchContacts());
  }

  // Helper for sorting contacts consistently
  int _sortContacts(Contact a, Contact b) {
    int cmp = (a.lastName ?? '').toLowerCase().compareTo((b.lastName ?? '').toLowerCase());
    if (cmp == 0) {
      cmp = (a.firstName ?? '').toLowerCase().compareTo((b.firstName ?? '').toLowerCase());
    }
    if (cmp == 0) {
      cmp = a.email.toLowerCase().compareTo(b.email.toLowerCase());
    }
    return cmp;
  }
}
