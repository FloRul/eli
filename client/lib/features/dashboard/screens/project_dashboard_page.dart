import 'package:client/features/dashboard/models/project_dashboard_summary.dart';
import 'package:client/features/dashboard/providers/project_summary_provider.dart';
import 'package:flutter/material.dart'; // Import Material
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For formatting percentages

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
    final percentageFormat = NumberFormat.percentPattern();

    return ListView(
      // Use ListView for scrollable content
      padding: const EdgeInsets.all(16.0),
      children: [
        // --- Key Stats Grid ---
        GridView.count(
          crossAxisCount: 2, // Adjust number of columns as needed
          shrinkWrap: true, // Important for GridView inside ListView
          physics: const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 2.5, // Adjust aspect ratio for card size
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
        const SizedBox(height: 24),

        // --- Progress Section ---
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Progress Overview', style: textTheme.titleLarge),
                const SizedBox(height: 16),
                _buildProgressIndicator(
                  context,
                  title: 'Purchasing',
                  value: summary.avgPurchasingProgress,
                  formattedValue: percentageFormat.format(summary.avgPurchasingProgress),
                ),
                const SizedBox(height: 12),
                _buildProgressIndicator(
                  context,
                  title: 'Engineering',
                  value: summary.avgEngineeringProgress,
                  formattedValue: percentageFormat.format(summary.avgEngineeringProgress),
                ),
                const SizedBox(height: 12),
                _buildProgressIndicator(
                  context,
                  title: 'Manufacturing',
                  value: summary.avgManufacturingProgress,
                  formattedValue: percentageFormat.format(summary.avgManufacturingProgress),
                ),
              ],
            ),
          ),
        ),
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

  // --- Helper Widgets ---

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

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 28, color: color),
                Text(value, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: color)),
              ],
            ),
            const SizedBox(height: 8),
            Text(title, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
            if (subtitle != null) Text(subtitle, style: textTheme.labelSmall?.copyWith(color: colorScheme.outline)),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(
    BuildContext context, {
    required String title,
    required double value, // Value between 0.0 and 1.0
    required String formattedValue,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: textTheme.titleMedium),
            Text(formattedValue, style: textTheme.titleMedium?.copyWith(color: colorScheme.primary)),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: value,
          minHeight: 8, // Make the bar thicker
          borderRadius: BorderRadius.circular(4),
          backgroundColor: colorScheme.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
        ),
      ],
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
