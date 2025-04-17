// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lot_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LotFilter {

 Status? get status; String? get search;
/// Create a copy of LotFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LotFilterCopyWith<LotFilter> get copyWith => _$LotFilterCopyWithImpl<LotFilter>(this as LotFilter, _$identity);

  /// Serializes this LotFilter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LotFilter&&(identical(other.status, status) || other.status == status)&&(identical(other.search, search) || other.search == search));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,search);

@override
String toString() {
  return 'LotFilter(status: $status, search: $search)';
}


}

/// @nodoc
abstract mixin class $LotFilterCopyWith<$Res>  {
  factory $LotFilterCopyWith(LotFilter value, $Res Function(LotFilter) _then) = _$LotFilterCopyWithImpl;
@useResult
$Res call({
 Status? status, String? search
});




}
/// @nodoc
class _$LotFilterCopyWithImpl<$Res>
    implements $LotFilterCopyWith<$Res> {
  _$LotFilterCopyWithImpl(this._self, this._then);

  final LotFilter _self;
  final $Res Function(LotFilter) _then;

/// Create a copy of LotFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = freezed,Object? search = freezed,}) {
  return _then(_self.copyWith(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status?,search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _LotFilter implements LotFilter {
  const _LotFilter({required this.status, required this.search});
  factory _LotFilter.fromJson(Map<String, dynamic> json) => _$LotFilterFromJson(json);

@override final  Status? status;
@override final  String? search;

/// Create a copy of LotFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LotFilterCopyWith<_LotFilter> get copyWith => __$LotFilterCopyWithImpl<_LotFilter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LotFilterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LotFilter&&(identical(other.status, status) || other.status == status)&&(identical(other.search, search) || other.search == search));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,search);

@override
String toString() {
  return 'LotFilter(status: $status, search: $search)';
}


}

/// @nodoc
abstract mixin class _$LotFilterCopyWith<$Res> implements $LotFilterCopyWith<$Res> {
  factory _$LotFilterCopyWith(_LotFilter value, $Res Function(_LotFilter) _then) = __$LotFilterCopyWithImpl;
@override @useResult
$Res call({
 Status? status, String? search
});




}
/// @nodoc
class __$LotFilterCopyWithImpl<$Res>
    implements _$LotFilterCopyWith<$Res> {
  __$LotFilterCopyWithImpl(this._self, this._then);

  final _LotFilter _self;
  final $Res Function(_LotFilter) _then;

/// Create a copy of LotFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = freezed,Object? search = freezed,}) {
  return _then(_LotFilter(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status?,search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
