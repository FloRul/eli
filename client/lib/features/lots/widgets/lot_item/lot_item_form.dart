import 'package:client/features/home/providers/projects_provider.dart';
import 'package:client/features/lots/providers/lot_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:client/features/lots/models/lot_item.dart';
import 'package:client/features/lots/models/enums.dart';

class LotItemForm extends ConsumerStatefulWidget {
  final LotItem? initialLotItem; // Pass the item if editing, null if creating
  final int parentLotId; // The ID of the parent Lot

  const LotItemForm({super.key, this.initialLotItem, required this.parentLotId});

  @override
  ConsumerState<LotItemForm> createState() => _LotItemFormState();
}

class _LotItemFormState extends ConsumerState<LotItemForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers for TextFields
  late TextEditingController _titleController;
  late TextEditingController _quantityController;
  late TextEditingController _originCountryController;
  late TextEditingController _commentsController;

  // State for DateTime? fields
  DateTime? _endManufacturingDate;
  DateTime? _readyToShipDate;
  DateTime? _plannedDeliveryDate;
  DateTime? _requiredOnSiteDate;

  // State for Enum fields
  late Incoterm _selectedIncoterm;
  late Status _selectedStatus;

  // State for Progress Sliders (store as double 0.0-100.0)
  late double _purchasingProgress;
  late double _engineeringProgress;
  late double _manufacturingProgress;

  // Date Formatter for display
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd');

  bool get _isEditing => widget.initialLotItem != null;

  @override
  void initState() {
    super.initState();
    final item = widget.initialLotItem;

    _titleController = TextEditingController(text: item?.title ?? '');
    _quantityController = TextEditingController(text: item?.quantity ?? '');
    _originCountryController = TextEditingController(text: item?.originCountry ?? '');
    _commentsController = TextEditingController(text: item?.comments ?? '');

    _endManufacturingDate = item?.endManufacturingDate;
    _readyToShipDate = item?.readyToShipDate;
    _plannedDeliveryDate = item?.plannedDeliveryDate;
    _requiredOnSiteDate = item?.requiredOnSiteDate;

    // Use provided value or a default. Ensure defaults exist in your enums.
    _selectedIncoterm = item?.incoterms ?? Incoterm.unknown;
    _selectedStatus = item?.status ?? Status.ongoing; // Default to ongoing if null

    // Sliders expect double, progress is int. Convert safely.
    _purchasingProgress = (item?.purchasingProgress ?? 0).toDouble();
    _engineeringProgress = (item?.engineeringProgress ?? 0).toDouble();
    _manufacturingProgress = (item?.manufacturingProgress ?? 0).toDouble();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quantityController.dispose();
    _originCountryController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  // Helper function to show Date Picker
  Future<void> _selectDate(BuildContext context, DateTime? initialDate, Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != initialDate) {
      setState(() {
        onDateSelected(picked);
      });
    }
  }

  // Helper to build Date Picker fields
  Widget _buildDatePickerField({
    required BuildContext context,
    required String label,
    required DateTime? selectedDate,
    required Function(DateTime) onDateSelected,
  }) {
    return InkWell(
      onTap: () => _selectDate(context, selectedDate, onDateSelected),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          // Add a small calendar icon
          suffixIcon: const Icon(Icons.calendar_today, size: 18),
        ),
        child: Text(
          selectedDate != null ? _dateFormatter.format(selectedDate) : 'Select Date',
          style: TextStyle(color: selectedDate != null ? Theme.of(context).textTheme.bodyLarge?.color : Colors.grey),
        ),
      ),
    );
  }

  // Helper to build Progress Slider fields
  Widget _buildProgressSlider({required String label, required double value, required ValueChanged<double> onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.round()}%', style: Theme.of(context).textTheme.titleSmall),
        Slider(
          value: value,
          min: 0,
          max: 100,
          divisions: 100, // Granularity
          label: '${value.round()}%',
          onChanged: onChanged,
        ),
      ],
    );
  }

  Future<void> _submitForm() async {
    // Basic check if mounted before proceeding
    if (!mounted) return;

    // No Form Key validation needed unless specific TextFields require it beyond null checks later

    setState(() {
      _isLoading = true;
    });

    // Prepare data map for Supabase, converting types as needed
    final Map<String, dynamic> itemData = {
      // Nullable String fields: Use null if empty, otherwise text
      'title': _titleController.text.trim().isEmpty ? null : _titleController.text.trim(),
      'quantity': _quantityController.text.trim().isEmpty ? null : _quantityController.text.trim(),
      'origin_country': _originCountryController.text.trim().isEmpty ? null : _originCountryController.text.trim(),
      'comments': _commentsController.text.trim().isEmpty ? null : _commentsController.text.trim(),

      // Nullable DateTime fields: Convert to ISO 8601 string or null
      'end_manufacturing_date': _endManufacturingDate?.toIso8601String(),
      'ready_to_ship_date': _readyToShipDate?.toIso8601String(),
      'planned_delivery_date': _plannedDeliveryDate?.toIso8601String(),
      'required_on_site_date': _requiredOnSiteDate?.toIso8601String(),

      // Enum fields: Convert using name or specific toJson if needed
      'incoterms': _selectedIncoterm.toJson(), // Use your toJson method
      'status': _selectedStatus.toJson(), // Use your toJson method
      // Integer fields from sliders: Round double to int
      'purchasing_progress': _purchasingProgress.round(),
      'engineering_progress': _engineeringProgress.round(),
      'manufacturing_progress': _manufacturingProgress.round(),

      // IMPORTANT: Add parent_lot_id if creating a new item
      if (!_isEditing) 'parent_lot_id': widget.parentLotId,
    };

    // Remove null value entries *if* your backend/update logic prefers that
    // itemData.removeWhere((key, value) => value == null);
    // Keep nulls if your Supabase update function handles them correctly (sets DB column to NULL)

    // try {
    //   // TODO: Handle when projectId is null
    //   final projectId = ref.read(currentProjectNotifierProvider);
    //   final notifier = ref.read(lotsProvider(projectId!).notifier);
    //   if (_isEditing) {
    //     // --- Update existing Lot Item ---
    //     await notifier.updateLotItem(widget.initialLotItem!.id, itemData);
    //     if (mounted) {
    //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lot Item updated successfully!')));
    //     }
    //   } else {
    //     // --- Create new Lot Item ---
    //     // NOTE: You need to implement `createLotItem` in your Lots notifier
    //     await notifier.createLotItem(widget.parentLotId, itemData); // Pass parentLotId and data
    //     if (mounted) {
    //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lot Item created successfully!')));
    //     }
    //   }

    //   if (mounted) {
    //     Navigator.of(context).pop(); // Close the bottom drawer on success
    //   }
    // } catch (e) {
    //   if (mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving lot item: $e')));
    //   }
    // } finally {
    //   if (mounted) {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    // Using Form is still good practice if you add more complex validation later
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0, // Adjust for keyboard + padding
            left: 16.0,
            right: 16.0,
            top: 20.0,
          ),
          child: Column(
            spacing: 16,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Form Title ---
              Text(
                _isEditing ? 'Edit Lot Item' : 'Create New Lot Item',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // --- Standard Text Fields ---
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
              ),

              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity / Unit', border: OutlineInputBorder()),
              ),

              // --- Progress Sliders ---
              _buildProgressSlider(
                label: 'Purchasing Progress',
                value: _purchasingProgress,
                onChanged: (value) => setState(() => _purchasingProgress = value),
              ),
              _buildProgressSlider(
                label: 'Engineering Progress',
                value: _engineeringProgress,
                onChanged: (value) => setState(() => _engineeringProgress = value),
              ),
              _buildProgressSlider(
                label: 'Manufacturing Progress',
                value: _manufacturingProgress,
                onChanged: (value) => setState(() => _manufacturingProgress = value),
              ),

              // --- Enum Dropdowns ---
              DropdownButtonFormField<Incoterm>(
                value: _selectedIncoterm,
                decoration: const InputDecoration(labelText: 'Incoterms', border: OutlineInputBorder()),
                items:
                    Incoterm.values.map((Incoterm incoterm) {
                      return DropdownMenuItem<Incoterm>(
                        value: incoterm,
                        child: Text(incoterm.name.toUpperCase()), // Display enum name
                      );
                    }).toList(),
                onChanged: (Incoterm? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedIncoterm = newValue;
                    });
                  }
                },
                // Add validator if needed, e.g., ensure it's not 'unknown' if that's invalid
                // validator: (value) => value == Incoterm.unknown ? 'Please select Incoterm' : null,
              ),

              DropdownButtonFormField<Status>(
                value: _selectedStatus,
                decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                items:
                    Status.values.map((Status status) {
                      return DropdownMenuItem<Status>(
                        value: status,
                        child: Text(status.displayName), // Display friendly name
                      );
                    }).toList(),
                onChanged: (Status? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedStatus = newValue;
                    });
                  }
                },
                // Status is required by model, ensure a valid one is selected
                validator: (value) => value == null ? 'Please select a status' : null,
              ),

              // --- Date Pickers ---
              _buildDatePickerField(
                context: context,
                label: 'End Manufacturing Date',
                selectedDate: _endManufacturingDate,
                onDateSelected: (date) => _endManufacturingDate = date,
              ),

              _buildDatePickerField(
                context: context,
                label: 'Ready To Ship Date',
                selectedDate: _readyToShipDate,
                onDateSelected: (date) => _readyToShipDate = date,
              ),

              _buildDatePickerField(
                context: context,
                label: 'Planned Delivery Date',
                selectedDate: _plannedDeliveryDate,
                onDateSelected: (date) => _plannedDeliveryDate = date,
              ),

              _buildDatePickerField(
                context: context,
                label: 'Required On Site Date',
                selectedDate: _requiredOnSiteDate,
                onDateSelected: (date) => _requiredOnSiteDate = date,
              ),

              // --- Other Text Fields ---
              TextFormField(
                controller: _originCountryController,
                decoration: const InputDecoration(labelText: 'Origin Country', border: OutlineInputBorder()),
              ),

              TextFormField(
                controller: _commentsController,
                decoration: const InputDecoration(
                  labelText: 'Comments',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true, // Good for multi-line
                ),
                maxLines: 3, // Allow multi-line input
              ),
              const SizedBox(height: 24),

              // --- Submit Button ---
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
                        : Text(_isEditing ? 'Update Item' : 'Create Item'),
              ),
              // No need for extra SizedBox at the end due to SingleChildScrollView padding
            ],
          ),
        ),
      ),
    );
  }
}
