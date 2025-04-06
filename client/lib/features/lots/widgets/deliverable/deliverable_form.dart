import 'package:client/features/home/providers/projects_provider.dart';
import 'package:client/features/lots/models/deliverable.dart';
import 'package:client/features/lots/providers/lot_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DeliverableForm extends ConsumerStatefulWidget {
  final Deliverable? initialDeliverable;
  final int parentLotId;

  const DeliverableForm({super.key, this.initialDeliverable, required this.parentLotId});

  @override
  ConsumerState<DeliverableForm> createState() => _DeliverableFormState();
}

class _DeliverableFormState extends ConsumerState<DeliverableForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  DateTime? _dueDate;
  late bool _isReceived;
  bool _isLoading = false;

  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd');
  bool get _isEditing => widget.initialDeliverable != null;

  @override
  void initState() {
    super.initState();
    final deliverable = widget.initialDeliverable;
    _titleController = TextEditingController(text: deliverable?.title ?? '');
    _dueDate = deliverable?.dueDate;
    _isReceived = deliverable?.isReceived ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_dueDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a due date.')));
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final deliverableData = {
        'title': _titleController.text.trim(),
        'due_date': _dueDate!.toIso8601String(),
        'is_received': _isReceived,
        // parent_lot_id is added in the provider method for create
      };

      final projectId = ref.read(currentProjectNotifierProvider);
      if (projectId == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: Project not selected.')));
        setState(() {
          _isLoading = false;
        });
        return;
      }

      try {
        final notifier = ref.read(lotsProvider(projectId).notifier);
        if (_isEditing) {
          await notifier.updateDeliverable(widget.initialDeliverable!.id, deliverableData);
          if (mounted)
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deliverable updated!')));
        } else {
          await notifier.createDeliverable(widget.parentLotId, deliverableData);
          if (mounted)
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deliverable created!')));
        }
        if (mounted) Navigator.of(context).pop();
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        if (mounted)
          setState(() {
            _isLoading = false;
          });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          left: 16.0,
          right: 16.0,
          top: 20.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isEditing ? 'Edit Deliverable' : 'Add Deliverable',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Due Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today, size: 18),
                  ),
                  child: Text(
                    _dueDate != null ? _dateFormatter.format(_dueDate!) : 'Select Date',
                    style: TextStyle(
                      color: _dueDate != null ? Theme.of(context).textTheme.bodyLarge?.color : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Received'),
                value: _isReceived,
                onChanged: (value) => setState(() => _isReceived = value),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                child:
                    _isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                        : Text(_isEditing ? 'Update Deliverable' : 'Add Deliverable'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
