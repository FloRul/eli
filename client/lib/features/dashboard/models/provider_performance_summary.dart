import 'package:freezed_annotation/freezed_annotation.dart';

part 'provider_performance_summary.freezed.dart';
part 'provider_performance_summary.g.dart';

@freezed
abstract class ProviderPerformanceSummary with _$ProviderPerformanceSummary {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ProviderPerformanceSummary({
    required String provider,
    required int itemsCompletedCount,
    required int itemsOngoingCount,
    required int itemsOnholdCount,
    required int itemsClosefollowupCount,
    required int itemsCriticalCount,
    required int totalItemsCount,
    required int totalDeliverablesCount,
    required int overdueDeliverablesCount,
    required double overdueDeliverablesPercentage,
    int? avgManufacturingInterval, // in days
  }) = _ProviderPerformanceSummary;

  factory ProviderPerformanceSummary.fromJson(Map<String, dynamic> json) => _$ProviderPerformanceSummaryFromJson(json);
}
