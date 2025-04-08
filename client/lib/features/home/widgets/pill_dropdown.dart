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
    return itemsProvider.when(
      data: (items) {
        List<DropdownMenuItem<int?>> dropdownItems = [];

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

        final validSelectedId = items.any((item) => item.$1 == currentSelectedId) ? currentSelectedId : null;

        if (items.isEmpty && !addNoneOption) {
          return DisablePill(text: noItemsText, showProgress: false);
        }

        return DropdownButtonFormField<int?>(
          value: validSelectedId, // Use the validated selected ID
          hint: Text(hintText),
          isExpanded: true,
          items:
              dropdownItems.isEmpty
                  ? [
                    if (addNoneOption)
                      DropdownMenuItem<int?>(
                        value: null,
                        child: Text('None', style: TextStyle(color: Colors.grey[600])),
                      ),
                  ]
                  : dropdownItems,
          onChanged: (int? newValue) {
            onSelected(newValue);
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0), // Pill shape
              borderSide: BorderSide.none, // No border outline
            ),
          ),
        );
      },
      loading: () => DisablePill(text: loadingText, showProgress: true),
      error: (error, stackTrace) {
        print('Error loading dropdown items: $error'); // Log the error
        return DisablePill(text: errorText, showProgress: false);
      },
    );
  }
}

class DisablePill extends StatelessWidget {
  const DisablePill({super.key, required this.text, required this.showProgress});

  final String text;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
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
