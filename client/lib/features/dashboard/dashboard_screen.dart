import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter for navigation simulation
import 'dart:async'; // For Timer

// If you have a theme provider for colors/styles, import it
// import 'package:client/theme/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _newsPageController = PageController();
  int _currentNewsPage = 0;
  Timer? _newsScrollTimer;

  // --- Mock Data ---
  final int totalLotsTracked = 128;
  final int pendingDeliveriesThisWeek = 5;
  final int problematicLotsCount = 3;
  final List<String> importantReminders = [
    "Follow up with Supplier X by EOD.",
    "Team meeting rescheduled to 3 PM.",
    "Review Q1 logistics report.",
  ];
  final String lastMeetingSummary =
      "Discussed shipping delays for Lot #A45. Action item: Contact carrier for ETA update. Confirmed specs for new Item #B72.";
  final List<Map<String, String>> worldNews = [
    {'headline': 'Global Shipping Lanes See Increased Traffic', 'source': 'Logistics Today'},
    {'headline': 'New Autonomous Truck Regulations Proposed in EU', 'source': 'Transport Weekly'},
    {'headline': 'Port Congestion Easing Slightly on West Coast', 'source': 'Supply Chain News'},
    {'headline': 'Fuel Price Volatility Impacts Freight Costs', 'source': 'Global Trade Mag'},
  ];
  // --- End Mock Data ---

  @override
  void initState() {
    super.initState();
    // Start timer for automatic news carousel scrolling
    _newsScrollTimer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentNewsPage < worldNews.length - 1) {
        _currentNewsPage++;
      } else {
        _currentNewsPage = 0;
      }
      if (_newsPageController.hasClients) {
        _newsPageController.animateToPage(
          _currentNewsPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _newsPageController.dispose();
    _newsScrollTimer?.cancel(); // Cancel timer on dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use Theme for consistent spacing and colors
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    const double boxSpacing = 16.0; // Spacing between boxes

    return Scaffold(
      // The AppBar is handled by HomeScreen, so we only need the body
      body: Padding(
        padding: const EdgeInsets.all(boxSpacing),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Left Column ---
            Expanded(
              flex: 2, // Adjust flex factor for column width ratio
              child: Column(
                children: [
                  // --- Top Row in Left Column ---
                  IntrinsicHeight(
                    // Makes cards in the row have same height
                    child: Row(
                      children: [
                        Expanded(child: _buildTotalTrackingBox(textTheme)),
                        const SizedBox(width: boxSpacing),
                        Expanded(child: _buildPendingDeliveriesBox(textTheme)),
                      ],
                    ),
                  ),
                  const SizedBox(height: boxSpacing),
                  // --- Problematic Lots Box ---
                  Expanded(
                    flex: 2, // Make this box taller
                    child: _buildProblematicLotsBox(textTheme, context),
                  ),
                  const SizedBox(height: boxSpacing),
                  // --- Last Meeting Summary Box ---
                  Expanded(
                    flex: 2, // Adjust flex as needed
                    child: _buildLastMeetingBox(textTheme),
                  ),
                ],
              ),
            ),
            const SizedBox(width: boxSpacing),

            // --- Right Column ---
            Expanded(
              flex: 3, // Adjust flex factor for column width ratio
              child: Column(
                children: [
                  // --- Reminders Box ---
                  Expanded(
                    flex: 3, // Make this box taller
                    child: _buildRemindersBox(textTheme),
                  ),
                  const SizedBox(height: boxSpacing),
                  // --- News Carousel Box ---
                  Expanded(
                    flex: 2, // Adjust flex as needed
                    child: _buildNewsCarouselBox(textTheme),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Bento Box Widget Builders ---

  Widget _buildBentoBox({
    required Widget child,
    required String title,
    required TextTheme textTheme,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
  }) {
    return Card(
      elevation: 2.0,
      // Use theme card color or specify
      color: backgroundColor ?? Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Expanded(
              // Make child fill the remaining space
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalTrackingBox(TextTheme textTheme) {
    return _buildBentoBox(
      title: 'Tracking Overview',
      textTheme: textTheme,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined, size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text('$totalLotsTracked', style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            Text('Lots / Items', style: textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingDeliveriesBox(TextTheme textTheme) {
    return _buildBentoBox(
      title: 'Pending Deliveries',
      textTheme: textTheme,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_shipping_outlined, size: 32, color: Colors.orange[700]),
            const SizedBox(height: 8),
            Text('$pendingDeliveriesThisWeek', style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            Text('This Week', style: textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _buildProblematicLotsBox(TextTheme textTheme, BuildContext context) {
    return InkWell(
      onTap: () {
        print('Navigate to problematic lots view...'); // Placeholder action
        // In a real app, you would navigate and potentially pass filter parameters:
        // context.go('/lots?filter=problematic');
        // OR use a state management solution to set the filter before navigation
        GoRouter.of(context).go('/lots'); // Simple navigation for now
      },
      child: _buildBentoBox(
        title: 'Problematic Lots ($problematicLotsCount)',
        textTheme: textTheme,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.warning_amber_rounded, size: 28, color: Colors.red[700]),
            const SizedBox(height: 12),
            Text('Lot #A45 - Delayed Shipment', style: textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text('Item #C12 - Quality Issue Reported', style: textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text('Lot #F89 - Customs Hold', style: textTheme.bodyMedium),
            const Spacer(), // Pushes text to top
            Align(
              alignment: Alignment.bottomRight,
              child: Text('Tap to view all', style: textTheme.bodySmall?.copyWith(color: Colors.red[900])),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemindersBox(TextTheme textTheme) {
    return _buildBentoBox(
      title: 'Important Reminders',
      textTheme: textTheme,
      child: ListView.separated(
        itemCount: importantReminders.length,
        separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.5),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Icon(Icons.notification_important_outlined, size: 18, color: Theme.of(context).colorScheme.secondary),
                const SizedBox(width: 8),
                Expanded(child: Text(importantReminders[index], style: textTheme.bodyMedium)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLastMeetingBox(TextTheme textTheme) {
    return _buildBentoBox(
      title: 'Last Meeting Summary',
      textTheme: textTheme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.groups_outlined, size: 28, color: Colors.blueGrey),
          const SizedBox(height: 12),
          Text(
            lastMeetingSummary,
            style: textTheme.bodyMedium,
            maxLines: 4, // Limit lines shown
            overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Text('View Full Notes', style: textTheme.bodySmall?.copyWith(color: Colors.blueGrey[700])),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCarouselBox(TextTheme textTheme) {
    return _buildBentoBox(
      title: 'World News Headlines',
      textTheme: textTheme,
      // Reduce padding slightly for PageView
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 8.0),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _newsPageController,
              itemCount: worldNews.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentNewsPage = page;
                });
              },
              itemBuilder: (context, index) {
                final newsItem = worldNews[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0), // Padding inside page view
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.newspaper_outlined, size: 24, color: Colors.teal),
                      const SizedBox(height: 8),
                      Text(
                        newsItem['headline']!,
                        style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Source: ${newsItem['source']!}',
                        style: textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Simple Dot Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(worldNews.length, (index) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentNewsPage == index ? Theme.of(context).colorScheme.primary : Colors.grey.withOpacity(0.5),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
