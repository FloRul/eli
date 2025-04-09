// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_dashboard_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectDashboardSummary _$ProjectDashboardSummaryFromJson(
  Map<String, dynamic> json,
) => _ProjectDashboardSummary(
  projectId: (json['project_id'] as num).toInt(),
  projectName: json['project_name'] as String,
  totalLotItems: (json['total_lot_items'] as num).toInt(),
  upcomingDeliveriesThisWeekCount:
      (json['upcoming_deliveries_this_week_count'] as num).toInt(),
  problematicLotsCount: (json['problematic_lots_count'] as num).toInt(),
  pastDueRemindersCount: (json['past_due_reminders_count'] as num).toInt(),
  dueSoonRemindersCount: (json['due_soon_reminders_count'] as num).toInt(),
  pastDueDeliverablesCount:
      (json['past_due_deliverables_count'] as num).toInt(),
  dueThisWeekDeliverablesCount:
      (json['due_this_week_deliverables_count'] as num).toInt(),
  avgPurchasingProgress: (json['avg_purchasing_progress'] as num).toDouble(),
  avgEngineeringProgress: (json['avg_engineering_progress'] as num).toDouble(),
  avgManufacturingProgress:
      (json['avg_manufacturing_progress'] as num).toDouble(),
  missingStartMfgDateCount:
      (json['missing_start_mfg_date_count'] as num).toInt(),
  missingEndMfgDateCount: (json['missing_end_mfg_date_count'] as num).toInt(),
  missingPlannedDeliveryDateCount:
      (json['missing_planned_delivery_date_count'] as num).toInt(),
  missingRequiredOnSiteDateCount:
      (json['missing_required_on_site_date_count'] as num).toInt(),
  missingEngineerContactCount:
      (json['missing_engineer_contact_count'] as num).toInt(),
  missingProviderPmContactCount:
      (json['missing_provider_pm_contact_count'] as num).toInt(),
);

Map<String, dynamic> _$ProjectDashboardSummaryToJson(
  _ProjectDashboardSummary instance,
) => <String, dynamic>{
  'project_id': instance.projectId,
  'project_name': instance.projectName,
  'total_lot_items': instance.totalLotItems,
  'upcoming_deliveries_this_week_count':
      instance.upcomingDeliveriesThisWeekCount,
  'problematic_lots_count': instance.problematicLotsCount,
  'past_due_reminders_count': instance.pastDueRemindersCount,
  'due_soon_reminders_count': instance.dueSoonRemindersCount,
  'past_due_deliverables_count': instance.pastDueDeliverablesCount,
  'due_this_week_deliverables_count': instance.dueThisWeekDeliverablesCount,
  'avg_purchasing_progress': instance.avgPurchasingProgress,
  'avg_engineering_progress': instance.avgEngineeringProgress,
  'avg_manufacturing_progress': instance.avgManufacturingProgress,
  'missing_start_mfg_date_count': instance.missingStartMfgDateCount,
  'missing_end_mfg_date_count': instance.missingEndMfgDateCount,
  'missing_planned_delivery_date_count':
      instance.missingPlannedDeliveryDateCount,
  'missing_required_on_site_date_count':
      instance.missingRequiredOnSiteDateCount,
  'missing_engineer_contact_count': instance.missingEngineerContactCount,
  'missing_provider_pm_contact_count': instance.missingProviderPmContactCount,
};
