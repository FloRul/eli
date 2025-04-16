import 'package:flutter/material.dart';
import 'package:client/features/lots/models/timeline_entry.dart'; // Assuming path is correct
import 'package:intl/intl.dart';

// Callback type remains the same
typedef DateUpdateCallback = void Function(TimelineEntry entry, DateTime newDate);

class DateTimeline extends StatelessWidget {
  final List<TimelineEntry> entries;
  final DateUpdateCallback? onDateUpdate;
  final bool showTodayIndicator;

  // --- Style Constants ---
  static const double _dotSize = 10.0;
  static const double _dotBorderSize = 1.5;

  // Ensure item height is enough for dot, border, and some spacing
  static const double _verticalItemHeight = 36.0;

  // Horizontal positioning within the center SizedBox(width: _centerWidth)
  static const double _centerWidth = 30.0;
  static const double _lineHorizontalPosition = (_centerWidth / 2) - 1; // Center the line (width 2)
  static const double _dotHorizontalPosition = (_centerWidth - _dotSize) / 2; // Center the dot

  // Vertical position for the center of the dot
  static const double _dotVerticalPosition = (_verticalItemHeight - _dotSize) / 2;

  const DateTimeline({super.key, required this.entries, this.onDateUpdate, this.showTodayIndicator = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = colorScheme.primary;
    // *** Get Secondary Color ***
    final secondaryColor = colorScheme.secondary;
    final futureColor = Colors.grey.shade400; // Define future color
    final futureTextColor = colorScheme.onSurface.withAlpha(153);

    // --- 1. Sorting (remains the same) ---
    final sortedEntries = List<TimelineEntry>.from(entries);
    sortedEntries.sort((a, b) {
      if (a.date == null && b.date == null) return 0;
      if (a.date == null) return 1; // Null dates go last (future)
      if (b.date == null) return -1;
      return a.date!.compareTo(b.date!);
    });

    // --- 2. Find Today's Position (remains similar) ---
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    int todayIndicatorIndex = -1; // Default: don't show or not applicable yet

    if (showTodayIndicator) {
      todayIndicatorIndex = -2; // Assume today is before all entries initially
      for (int i = 0; i < sortedEntries.length; i++) {
        final entryDate = sortedEntries[i].date;
        if (entryDate == null) {
          break; // Stop searching, today is before this null-dated (future) entry
        }
        // Use `isSameDateOrBefore` extension for clarity
        if (entryDate.isSameDateOrBefore(today)) {
          todayIndicatorIndex = i; // Today is at least after this entry
        } else {
          // Found the first entry *after* today, so break
          break;
        }
      }
      if (sortedEntries.isEmpty) {
        todayIndicatorIndex = -2; // Needs the 'before all' handling if empty
      }
    }

    // --- 3. Build Widgets ---
    List<Widget> children = [];
    final bool todayGoesFirst = showTodayIndicator && todayIndicatorIndex == -2;

    // A. Add indicator *before* all items if needed
    if (todayGoesFirst) {
      final bool isAlsoLastVisualElement = sortedEntries.isEmpty;
      // Determine line color below the "Today" indicator
      final Color nextItemLineColor =
          sortedEntries.isNotEmpty
              ? _getLineColor(sortedEntries[0], today, secondaryColor, futureColor)
              : futureColor; // If no items follow, use future color for stub

      children.add(
        _buildTodayIndicator(
          context,
          today: today,
          dotColor: secondaryColor, // Today uses secondary color
          lineTopColor: secondaryColor, // Not drawn, but pass secondary for consistency
          lineBottomColor: nextItemLineColor,
          isFirstIndicator: true,
          isLastIndicator: isAlsoLastVisualElement,
        ),
      );
    }

    // B. Add Timeline Items and potentially Today Indicator *between* items
    for (int i = 0; i < sortedEntries.length; i++) {
      final entry = sortedEntries[i];
      final bool isFirstItemInList = i == 0;
      final bool isLastItemInList = i == sortedEntries.length - 1;

      // Determine if this item is visually the first/last element in the combined list
      final bool isFirstVisualElement = isFirstItemInList && !todayGoesFirst;
      // It's the last visual element if it's the last item *and* today doesn't go after it
      final bool isLastVisualElement = isLastItemInList && !(showTodayIndicator && i == todayIndicatorIndex);

      children.add(
        _buildTimelineItem(
          context,
          entry,
          today: today,
          isFirstVisual: isFirstVisualElement, // Pass visual position
          isLastVisual: isLastVisualElement, // Pass visual position
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
          futureColor: futureColor,
          futureTextColor: futureTextColor,
          onDateUpdate: onDateUpdate,
          // Pass flag indicating if Today indicator immediately precedes this item
          precededByTodayIndicator: todayGoesFirst && isFirstItemInList,
        ),
      );

      // Add indicator *after* the current item if needed
      if (showTodayIndicator && i == todayIndicatorIndex && todayIndicatorIndex != -2) {
        final bool isAlsoLastVisualElement =
            isLastItemInList; // Today indicator is last visual element if the item it follows is last
        final Color prevItemLineColor = _getLineColor(entry, today, secondaryColor, futureColor);
        final Color nextItemLineColor;
        if (isAlsoLastVisualElement) {
          // If this is the last indicator, the bottom line color doesn't visually matter much
          nextItemLineColor = futureColor; // Or secondaryColor, consistent stub color needed
        } else {
          nextItemLineColor = _getLineColor(sortedEntries[i + 1], today, secondaryColor, futureColor);
        }

        children.add(
          _buildTodayIndicator(
            context,
            today: today,
            dotColor: secondaryColor, // Today uses secondary color
            lineTopColor: prevItemLineColor, // Color determined by item above
            lineBottomColor: nextItemLineColor, // Color determined by item below
            isFirstIndicator: false, // Never the first if in this loop
            isLastIndicator: isAlsoLastVisualElement,
          ),
        );
      }
    }

    return Column(
      // Use CrossAxisAlignment.stretch if you want children to fill width,
      // otherwise start might be fine.
      crossAxisAlignment: CrossAxisAlignment.stretch, // Try stretch
      children: children,
    );
  }

  // --- Helper Methods ---

  // Determines the color for lines based on the *following* item's date state
  Color _getLineColor(TimelineEntry entry, DateTime today, Color pastTodayColor, Color futureColor) {
    final entryDate = entry.date;
    // Line color reflects the state *leading up to* this entry.
    // So, if the entry date is today or past, the line leading to it is past/today color.
    // If the entry date is null or future, the line leading to it is future color.
    if (entryDate == null || entryDate.isAfter(today)) {
      return futureColor;
    } else {
      // Entry is today or in the past
      return pastTodayColor;
    }
    // Note: Highlight status doesn't affect line color in this scheme.
  }

  Widget _buildTimelineItem(
    BuildContext context,
    TimelineEntry entry, {
    required DateTime today,
    required bool isFirstVisual,
    required bool isLastVisual,
    required Color primaryColor, // For future highlighted
    required Color secondaryColor, // For past/today
    required Color futureColor, // For future lines/dots
    required Color futureTextColor,
    required DateUpdateCallback? onDateUpdate,
    required bool precededByTodayIndicator, // Flag if Today indicator is right above
  }) {
    final theme = Theme.of(context);
    final entryDate = entry.date;

    // Determine state & colors based on the NEW scheme
    final bool isPastOrToday = entryDate != null && entryDate.isSameDateOrBefore(today);
    final bool isFuture = entryDate == null || entryDate.isAfter(today);
    // Highlight takes precedence only if item is in the future
    final bool useHighlightColor = entry.isHighlighted && isFuture;

    final Color itemDotColor;
    final Color itemTextColor;
    final Color lineConnectorColor = _getLineColor(
      entry,
      today,
      secondaryColor,
      futureColor,
    ); // Use helper for consistency

    FontWeight itemFontWeight = FontWeight.w400; // Default future weight

    if (useHighlightColor) {
      itemDotColor = primaryColor;
      itemTextColor = primaryColor;
      itemFontWeight = FontWeight.bold;
    } else if (isPastOrToday) {
      itemDotColor = secondaryColor;
      itemTextColor = secondaryColor; // Use secondary for text too
      itemFontWeight = FontWeight.w500; // Slightly bolder for past/today
      if (entry.isHighlighted) {
        // If highlighted and past/today, keep secondary but make bold
        itemFontWeight = FontWeight.bold;
      }
      // Make exactly "Today" bold as well if not otherwise highlighted
      if (entryDate.isSameDateAs(today)) {
        itemFontWeight = FontWeight.bold;
      }
    } else {
      // Future and not highlighted
      itemDotColor = futureColor;
      itemTextColor = futureTextColor;
      // itemFontWeight remains FontWeight.w400
    }

    Future<void> selectDate() async {
      if (onDateUpdate == null) return;
      final now = DateTime.now();
      DateTime initial = entry.date ?? now;
      final DateTime firstSelectable = DateTime(now.year - 10);
      final DateTime lastSelectable = DateTime(now.year + 10);
      if (initial.isBefore(firstSelectable)) initial = firstSelectable;
      if (initial.isAfter(lastSelectable)) initial = lastSelectable;

      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: firstSelectable,
        lastDate: lastSelectable,
      );
      if (picked != null) {
        onDateUpdate(entry, picked);
      }
    }

    // Line drawing logic: Determine where the line segment starts and ends vertically
    double lineTop = 0;
    double lineBottom = 0;

    if (isFirstVisual) {
      // If it's the very first visual element, line only goes downwards from dot center
      lineTop = _dotVerticalPosition + (_dotSize / 2);
      lineBottom = 0; // Extends to bottom unless also last
    } else {
      // If not the first, line starts from the top edge
      lineTop = 0;
      lineBottom = 0; // Default extends to bottom
    }

    if (isLastVisual) {
      // If it's the last visual element, line ends at dot center
      lineBottom = _dotVerticalPosition + (_dotSize / 2);
      // If it's both first and last, lineTop is already set, lineBottom overrides
    }

    // Safety check: Ensure top is never below bottom
    if (lineTop > _verticalItemHeight - lineBottom) {
      lineTop = (_verticalItemHeight - lineBottom) / 2; // Adjust if calculation somehow inverted
      // Or handle single item case explicitly: line shouldn't be drawn
    }
    // Special case: If it is the *only* item (first and last), draw no line.
    bool drawLine = !(isFirstVisual && isLastVisual);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // --- Left side - Label ---
        Expanded(
          child: Text(
            entry.label,
            style: TextStyle(fontSize: 16, fontWeight: itemFontWeight, color: itemTextColor),
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // --- Center - Line and Dot ---
        SizedBox(
          width: _centerWidth,
          height: _verticalItemHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Vertical Line Segment
              if (drawLine) // Only draw line if not the single only item
                Positioned(
                  top: lineTop, // Use calculated top position
                  bottom: lineBottom, // Use calculated bottom position
                  left: _lineHorizontalPosition,
                  width: 2,
                  child: Container(color: lineConnectorColor), // Use calculated line color
                ),
              // Dot
              Positioned(
                left: _dotHorizontalPosition, // Centered horizontally
                top: _dotVerticalPosition, // Centered vertically
                child: Container(
                  width: _dotSize,
                  height: _dotSize,
                  decoration: BoxDecoration(
                    color: itemDotColor, // Use calculated dot color
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.canvasColor, // Use theme background for border
                      width: _dotBorderSize,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // --- Right side - Date ---
        Expanded(
          child: InkWell(
            // Add splash/highlight effects if desired
            splashColor: itemTextColor.withValues(alpha: 0.1),
            highlightColor: itemTextColor.withValues(alpha: 0.05),
            onTap: onDateUpdate != null ? selectDate : null,
            borderRadius: BorderRadius.circular(4),
            child: Text(
              entry.date != null ? DateFormat.yMMMd().format(entry.date!) : 'N/A',
              style: TextStyle(
                fontSize: 16,
                fontWeight: itemFontWeight, // Use determined weight
                color: itemTextColor, // Use determined color
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTodayIndicator(
    BuildContext context, {
    required DateTime today,
    required Color dotColor, // Should be secondaryColor passed in
    required Color lineTopColor, // Color from item above
    required Color lineBottomColor, // Color for line connecting to item below
    required bool isFirstIndicator, // True if today is before all items
    required bool isLastIndicator, // True if today is after all items
  }) {
    final theme = Theme.of(context);
    final textStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold, // Today is always bold
      color: dotColor, // Use the passed secondary color
    );

    // Line drawing logic for Today Indicator
    // Top line segment (connects from item above down to Today dot)
    final bool drawTopLine = !isFirstIndicator;
    final double topSegmentTop = 0;
    final double topSegmentBottom = _dotVerticalPosition + (_dotSize / 2);

    // Bottom line segment (connects from Today dot down to item below)
    final bool drawBottomLine = !isLastIndicator;
    final double bottomSegmentTop = _dotVerticalPosition + (_dotSize / 2);
    final double bottomSegmentBottom = 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // --- Center - Line and Dot ---
        Expanded(child: Text('Today', style: textStyle, textAlign: TextAlign.right)),
        SizedBox(
          width: _centerWidth,
          height: _verticalItemHeight, // Use shared height
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Top Connecting Line Segment
              if (drawTopLine)
                Positioned(
                  top: topSegmentTop,
                  bottom: topSegmentBottom,
                  left: _lineHorizontalPosition,
                  width: 2,
                  child: Container(color: lineTopColor), // Use color from item above
                ),
              // Bottom Connecting Line Segment
              if (drawBottomLine)
                Positioned(
                  top: bottomSegmentTop,
                  bottom: bottomSegmentBottom,
                  left: _lineHorizontalPosition,
                  width: 2,
                  child: Container(color: lineBottomColor), // Use color for line below
                ),
              // Today Dot
              Positioned(
                left: _dotHorizontalPosition, // Centered dot
                top: _dotVerticalPosition, // Centered dot
                child: Container(
                  width: _dotSize,
                  height: _dotSize,
                  decoration: BoxDecoration(
                    color: dotColor, // Secondary color
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.canvasColor, // Use theme background
                      width: _dotBorderSize,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // --- Right side ---
        Expanded(child: Text(DateFormat.yMMMd().format(today), style: textStyle, textAlign: TextAlign.left)),
      ],
    );
  }
}

// --- DateTime Extensions (Optional but helpful) ---
extension DateTimeComparison on DateTime {
  bool isSameDateAs(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameDateOrBefore(DateTime other) {
    // Compare dates only, ignore time
    final thisDate = DateTime(year, month, day);
    final otherDate = DateTime(other.year, other.month, other.day);
    return !thisDate.isAfter(otherDate); // True if same day or before
  }
}
