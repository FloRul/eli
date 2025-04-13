import 'package:client/features/dashboard/models/project_dashboard_summary.dart';
import 'package:client/features/dashboard/providers/project_summary_provider.dart';
import 'package:client/features/dashboard/widgets/progress_overview.dart';
import 'package:client/features/dashboard/widgets/stat_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectDashboardPage extends ConsumerWidget {
  const ProjectDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardDataAsync = ref.watch(projectDashboardSummaryProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
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
    return ListView(
      padding: const EdgeInsets.all(16.0), // Consistent padding
      children: [
        _buildKeyMetricsSection(context, summary),
        const SizedBox(height: 16),
        _buildAttentionRequiredSection(context, summary),
        // Add more sections if needed
      ],
    );
  }

  Widget _buildKeyMetricsSection(BuildContext context, ProjectDashboardSummary summary) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Key Metrics', style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 16),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12.0,
              runSpacing: 12.0,
              children: [
                ProgressOverview(summary: summary),
                StatChip(
                  icon: Icons.list_alt,
                  title: 'Total Lot Items',
                  value: summary.totalLotItems.toString(),
                  color: colorScheme.primary,
                ),
                StatChip(
                  icon: Icons.local_shipping_outlined,
                  title: 'Upcoming Deliveries',
                  value: summary.upcomingDeliveriesThisWeekCount.toString(),
                  subtitle: '(This Week)',
                  color: colorScheme.secondary,
                ),
                StatChip(
                  icon: Icons.assignment_turned_in_outlined,
                  title: 'Deliverables Due',
                  value: summary.dueThisWeekDeliverablesCount.toString(),
                  subtitle: '(This Week)',
                  color: colorScheme.secondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttentionRequiredSection(BuildContext context, ProjectDashboardSummary summary) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final bool hasProblematicLots = summary.problematicLotsCount > 0;
    final bool hasPastDueReminders = summary.pastDueRemindersCount > 0;
    final bool hasPastDueDeliverables = summary.pastDueDeliverablesCount > 0;
    final bool hasDueSoonReminders = summary.dueSoonRemindersCount > 0;

    final bool hasDataQualityIssues =
        summary.missingStartMfgDateCount > 0 ||
        summary.missingEndMfgDateCount > 0 ||
        summary.missingPlannedDeliveryDateCount > 0 ||
        summary.missingRequiredOnSiteDateCount > 0 ||
        summary.missingEngineerContactCount > 0 ||
        summary.missingProviderPmContactCount > 0;

    final bool needsAttention =
        hasProblematicLots ||
        hasPastDueReminders ||
        hasPastDueDeliverables ||
        hasDueSoonReminders || // Include due soon as needing attention
        hasDataQualityIssues;

    return Card(
      elevation: 2,
      // Use a warning color background if there are critical issues
      color:
          hasProblematicLots || hasPastDueReminders || hasPastDueDeliverables
              ? colorScheme.errorContainer.withValues(alpha: 0.1) // Subtle error hint
              : colorScheme.surfaceContainerHighest, // Or a neutral background
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Attention Required', style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              children: [
                if (hasProblematicLots || hasPastDueReminders || hasPastDueDeliverables || hasDueSoonReminders)
                  StatChip(
                    icon: Icons.warning_amber_rounded,
                    title: 'Problematic Lots',
                    value: summary.problematicLotsCount.toString(),
                    color:
                        hasProblematicLots
                            ? colorScheme.error
                            : colorScheme.primary, // Use primary if 0 but still show card
                  ),
                if (hasProblematicLots || hasPastDueReminders || hasPastDueDeliverables || hasDueSoonReminders)
                  StatChip(
                    icon: Icons.notifications_active_outlined,
                    title: 'Past Due Reminders',
                    value: summary.pastDueRemindersCount.toString(),
                    color: hasPastDueReminders ? colorScheme.error : colorScheme.secondary,
                  ),
                if (hasProblematicLots || hasPastDueReminders || hasPastDueDeliverables || hasDueSoonReminders)
                  StatChip(
                    icon: Icons.assignment_late_outlined,
                    title: 'Past Due Deliverables',
                    value: summary.pastDueDeliverablesCount.toString(),
                    color: hasPastDueDeliverables ? colorScheme.error : colorScheme.secondary,
                  ),
                if (hasProblematicLots || hasPastDueReminders || hasPastDueDeliverables || hasDueSoonReminders)
                  StatChip(
                    icon: Icons.notification_important_outlined,
                    title: 'Due Soon Reminders',
                    value: summary.dueSoonRemindersCount.toString(),
                    color: hasDueSoonReminders ? colorScheme.tertiary : colorScheme.secondary,
                  ),
              ],
            ),
            // Add divider if there are stats AND data quality issues
            if ((hasProblematicLots || hasPastDueReminders || hasPastDueDeliverables || hasDueSoonReminders) &&
                hasDataQualityIssues)
              const Padding(padding: EdgeInsets.symmetric(vertical: 16.0), child: Divider()),

            // --- Data Quality Sub-section ---
            if (hasDataQualityIssues) _buildDataQualityList(context, summary),

            // If the card is shown but no items are listed (e.g., only 0 counts)
            if (!needsAttention)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.green[700], size: 18),
                    const SizedBox(width: 8),
                    Text('No attention items found.', style: textTheme.bodyMedium),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataQualityList(BuildContext context, ProjectDashboardSummary summary) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final issues = [
      if (summary.missingStartMfgDateCount > 0)
        _buildDataQualityItem(context, 'Missing Start Mfg Date', summary.missingStartMfgDateCount),
      if (summary.missingEndMfgDateCount > 0)
        _buildDataQualityItem(context, 'Missing End Mfg Date', summary.missingEndMfgDateCount),
      if (summary.missingPlannedDeliveryDateCount > 0)
        _buildDataQualityItem(context, 'Missing Planned Delivery Date', summary.missingPlannedDeliveryDateCount),
      if (summary.missingRequiredOnSiteDateCount > 0)
        _buildDataQualityItem(context, 'Missing Required On-Site Date', summary.missingRequiredOnSiteDateCount),
      if (summary.missingEngineerContactCount > 0)
        _buildDataQualityItem(context, 'Missing Engineer Contact', summary.missingEngineerContactCount),
      if (summary.missingProviderPmContactCount > 0)
        _buildDataQualityItem(context, 'Missing Provider PM Contact', summary.missingProviderPmContactCount),
    ];

    if (issues.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Data Quality Issues:', style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
        const SizedBox(height: 8),
        ...issues, // Spread operator to insert list items
      ],
    );
  }

  Widget _buildDataQualityItem(BuildContext context, String title, int count) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colorScheme.error, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: textTheme.bodyMedium)), // Removed color override for default contrast
          Text(
            count.toString(),
            style: textTheme.bodyLarge?.copyWith(color: colorScheme.error, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
