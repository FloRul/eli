// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timeline_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TimelineEntry {

 String get label; String get key; DateTime? get date; bool get isPassed; bool get isHighlighted;
/// Create a copy of TimelineEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineEntryCopyWith<TimelineEntry> get copyWith => _$TimelineEntryCopyWithImpl<TimelineEntry>(this as TimelineEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineEntry&&(identical(other.label, label) || other.label == label)&&(identical(other.key, key) || other.key == key)&&(identical(other.date, date) || other.date == date)&&(identical(other.isPassed, isPassed) || other.isPassed == isPassed)&&(identical(other.isHighlighted, isHighlighted) || other.isHighlighted == isHighlighted));
}


@override
int get hashCode => Object.hash(runtimeType,label,key,date,isPassed,isHighlighted);

@override
String toString() {
  return 'TimelineEntry(label: $label, key: $key, date: $date, isPassed: $isPassed, isHighlighted: $isHighlighted)';
}


}

/// @nodoc
abstract mixin class $TimelineEntryCopyWith<$Res>  {
  factory $TimelineEntryCopyWith(TimelineEntry value, $Res Function(TimelineEntry) _then) = _$TimelineEntryCopyWithImpl;
@useResult
$Res call({
 String label, String key, DateTime? date, bool isPassed, bool isHighlighted
});




}
/// @nodoc
class _$TimelineEntryCopyWithImpl<$Res>
    implements $TimelineEntryCopyWith<$Res> {
  _$TimelineEntryCopyWithImpl(this._self, this._then);

  final TimelineEntry _self;
  final $Res Function(TimelineEntry) _then;

/// Create a copy of TimelineEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? key = null,Object? date = freezed,Object? isPassed = null,Object? isHighlighted = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,isPassed: null == isPassed ? _self.isPassed : isPassed // ignore: cast_nullable_to_non_nullable
as bool,isHighlighted: null == isHighlighted ? _self.isHighlighted : isHighlighted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc


class _TimelineEntry implements TimelineEntry {
  const _TimelineEntry({required this.label, required this.key, required this.date, this.isPassed = false, this.isHighlighted = false});
  

@override final  String label;
@override final  String key;
@override final  DateTime? date;
@override@JsonKey() final  bool isPassed;
@override@JsonKey() final  bool isHighlighted;

/// Create a copy of TimelineEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimelineEntryCopyWith<_TimelineEntry> get copyWith => __$TimelineEntryCopyWithImpl<_TimelineEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimelineEntry&&(identical(other.label, label) || other.label == label)&&(identical(other.key, key) || other.key == key)&&(identical(other.date, date) || other.date == date)&&(identical(other.isPassed, isPassed) || other.isPassed == isPassed)&&(identical(other.isHighlighted, isHighlighted) || other.isHighlighted == isHighlighted));
}


@override
int get hashCode => Object.hash(runtimeType,label,key,date,isPassed,isHighlighted);

@override
String toString() {
  return 'TimelineEntry(label: $label, key: $key, date: $date, isPassed: $isPassed, isHighlighted: $isHighlighted)';
}


}

/// @nodoc
abstract mixin class _$TimelineEntryCopyWith<$Res> implements $TimelineEntryCopyWith<$Res> {
  factory _$TimelineEntryCopyWith(_TimelineEntry value, $Res Function(_TimelineEntry) _then) = __$TimelineEntryCopyWithImpl;
@override @useResult
$Res call({
 String label, String key, DateTime? date, bool isPassed, bool isHighlighted
});




}
/// @nodoc
class __$TimelineEntryCopyWithImpl<$Res>
    implements _$TimelineEntryCopyWith<$Res> {
  __$TimelineEntryCopyWithImpl(this._self, this._then);

  final _TimelineEntry _self;
  final $Res Function(_TimelineEntry) _then;

/// Create a copy of TimelineEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? key = null,Object? date = freezed,Object? isPassed = null,Object? isHighlighted = null,}) {
  return _then(_TimelineEntry(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,isPassed: null == isPassed ? _self.isPassed : isPassed // ignore: cast_nullable_to_non_nullable
as bool,isHighlighted: null == isHighlighted ? _self.isHighlighted : isHighlighted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
