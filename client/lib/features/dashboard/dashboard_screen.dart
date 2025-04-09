import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter for navigation simulation

/* TODO: 
    - total number of lot/items
    - upcoming (instead of pending) deliveries this week
    - problematic lots
    - important reminders, red past due, yellow due in the next 3 days
    - last meeting summary
    - world news headlines
    - due and upcoming deliverables
*/
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
    {'headline': 'Warehouse Automation Trends for 2025', 'source': 'Inventory Insider'},
    {'headline': 'Air Cargo Rates Stabilizing After Peak Season', 'source': 'Freight Forwarder Journal'},
    {'headline': 'Report: Sustainability Key in Future Logistics', 'source': 'Eco Transport Journal'},
    {'headline': 'Last-Mile Delivery Robots Trialed in Toronto', 'source': 'Local Tech News - Canada'},
  ];
  // --- End Mock Data ---

  // No initState or dispose needed for the carousel anymore

  // --- build method remains largely the same ---
  @override
  Widget build(BuildContext context) {
    // Based on current date: April 2, 2025
    print("Building DashboardScreen on April 2, 2025");

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    const double boxSpacing = 16.0;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(boxSpacing),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Left Column (No Changes) ---
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(child: _buildTotalTrackingBox(textTheme)),
                        const SizedBox(width: boxSpacing),
                        Expanded(child: _buildPendingDeliveriesBox(textTheme)),
                      ],
                    ),
                  ),
                  const SizedBox(height: boxSpacing),
                  Expanded(flex: 2, child: _buildProblematicLotsBox(textTheme, context)),
                  const SizedBox(height: boxSpacing),
                  Expanded(flex: 2, child: _buildLastMeetingBox(textTheme)),
                ],
              ),
            ),
            const SizedBox(width: boxSpacing),

            // --- Right Column (No Changes needed here, only in _buildNewsListBox)---
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(flex: 3, child: _buildRemindersBox(textTheme)),
                  const SizedBox(height: boxSpacing),
                  Expanded(
                    flex: 2,
                    // Renamed method for clarity
                    child: _buildNewsListBox(textTheme),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Bento Box Widget Builders (No changes needed for others) ---

  Widget _buildBentoBox({
    required Widget child,
    required String title,
    required TextTheme textTheme,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
  }) {
    return Card(
      elevation: 2.0,
      color: backgroundColor ?? Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        // Use default padding or allow override
        padding: padding ?? const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Expanded(
              // Ensures the child (like ListView) takes available space
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalTrackingBox(TextTheme textTheme) {
    // ... (no changes) ...
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
    // ... (no changes) ...
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
        print('Navigate to problematic lots view...');
        GoRouter.of(context).go('/lots');
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
            const Spacer(),
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
                Icon(Icons.notification_important_outlined, size: 18),
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
          Text(lastMeetingSummary, style: textTheme.bodyMedium, maxLines: 4, overflow: TextOverflow.ellipsis),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Text('View Full Notes', style: textTheme.bodySmall?.copyWith(color: Colors.blueGrey[700])),
          ),
        ],
      ),
    );
  }

  // --- Updated News List Box (Vertical Scroll) ---
  Widget _buildNewsListBox(TextTheme textTheme) {
    return _buildBentoBox(
      title: 'World News Headlines',
      textTheme: textTheme,
      // Use default padding provided by _buildBentoBox or adjust
      // padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 8.0), // Example override
      child: ListView.separated(
        itemCount: worldNews.length,
        separatorBuilder: (context, index) => const Divider(height: 16, thickness: 0.5), // Space between items
        itemBuilder: (context, index) {
          final newsItem = worldNews[index];
          return Padding(
            // Padding for each list item
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.newspaper_outlined, size: 18, color: Colors.teal),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        newsItem['headline']!,
                        style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 26.0), // Indent source under icon
                  child: Text(
                    'Source: ${newsItem['source']!}',
                    style: textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
