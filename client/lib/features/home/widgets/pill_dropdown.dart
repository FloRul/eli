import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a type alias for clarity
typedef DropdownItem = (int id, String name);

class PillDropdownWidget extends ConsumerWidget {
  final AsyncValue<List<DropdownItem>> itemsProvider;
  final int? currentSelectedId;
  final Function(int?) onSelected;
  final String hintText;
  final String loadingText;
  final String errorText;
  final String noItemsText;
  final bool addNoneOption; // Flag to add a "None" option

  const PillDropdownWidget({
    super.key,
    required this.itemsProvider,
    required this.currentSelectedId,
    required this.onSelected,
    required this.hintText,
    this.loadingText = 'Loading...',
    this.errorText = 'Error loading items',
    this.noItemsText = 'No items available',
    this.addNoneOption = true, // Default to true
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use .when to handle the different states of the AsyncValue
    return itemsProvider.when(
      data: (items) {
        // --- Build Dropdown Items ---
        List<DropdownMenuItem<int?>> dropdownItems = [];

        // Add "None" option if requested and not already selected implicitly
        if (addNoneOption) {
          dropdownItems.add(
            DropdownMenuItem<int?>(
              value: null, // Use null for the "None" option
              child: Text('None', style: TextStyle(color: Colors.grey[600])),
            ),
          );
        }

        // Add items fetched from the provider
        dropdownItems.addAll(
          items.map((item) {
            return DropdownMenuItem<int?>(
              value: item.$1, // The ID is the value
              child: Text(item.$2), // The name is displayed
            );
          }).toList(),
        );

        // Ensure the currently selected ID is valid within the available items
        // If the currentSelectedId exists, check if it's in the fetched items
        // If not, treat it as null (or handle as needed, e.g., show an error/reset)
        final validSelectedId = items.any((item) => item.$1 == currentSelectedId) ? currentSelectedId : null;

        // If there are no items and no "None" option, display text
        if (items.isEmpty && !addNoneOption) {
          return _buildDisabledPill(noItemsText);
        }

        // --- Build the Dropdown ---
        return DropdownButtonFormField<int?>(
          value: validSelectedId, // Use the validated selected ID
          hint: Text(hintText),
          isExpanded: true,
          items:
              dropdownItems.isEmpty
                  ? [
                    // Provide a dummy item if list is empty but None was requested
                    if (addNoneOption)
                      DropdownMenuItem<int?>(
                        value: null,
                        child: Text('None', style: TextStyle(color: Colors.grey[600])),
                      ),
                  ]
                  : dropdownItems,
          onChanged: (int? newValue) {
            // Allow selecting "None" which results in null
            onSelected(newValue);
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0), // Pill shape
              borderSide: BorderSide.none, // No border outline
            ),
            // filled: true,
            // fillColor: Colors.grey[200], // Background color of the pill
          ),
          // Optional: Style the dropdown menu itself
          // dropdownColor: Colors.white,
        );
      },
      loading: () => _buildDisabledPill(loadingText, showProgress: true),
      error: (error, stackTrace) {
        print('Error loading dropdown items: $error'); // Log the error
        return _buildDisabledPill(errorText);
      },
    );
  }

  // Helper widget for loading/error/no items states
  Widget _buildDisabledPill(String text, {bool showProgress = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0), // Match padding roughly
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center content
        children: [
          if (showProgress) ...[
            SizedBox(
              height: 16, // Small progress indicator
              width: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey[600]),
            ),
            const SizedBox(width: 10),
          ],
          Text(text, style: TextStyle(color: Colors.grey[600], fontSize: 16), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
