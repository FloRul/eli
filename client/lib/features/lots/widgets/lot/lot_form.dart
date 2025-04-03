import 'package:client/features/home/providers/projects_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/features/lots/models/lot.dart'; // Your Lot model
import 'package:client/features/lots/providers/lot_provider.dart'; // Your Lots provider

class LotForm extends ConsumerStatefulWidget {
  final Lot? initialLot; // Pass the lot if editing, null if creating

  const LotForm({super.key, this.initialLot});

  @override
  ConsumerState<LotForm> createState() => _LotFormState();
}

class _LotFormState extends ConsumerState<LotForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _numberController;
  late TextEditingController _providerController;
  bool _isLoading = false;

  bool get _isEditing => widget.initialLot != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialLot?.title ?? '');
    _numberController = TextEditingController(text: widget.initialLot?.number ?? '');
    _providerController = TextEditingController(text: widget.initialLot?.provider ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _numberController.dispose();
    _providerController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final lotData = {
        'title': _titleController.text.trim(),
        'number': _numberController.text.trim(),
        'provider': _providerController.text.trim(),
        // Add 'project_id': widget.projectId if needed for creation
        // in your backend logic/createLot method
      };

      try {
        final projectId = ref.read(currentProjectNotifierProvider);
        final notifier = ref.read(lotsProvider(projectId).notifier);
        if (_isEditing) {
          // --- Update existing Lot ---
          await notifier.updateLot(widget.initialLot!.id, lotData);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lot updated successfully!')));
          }
        } else {
          // --- Create new Lot ---
          // TODO: Add project_id to lotData if needed
          await notifier.createLot(projectId!, lotData); // Assuming createLot exists
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lot created successfully!')));
          }
        }
        if (mounted) {
          Navigator.of(context).pop(); // Close the bottom drawer on success
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving lot: $e')));
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Provides padding and makes it scrollable if content overflows
    // especially on smaller screens or when keyboard appears.
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          // Add padding to account for the keyboard if it appears
          bottom: MediaQuery.of(context).viewInsets.bottom,
          // Standard padding for the sides and top
          left: 16.0,
          right: 16.0,
          top: 20.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min, // Take minimal height needed
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Form Title ---
              Text(
                _isEditing ? 'Edit Lot' : 'Create New Lot',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // --- Title Field ---
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  hintText: 'Enter lot title',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // --- Number Field ---
              TextFormField(
                controller: _numberController,
                decoration: const InputDecoration(
                  labelText: 'Number',
                  border: OutlineInputBorder(),
                  hintText: 'Enter lot number',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a lot number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // --- Provider Field ---
              TextFormField(
                controller: _providerController,
                decoration: const InputDecoration(
                  labelText: 'Provider',
                  border: OutlineInputBorder(),
                  hintText: 'Enter provider name',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a provider';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // --- Submit Button ---
              FilledButton(
                onPressed: _isLoading ? null : _submitForm, // Disable when loading
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                child:
                    _isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                        : Text(_isEditing ? 'Update Lot' : 'Create Lot'),
              ),
              const SizedBox(height: 20), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}
