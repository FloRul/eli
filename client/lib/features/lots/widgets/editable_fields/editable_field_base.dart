import 'package:flutter/material.dart';

/// Base class for all editable field types
abstract class EditableFieldBase<T> extends StatefulWidget {
  /// The current value of the field
  final T value;

  /// Builder for the display widget when not editing
  final Widget Function(T value) displayBuilder;

  /// Optional field label displayed in edit mode
  final String? label;

  /// Callback when the value is updated
  final Future<void> Function(T newValue) onUpdate;

  const EditableFieldBase({
    super.key,
    required this.value,
    required this.displayBuilder,
    required this.onUpdate,
    this.label,
  });
}

/// Base state for all editable fields providing common functionality
abstract class EditableFieldBaseState<T, W extends EditableFieldBase<T>> extends State<W> {
  // State management
  bool isEditing = false;
  bool isSubmitting = false;
  late OverlayEntry? overlayEntry;
  final LayerLink layerLink = LayerLink();
  final GlobalKey fieldKey = GlobalKey();

  // Current working value
  late dynamic tempValue;

  @override
  void initState() {
    super.initState();
    tempValue = widget.value;
    overlayEntry = null;
    initializeController();
  }

  /// Initialize any controllers needed by the specific field type
  void initializeController();
  
  /// Clean up any controllers when the widget is disposed
  void disposeController();

  @override
  void didUpdateWidget(W oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      tempValue = widget.value;
      updateControllerValue();
    }
  }
  
  /// Update the controller value when the widget's value changes
  void updateControllerValue();

  @override
  void dispose() {
    removeOverlay();
    disposeController();
    super.dispose();
  }
  
  /// Show the editor overlay
  void showEditor() {
    setState(() {
      isEditing = true;
      tempValue = widget.value;
      updateControllerValue();
    });
    
    // Create and show the overlay
    overlayEntry = createOverlayEntry();
    Overlay.of(context).insert(overlayEntry!);
    
    // Request focus for immediate editing
    requestInitialFocus();
  }
  
  /// Request focus when the editor is first shown
  void requestInitialFocus();
  
  /// Cancel editing and remove the overlay
  void cancelEdit() {
    setState(() {
      isEditing = false;
    });
    removeOverlay();
  }
  
  /// Remove the overlay entry if it exists
  void removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry?.remove();
      overlayEntry = null;
    }
  }
  
  /// Create the overlay entry that will contain the editor
  OverlayEntry createOverlayEntry() {
    // Measure the render box to determine the position and size
    final RenderBox renderBox = fieldKey.currentContext!.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    
    // Compute the width - we want to make sure the overlay is big enough
    final double editorWidth = size.width > 150 ? size.width : 150.0;
    
    return OverlayEntry(
      builder: (context) => Positioned(
        width: editorWidth,
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8),
            child: buildEditorContent(),
          ),
        ),
      ),
    );
  }
  
  /// Build the content for this specific editor type
  Widget buildEditorContent();
  
  /// Save the changes to the field
  Future<void> saveChanges() async {
    if (isSubmitting) return;
    
    setState(() {
      isSubmitting = true;
    });
    
    try {
      // Convert temp value to the correct type before saving
      T valueToSave = prepareValueForSave() as T;
      
      // Call the update callback
      await widget.onUpdate(valueToSave);
      
      if (mounted) {
        setState(() {
          isEditing = false;
          isSubmitting = false;
        });
        removeOverlay();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
        // Show error snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating field: $e'))
        );
      }
    }
  }
  
  /// Prepare the current temp value for saving
  dynamic prepareValueForSave();
  
  /// Build the buttons for editor actions (cancel/save)
  Widget buildEditorActions() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: isSubmitting ? null : cancelEdit,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: isSubmitting ? null : saveChanges,
            child: isSubmitting 
              ? const SizedBox(
                  width: 16, 
                  height: 16, 
                  child: CircularProgressIndicator(strokeWidth: 2)
                )
              : const Text('Save'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: GestureDetector(
        key: fieldKey,
        onTap: isEditing ? null : showEditor,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.transparent,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: widget.displayBuilder(widget.value)),
              const SizedBox(width: 4),
              Icon(
                Icons.edit,
                size: 14,
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}