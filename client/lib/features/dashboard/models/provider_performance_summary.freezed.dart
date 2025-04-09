// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'provider_performance_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProviderPerformanceSummary {

 String get provider; int get itemsCompletedCount; int get itemsOngoingCount; int get itemsOnholdCount; int get itemsClosefollowupCount; int get itemsCriticalCount; int get totalItemsCount; int get totalDeliverablesCount; int get overdueDeliverablesCount; double get overdueDeliverablesPercentage; int? get avgManufacturingInterval;
/// Create a copy of ProviderPerformanceSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProviderPerformanceSummaryCopyWith<ProviderPerformanceSummary> get copyWith => _$ProviderPerformanceSummaryCopyWithImpl<ProviderPerformanceSummary>(this as ProviderPerformanceSummary, _$identity);

  /// Serializes this ProviderPerformanceSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProviderPerformanceSummary&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.itemsCompletedCount, itemsCompletedCount) || other.itemsCompletedCount == itemsCompletedCount)&&(identical(other.itemsOngoingCount, itemsOngoingCount) || other.itemsOngoingCount == itemsOngoingCount)&&(identical(other.itemsOnholdCount, itemsOnholdCount) || other.itemsOnholdCount == itemsOnholdCount)&&(identical(other.itemsClosefollowupCount, itemsClosefollowupCount) || other.itemsClosefollowupCount == itemsClosefollowupCount)&&(identical(other.itemsCriticalCount, itemsCriticalCount) || other.itemsCriticalCount == itemsCriticalCount)&&(identical(other.totalItemsCount, totalItemsCount) || other.totalItemsCount == totalItemsCount)&&(identical(other.totalDeliverablesCount, totalDeliverablesCount) || other.totalDeliverablesCount == totalDeliverablesCount)&&(identical(other.overdueDeliverablesCount, overdueDeliverablesCount) || other.overdueDeliverablesCount == overdueDeliverablesCount)&&(identical(other.overdueDeliverablesPercentage, overdueDeliverablesPercentage) || other.overdueDeliverablesPercentage == overdueDeliverablesPercentage)&&(identical(other.avgManufacturingInterval, avgManufacturingInterval) || other.avgManufacturingInterval == avgManufacturingInterval));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provider,itemsCompletedCount,itemsOngoingCount,itemsOnholdCount,itemsClosefollowupCount,itemsCriticalCount,totalItemsCount,totalDeliverablesCount,overdueDeliverablesCount,overdueDeliverablesPercentage,avgManufacturingInterval);

@override
String toString() {
  return 'ProviderPerformanceSummary(provider: $provider, itemsCompletedCount: $itemsCompletedCount, itemsOngoingCount: $itemsOngoingCount, itemsOnholdCount: $itemsOnholdCount, itemsClosefollowupCount: $itemsClosefollowupCount, itemsCriticalCount: $itemsCriticalCount, totalItemsCount: $totalItemsCount, totalDeliverablesCount: $totalDeliverablesCount, overdueDeliverablesCount: $overdueDeliverablesCount, overdueDeliverablesPercentage: $overdueDeliverablesPercentage, avgManufacturingInterval: $avgManufacturingInterval)';
}


}

/// @nodoc
abstract mixin class $ProviderPerformanceSummaryCopyWith<$Res>  {
  factory $ProviderPerformanceSummaryCopyWith(ProviderPerformanceSummary value, $Res Function(ProviderPerformanceSummary) _then) = _$ProviderPerformanceSummaryCopyWithImpl;
@useResult
$Res call({
 String provider, int itemsCompletedCount, int itemsOngoingCount, int itemsOnholdCount, int itemsClosefollowupCount, int itemsCriticalCount, int totalItemsCount, int totalDeliverablesCount, int overdueDeliverablesCount, double overdueDeliverablesPercentage, int? avgManufacturingInterval
});




}
/// @nodoc
class _$ProviderPerformanceSummaryCopyWithImpl<$Res>
    implements $ProviderPerformanceSummaryCopyWith<$Res> {
  _$ProviderPerformanceSummaryCopyWithImpl(this._self, this._then);

  final ProviderPerformanceSummary _self;
  final $Res Function(ProviderPerformanceSummary) _then;

/// Create a copy of ProviderPerformanceSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? provider = null,Object? itemsCompletedCount = null,Object? itemsOngoingCount = null,Object? itemsOnholdCount = null,Object? itemsClosefollowupCount = null,Object? itemsCriticalCount = null,Object? totalItemsCount = null,Object? totalDeliverablesCount = null,Object? overdueDeliverablesCount = null,Object? overdueDeliverablesPercentage = null,Object? avgManufacturingInterval = freezed,}) {
  return _then(_self.copyWith(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,itemsCompletedCount: null == itemsCompletedCount ? _self.itemsCompletedCount : itemsCompletedCount // ignore: cast_nullable_to_non_nullable
as int,itemsOngoingCount: null == itemsOngoingCount ? _self.itemsOngoingCount : itemsOngoingCount // ignore: cast_nullable_to_non_nullable
as int,itemsOnholdCount: null == itemsOnholdCount ? _self.itemsOnholdCount : itemsOnholdCount // ignore: cast_nullable_to_non_nullable
as int,itemsClosefollowupCount: null == itemsClosefollowupCount ? _self.itemsClosefollowupCount : itemsClosefollowupCount // ignore: cast_nullable_to_non_nullable
as int,itemsCriticalCount: null == itemsCriticalCount ? _self.itemsCriticalCount : itemsCriticalCount // ignore: cast_nullable_to_non_nullable
as int,totalItemsCount: null == totalItemsCount ? _self.totalItemsCount : totalItemsCount // ignore: cast_nullable_to_non_nullable
as int,totalDeliverablesCount: null == totalDeliverablesCount ? _self.totalDeliverablesCount : totalDeliverablesCount // ignore: cast_nullable_to_non_nullable
as int,overdueDeliverablesCount: null == overdueDeliverablesCount ? _self.overdueDeliverablesCount : overdueDeliverablesCount // ignore: cast_nullable_to_non_nullable
as int,overdueDeliverablesPercentage: null == overdueDeliverablesPercentage ? _self.overdueDeliverablesPercentage : overdueDeliverablesPercentage // ignore: cast_nullable_to_non_nullable
as double,avgManufacturingInterval: freezed == avgManufacturingInterval ? _self.avgManufacturingInterval : avgManufacturingInterval // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ProviderPerformanceSummary implements ProviderPerformanceSummary {
  const _ProviderPerformanceSummary({required this.provider, required this.itemsCompletedCount, required this.itemsOngoingCount, required this.itemsOnholdCount, required this.itemsClosefollowupCount, required this.itemsCriticalCount, required this.totalItemsCount, required this.totalDeliverablesCount, required this.overdueDeliverablesCount, required this.overdueDeliverablesPercentage, this.avgManufacturingInterval});
  factory _ProviderPerformanceSummary.fromJson(Map<String, dynamic> json) => _$ProviderPerformanceSummaryFromJson(json);

@override final  String provider;
@override final  int itemsCompletedCount;
@override final  int itemsOngoingCount;
@override final  int itemsOnholdCount;
@override final  int itemsClosefollowupCount;
@override final  int itemsCriticalCount;
@override final  int totalItemsCount;
@override final  int totalDeliverablesCount;
@override final  int overdueDeliverablesCount;
@override final  double overdueDeliverablesPercentage;
@override final  int? avgManufacturingInterval;

/// Create a copy of ProviderPerformanceSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProviderPerformanceSummaryCopyWith<_ProviderPerformanceSummary> get copyWith => __$ProviderPerformanceSummaryCopyWithImpl<_ProviderPerformanceSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProviderPerformanceSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProviderPerformanceSummary&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.itemsCompletedCount, itemsCompletedCount) || other.itemsCompletedCount == itemsCompletedCount)&&(identical(other.itemsOngoingCount, itemsOngoingCount) || other.itemsOngoingCount == itemsOngoingCount)&&(identical(other.itemsOnholdCount, itemsOnholdCount) || other.itemsOnholdCount == itemsOnholdCount)&&(identical(other.itemsClosefollowupCount, itemsClosefollowupCount) || other.itemsClosefollowupCount == itemsClosefollowupCount)&&(identical(other.itemsCriticalCount, itemsCriticalCount) || other.itemsCriticalCount == itemsCriticalCount)&&(identical(other.totalItemsCount, totalItemsCount) || other.totalItemsCount == totalItemsCount)&&(identical(other.totalDeliverablesCount, totalDeliverablesCount) || other.totalDeliverablesCount == totalDeliverablesCount)&&(identical(other.overdueDeliverablesCount, overdueDeliverablesCount) || other.overdueDeliverablesCount == overdueDeliverablesCount)&&(identical(other.overdueDeliverablesPercentage, overdueDeliverablesPercentage) || other.overdueDeliverablesPercentage == overdueDeliverablesPercentage)&&(identical(other.avgManufacturingInterval, avgManufacturingInterval) || other.avgManufacturingInterval == avgManufacturingInterval));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provider,itemsCompletedCount,itemsOngoingCount,itemsOnholdCount,itemsClosefollowupCount,itemsCriticalCount,totalItemsCount,totalDeliverablesCount,overdueDeliverablesCount,overdueDeliverablesPercentage,avgManufacturingInterval);

@override
String toString() {
  return 'ProviderPerformanceSummary(provider: $provider, itemsCompletedCount: $itemsCompletedCount, itemsOngoingCount: $itemsOngoingCount, itemsOnholdCount: $itemsOnholdCount, itemsClosefollowupCount: $itemsClosefollowupCount, itemsCriticalCount: $itemsCriticalCount, totalItemsCount: $totalItemsCount, totalDeliverablesCount: $totalDeliverablesCount, overdueDeliverablesCount: $overdueDeliverablesCount, overdueDeliverablesPercentage: $overdueDeliverablesPercentage, avgManufacturingInterval: $avgManufacturingInterval)';
}


}

/// @nodoc
abstract mixin class _$ProviderPerformanceSummaryCopyWith<$Res> implements $ProviderPerformanceSummaryCopyWith<$Res> {
  factory _$ProviderPerformanceSummaryCopyWith(_ProviderPerformanceSummary value, $Res Function(_ProviderPerformanceSummary) _then) = __$ProviderPerformanceSummaryCopyWithImpl;
@override @useResult
$Res call({
 String provider, int itemsCompletedCount, int itemsOngoingCount, int itemsOnholdCount, int itemsClosefollowupCount, int itemsCriticalCount, int totalItemsCount, int totalDeliverablesCount, int overdueDeliverablesCount, double overdueDeliverablesPercentage, int? avgManufacturingInterval
});




}
/// @nodoc
class __$ProviderPerformanceSummaryCopyWithImpl<$Res>
    implements _$ProviderPerformanceSummaryCopyWith<$Res> {
  __$ProviderPerformanceSummaryCopyWithImpl(this._self, this._then);

  final _ProviderPerformanceSummary _self;
  final $Res Function(_ProviderPerformanceSummary) _then;

/// Create a copy of ProviderPerformanceSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? provider = null,Object? itemsCompletedCount = null,Object? itemsOngoingCount = null,Object? itemsOnholdCount = null,Object? itemsClosefollowupCount = null,Object? itemsCriticalCount = null,Object? totalItemsCount = null,Object? totalDeliverablesCount = null,Object? overdueDeliverablesCount = null,Object? overdueDeliverablesPercentage = null,Object? avgManufacturingInterval = freezed,}) {
  return _then(_ProviderPerformanceSummary(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,itemsCompletedCount: null == itemsCompletedCount ? _self.itemsCompletedCount : itemsCompletedCount // ignore: cast_nullable_to_non_nullable
as int,itemsOngoingCount: null == itemsOngoingCount ? _self.itemsOngoingCount : itemsOngoingCount // ignore: cast_nullable_to_non_nullable
as int,itemsOnholdCount: null == itemsOnholdCount ? _self.itemsOnholdCount : itemsOnholdCount // ignore: cast_nullable_to_non_nullable
as int,itemsClosefollowupCount: null == itemsClosefollowupCount ? _self.itemsClosefollowupCount : itemsClosefollowupCount // ignore: cast_nullable_to_non_nullable
as int,itemsCriticalCount: null == itemsCriticalCount ? _self.itemsCriticalCount : itemsCriticalCount // ignore: cast_nullable_to_non_nullable
as int,totalItemsCount: null == totalItemsCount ? _self.totalItemsCount : totalItemsCount // ignore: cast_nullable_to_non_nullable
as int,totalDeliverablesCount: null == totalDeliverablesCount ? _self.totalDeliverablesCount : totalDeliverablesCount // ignore: cast_nullable_to_non_nullable
as int,overdueDeliverablesCount: null == overdueDeliverablesCount ? _self.overdueDeliverablesCount : overdueDeliverablesCount // ignore: cast_nullable_to_non_nullable
as int,overdueDeliverablesPercentage: null == overdueDeliverablesPercentage ? _self.overdueDeliverablesPercentage : overdueDeliverablesPercentage // ignore: cast_nullable_to_non_nullable
as double,avgManufacturingInterval: freezed == avgManufacturingInterval ? _self.avgManufacturingInterval : avgManufacturingInterval // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
