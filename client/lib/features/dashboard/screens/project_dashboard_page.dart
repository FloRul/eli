import 'package:client/features/dashboard/models/project_dashboard_summary.dart';
import 'package:client/features/dashboard/providers/project_summary_provider.dart';
import 'package:client/features/dashboard/widgets/progress_overview.dart';
import 'package:client/features/lots/widgets/lot_item/rounded_progress_indicator.dart';
import 'package:flutter/material.dart'; // Import Material
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart'; // For formatting percentages

class ProjectDashboardPage extends ConsumerWidget {
  const ProjectDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardDataAsync = ref.watch(projectDashboardSummaryProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // Use Scaffold for basic page structure (AppBar, Body)
      appBar: AppBar(
        title: dashboardDataAsync.maybeWhen(
          data: (data) => data != null ? Text(data.projectName) : const Text('Project Dashboard'),
          orElse: () => const Text('Project Dashboard'), // Default title
        ),
      ),
      body: dashboardDataAsync.when(
        data:
            (summary) =>
                summary != null
                    ? _buildDashboardContent(context, summary)
                    : const Center(child: Text('No data available')),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error loading dashboard data:\n$error',
                  style: textTheme.titleMedium?.copyWith(color: colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, ProjectDashboardSummary summary) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(12.0), // Slightly reduce overall padding
      children: [
        // --- Key Stats Grid ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Wrap(
            direction: Axis.horizontal,
            spacing: 12.0, // Horizontal space between items
            runSpacing: 12.0, // Vertical space between lines
            children: [
              _buildStatCard(
                context,
                icon: Icons.list_alt,
                title: 'Total Lot Items',
                value: summary.totalLotItems.toString(),
                color: colorScheme.primary,
              ),
              _buildStatCard(
                context,
                icon: Icons.warning_amber_rounded,
                title: 'Problematic Lots',
                value: summary.problematicLotsCount.toString(),
                color: summary.problematicLotsCount > 0 ? colorScheme.error : colorScheme.primary,
              ),

              _buildStatCard(
                context,
                icon: Icons.local_shipping_outlined,
                title: 'Upcoming Deliveries',
                value: summary.upcomingDeliveriesThisWeekCount.toString(),
                subtitle: '(This Week)',
                color: colorScheme.secondary,
              ),
              _buildStatCard(
                context,
                icon: Icons.notifications_active_outlined,
                title: 'Past Due Reminders',
                value: summary.pastDueRemindersCount.toString(),
                color: summary.pastDueRemindersCount > 0 ? colorScheme.error : colorScheme.secondary,
              ),
              _buildStatCard(
                context,
                icon: Icons.notification_important_outlined,
                title: 'Due Soon Reminders',
                value: summary.dueSoonRemindersCount.toString(),
                color: colorScheme.secondary,
              ),
              _buildStatCard(
                context,
                icon: Icons.assignment_late_outlined,
                title: 'Past Due Deliverables',
                value: summary.pastDueDeliverablesCount.toString(),
                color: summary.pastDueDeliverablesCount > 0 ? colorScheme.error : colorScheme.secondary,
              ),
              _buildStatCard(
                context,
                icon: Icons.assignment_turned_in_outlined,
                title: 'Deliverables Due',
                value: summary.dueThisWeekDeliverablesCount.toString(),
                subtitle: '(This Week)',
                color: colorScheme.secondary,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // --- Progress Section ---
        ProgressOverview(summary: summary),
        const SizedBox(height: 24),

        // --- Data Quality/Missing Info Section ---
        Card(
          elevation: 2,
          color: colorScheme.surfaceContainerHighest, // Slightly different background
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Data Quality Issues', style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
                const SizedBox(height: 16),
                _buildDataQualityItem(context, 'Missing Start Mfg Date', summary.missingStartMfgDateCount),
                _buildDataQualityItem(context, 'Missing End Mfg Date', summary.missingEndMfgDateCount),
                _buildDataQualityItem(
                  context,
                  'Missing Planned Delivery Date',
                  summary.missingPlannedDeliveryDateCount,
                ),
                _buildDataQualityItem(context, 'Missing Required On-Site Date', summary.missingRequiredOnSiteDateCount),
                _buildDataQualityItem(context, 'Missing Engineer Contact', summary.missingEngineerContactCount),
                _buildDataQualityItem(context, 'Missing Provider PM Contact', summary.missingProviderPmContactCount),
                // Only show if there are issues
                if (summary.missingStartMfgDateCount == 0 &&
                    summary.missingEndMfgDateCount == 0 &&
                    summary.missingPlannedDeliveryDateCount == 0 &&
                    summary.missingRequiredOnSiteDateCount == 0 &&
                    summary.missingEngineerContactCount == 0 &&
                    summary.missingProviderPmContactCount == 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.green[700], size: 18),
                        const SizedBox(width: 8),
                        Text('No data quality issues found.', style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
    required Color color,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return IntrinsicWidth(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Adjust vertical alignment if needed
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start, // Align icon/value to top
                children: [
                  // Slightly smaller icon
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0), // Fine-tune icon alignment
                    child: Icon(icon, size: 24, color: color),
                  ),
                  // Consider a slightly smaller text style for value if headlineSmall is too big
                  Text(value, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: color)),
                ],
              ),
              // Reduced spacing
              const SizedBox(height: 6),
              Text(
                title,
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                overflow: TextOverflow.ellipsis, // Handle potential overflow
              ),
              if (subtitle != null) Text(subtitle, style: textTheme.labelSmall?.copyWith(color: colorScheme.outline)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataQualityItem(BuildContext context, String title, int count) {
    if (count == 0) {
      // Optionally hide items with 0 count, or show them differently
      // return const SizedBox.shrink(); // Hide if zero
      return const SizedBox.shrink(); // Don't display if count is zero
    }

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colorScheme.error, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant))),
          Text(
            count.toString(),
            style: textTheme.bodyLarge?.copyWith(color: colorScheme.error, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
