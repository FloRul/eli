import 'package:flutter/material.dart';

class HomeSearchWidget extends StatelessWidget {
  const HomeSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          constraints: BoxConstraints(maxWidth: 400, minWidth: 200, maxHeight: 36, minHeight: 36),
          controller: controller,
          padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
          elevation: WidgetStatePropertyAll<double>(0),
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            controller.openView();
          },
          leading: const Icon(Icons.search),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        // Implement actual search suggestions based on controller.text
        // Example: Filter a list of items or call an API
        if (controller.text.isEmpty) {
          return [Padding(padding: const EdgeInsets.all(8.0), child: Text('Enter search term'))];
        }
        return List<ListTile>.generate(5, (int index) {
          final String item = 'Result for "${controller.text}" $index';
          return ListTile(
            title: Text(item),
            onTap: () {
              // Handle suggestion tap - maybe navigate or filter
              controller.closeView(item); // Close suggestion view, optionally updating text
              // Example: context.go('/search?q=${Uri.encodeComponent(item)}');
              FocusScope.of(context).unfocus(); // Hide keyboard
            },
          );
        });
      },
    );
  }
}
