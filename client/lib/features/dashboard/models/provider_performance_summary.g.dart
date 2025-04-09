// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_performance_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProviderPerformanceSummary _$ProviderPerformanceSummaryFromJson(
  Map<String, dynamic> json,
) => _ProviderPerformanceSummary(
  provider: json['provider'] as String,
  itemsCompletedCount: (json['items_completed_count'] as num).toInt(),
  itemsOngoingCount: (json['items_ongoing_count'] as num).toInt(),
  itemsOnholdCount: (json['items_onhold_count'] as num).toInt(),
  itemsClosefollowupCount: (json['items_closefollowup_count'] as num).toInt(),
  itemsCriticalCount: (json['items_critical_count'] as num).toInt(),
  totalItemsCount: (json['total_items_count'] as num).toInt(),
  totalDeliverablesCount: (json['total_deliverables_count'] as num).toInt(),
  overdueDeliverablesCount: (json['overdue_deliverables_count'] as num).toInt(),
  overdueDeliverablesPercentage:
      (json['overdue_deliverables_percentage'] as num).toDouble(),
  avgManufacturingInterval:
      (json['avg_manufacturing_interval'] as num?)?.toInt(),
);

Map<String, dynamic> _$ProviderPerformanceSummaryToJson(
  _ProviderPerformanceSummary instance,
) => <String, dynamic>{
  'provider': instance.provider,
  'items_completed_count': instance.itemsCompletedCount,
  'items_ongoing_count': instance.itemsOngoingCount,
  'items_onhold_count': instance.itemsOnholdCount,
  'items_closefollowup_count': instance.itemsClosefollowupCount,
  'items_critical_count': instance.itemsCriticalCount,
  'total_items_count': instance.totalItemsCount,
  'total_deliverables_count': instance.totalDeliverablesCount,
  'overdue_deliverables_count': instance.overdueDeliverablesCount,
  'overdue_deliverables_percentage': instance.overdueDeliverablesPercentage,
  'avg_manufacturing_interval': instance.avgManufacturingInterval,
};
