import 'package:client/features/contacts/models/contact.dart';
import 'package:client/features/contacts/providers/contact_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ContactFormDialog extends HookWidget {
  final Contact? contactToEdit; // Pass null when adding a new contact
  final WidgetRef ref;
  const ContactFormDialog({super.key, this.contactToEdit, required this.ref});

  @override
  Widget build(BuildContext context) {
    // Form state
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final firstNameController = useTextEditingController(text: contactToEdit?.firstName);
    final lastNameController = useTextEditingController(text: contactToEdit?.lastName);
    final emailController = useTextEditingController(text: contactToEdit?.email);
    final cellPhoneController = useTextEditingController(text: contactToEdit?.cellphoneNumber);
    final officePhoneController = useTextEditingController(text: contactToEdit?.officePhoneNumber);
    final selectedCompanyId = useState<int?>(contactToEdit?.companyId);
    final isLoading = useState(false); // To show loading indicator on save

    // Fetch companies for the dropdown
    // Using useFuture combined with useMemoized to fetch only once per dialog instance
    final companiesFuture = useMemoized(
      () => ref.read(contactNotifierProvider.notifier).fetchCompaniesSimple(), //
      [key], // Re-fetch if the dialog key changes (effectively once per open)
    );
    final companiesSnapshot = useFuture(companiesFuture, initialData: null);

    void submitForm() async {
      if (formKey.currentState?.validate() ?? false) {
        isLoading.value = true;
        try {
          final notifier = ref.read(contactNotifierProvider.notifier); //
          if (contactToEdit == null) {
            // Add new contact
            await notifier.addContact(
              //
              email: emailController.text,
              companyId: selectedCompanyId.value!,
              firstName: firstNameController.text.isNotEmpty ? firstNameController.text : null,
              lastName: lastNameController.text.isNotEmpty ? lastNameController.text : null,
              cellphoneNumber: cellPhoneController.text.isNotEmpty ? cellPhoneController.text : null,
              officePhoneNumber: officePhoneController.text.isNotEmpty ? officePhoneController.text : null,
            );
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contact added successfully')));
            }
          } else {
            // Update existing contact
            final updatedContact = contactToEdit!.copyWith(
              //
              email: emailController.text,
              companyId: selectedCompanyId.value!,
              firstName: firstNameController.text.isNotEmpty ? firstNameController.text : null,
              lastName: lastNameController.text.isNotEmpty ? lastNameController.text : null,
              cellphoneNumber: cellPhoneController.text.isNotEmpty ? cellPhoneController.text : null,
              officePhoneNumber: officePhoneController.text.isNotEmpty ? officePhoneController.text : null,
              // Keep the existing company object if it exists, let the provider handle fetching it again if needed on update
              company: contactToEdit!.company?.id == selectedCompanyId.value! ? contactToEdit!.company : null, //
            );
            await notifier.updateContact(updatedContact); //
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contact updated successfully')));
            }
          }
          if (context.mounted) Navigator.of(context).pop(); // Close dialog on success
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
          }
        } finally {
          if (context.mounted) isLoading.value = false;
        }
      }
    }

    return AlertDialog(
      title: Text(contactToEdit == null ? 'Add Contact' : 'Edit Contact'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            spacing: 16,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              TextFormField(controller: lastNameController, decoration: const InputDecoration(labelText: 'Last Name')),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email *'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'^.+@.+\.[a-zA-Z]+$').hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: cellPhoneController,
                decoration: const InputDecoration(labelText: 'Cellphone Number'),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: officePhoneController,
                decoration: const InputDecoration(labelText: 'Office Phone Number'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              // Company Dropdown
              companiesSnapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : companiesSnapshot.hasError
                  ? Text('Error loading companies: ${companiesSnapshot.error}')
                  : DropdownButtonFormField<int>(
                    value: selectedCompanyId.value,
                    items:
                        (companiesSnapshot.data ?? [])
                            .map<DropdownMenuItem<int>>(
                              (company) => DropdownMenuItem<int>(value: company.id, child: Text(company.name)),
                            )
                            .toList(),
                    onChanged: (value) {
                      selectedCompanyId.value = value;
                    },
                    decoration: const InputDecoration(labelText: 'Company *'),
                    validator: (value) => value == null ? 'Company is required' : null,
                  ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: isLoading.value ? null : () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: isLoading.value ? null : submitForm,
          child:
              isLoading.value
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Save'),
        ),
      ],
    );
  }
}
