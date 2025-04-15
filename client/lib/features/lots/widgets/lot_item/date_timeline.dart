import 'package:client/features/lots/models/timeline_entry.dart';
import 'package:flutter/material.dart';

/// Callback type for when a date is updated.
/// Passes the entry being updated and the new selected date.
typedef DateUpdateCallback = void Function(TimelineEntry entry, DateTime newDate);

/// A timeline widget that displays multiple dates in a vertical timeline
/// and allows editing dates via a date picker if a callback is provided.
class DateTimeline extends StatelessWidget {
  final List<TimelineEntry> entries;
  final Color? primaryColor;
  final DateUpdateCallback? onDateUpdate; // Callback for date changes

  const DateTimeline({
    super.key,
    required this.entries,
    this.primaryColor,
    this.onDateUpdate, // Make callback optional
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color = primaryColor ?? colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        entries.length,
        (index) => _buildTimelineItem(
          context,
          entries[index],
          isFirst: index == 0,
          isLast: index == entries.length - 1,
          color: color,
          onDateUpdate: onDateUpdate, // Pass callback down
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    TimelineEntry entry, {
    required bool isFirst,
    required bool isLast,
    required Color color,
    required DateUpdateCallback? onDateUpdate, // Receive callback
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine colors based on entry state (same as before)
    final dotColor =
        entry.isHighlighted
            ? color
            : entry.isPassed
            ? color.withAlpha(128) // Use withAlpha for clarity
            : Colors.grey.shade400;

    final lineColor = entry.isPassed ? color.withAlpha(128) : Colors.grey.shade300;
    final textColor =
        entry.isHighlighted
            ? color
            : entry.isPassed
            ? colorScheme.onSurface.withAlpha(230) // ~90% opacity
            : colorScheme.onSurface.withAlpha(153); // ~60% opacity

    // --- Date Picker Logic ---
    Future<void> selectDate() async {
      // Parse the current date string. Handle potential errors.
      // ASSUMPTION: Date format is parsable by DateTime.tryParse (e.g., YYYY-MM-DD)
      // For more robust parsing, use the intl package:
      // final format = DateFormat('dd MMM yyyy'); // Or your specific format
      // DateTime? initial = format.tryParse(entry.date);
      DateTime? initial = DateTime.tryParse(entry.date);
      final now = DateTime.now();

      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initial ?? now, // Fallback to now if parsing fails
        firstDate: DateTime(now.year - 5, now.month, now.day), // Example range: 5 years ago
        lastDate: DateTime(now.year + 5, now.month, now.day), // Example range: 5 years from now
      );

      if (picked != null && onDateUpdate != null) {
        // Call the callback with the original entry and the new DateTime
        onDateUpdate(entry, picked);
        // The parent widget is responsible for updating the state
        // and formatting the DateTime back to a string for the next build.
      }
    }
    // --- End Date Picker Logic ---

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - Label (unchanged)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 4.0),
            child: Text(
              entry.label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: entry.isHighlighted ? FontWeight.bold : FontWeight.w500,
                color: textColor,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),

        // Center - Timeline line and dot (unchanged)
        SizedBox(
          width: 30,
          // Slightly increase height to better accommodate potential icon line height
          height: 36,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Vertical connecting line
              Positioned(top: 0, bottom: 0, left: 14, width: 2, child: Container(color: lineColor)),
              // Timeline dot
              Positioned(
                left: 10,
                top: 12, // Adjust vertical position if needed
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Right side - Date (MODIFIED)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 4.0),
            // Use InkWell only if callback is provided
            child: InkWell(
              onTap: onDateUpdate != null ? selectDate : null, // Enable tap only if callback exists
              borderRadius: BorderRadius.circular(4), // Match decoration border radius
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration:
                    entry.isHighlighted
                        ? BoxDecoration(
                          color: color.withAlpha(26), // ~10% opacity
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: color.withAlpha(77), width: 1), // ~30% opacity
                        )
                        : null,
                child: Row(
                  // Use Row to place text and icon
                  mainAxisSize: MainAxisSize.min, // Prevent Row from expanding unnecessarily
                  children: [
                    Text(
                      entry.date,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: entry.isHighlighted ? FontWeight.bold : FontWeight.w400,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// --- Helper extension for Color ---
// (Useful if you frequently need to modify color components like alpha/opacity)
extension ColorAlpha on Color {
  Color withValues({int? alpha, int? red, int? green, int? blue}) {
    return Color.fromARGB(alpha ?? this.alpha, red ?? this.red, green ?? this.green, blue ?? this.blue);
  }
}

// --- Example Usage (in a StatefulWidget) ---

class MyTimelinePage extends StatefulWidget {
  const MyTimelinePage({super.key});

  @override
  State<MyTimelinePage> createState() => _MyTimelinePageState();
}

class _MyTimelinePageState extends State<MyTimelinePage> {
  late List<TimelineEntry> _timelineEntries;

  @override
  void initState() {
    super.initState();
    // Initial data - IMPORTANT: Use a consistent, parsable date format (like YYYY-MM-DD)
    _timelineEntries = [
      TimelineEntry(label: 'Order Placed', date: '2024-03-15', isPassed: true),
      TimelineEntry(label: 'Shipped', date: '2024-03-20', isPassed: true),
      TimelineEntry(label: 'Est. Delivery', date: '2024-04-25', isHighlighted: true),
      TimelineEntry(label: 'Delivered', date: '2024-04-28'),
    ];
  }

  // Function to handle the date update from the timeline
  void _handleDateUpdate(TimelineEntry entry, DateTime newDate) {
    setState(() {
      // Find the index of the entry to update
      final index = _timelineEntries.indexWhere((e) => e.label == entry.label); // Assumes labels are unique
      if (index != -1) {
        // Format the new date back into the desired string format
        // Using basic formatting here. Use intl package for better control.
        final formattedDate =
            "${newDate.year}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}";
        // final formattedDate = DateFormat('yyyy-MM-dd').format(newDate); // Example with intl

        // Update the entry in the list (using copyWith if available, or creating new)
        _timelineEntries[index] = _timelineEntries[index].copyWith(date: formattedDate);

        // Optional: You might want to re-evaluate isPassed/isHighlighted based on the new date
        // e.g., _recalculateTimelineStates();
      }
    });
    print("Updated '${entry.label}' to: $newDate");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editable Timeline')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DateTimeline(
          entries: _timelineEntries,
          primaryColor: Colors.deepPurple, // Example color
          onDateUpdate: _handleDateUpdate, // Pass the handler function
        ),
      ),
    );
  }
}
