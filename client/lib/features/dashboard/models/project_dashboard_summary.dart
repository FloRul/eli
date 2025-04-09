import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_dashboard_summary.freezed.dart';
part 'project_dashboard_summary.g.dart';

@freezed
abstract class ProjectDashboardSummary with _$ProjectDashboardSummary {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ProjectDashboardSummary({
    required int projectId,
    required String projectName,
    required int totalLotItems,
    required int upcomingDeliveriesThisWeekCount,
    required int problematicLotsCount,
    required int pastDueRemindersCount,
    required int dueSoonRemindersCount,
    required int pastDueDeliverablesCount,
    required int dueThisWeekDeliverablesCount,
    required double avgPurchasingProgress,
    required double avgEngineeringProgress,
    required double avgManufacturingProgress,
    required int missingStartMfgDateCount,
    required int missingEndMfgDateCount,
    required int missingPlannedDeliveryDateCount,
    required int missingRequiredOnSiteDateCount,
    required int missingEngineerContactCount,
    required int missingProviderPmContactCount,
  }) = _ProjectDashboardSummary;

  factory ProjectDashboardSummary.fromJson(Map<String, dynamic> json) => _$ProjectDashboardSummaryFromJson(json);
}
