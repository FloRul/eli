// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Lot {

@JsonKey(name: "lot_id") String get lotId;@JsonKey(name: "project_id") String get projectId; String get title; String? get itp;@JsonKey(name: "final_acceptance_test") String? get finalAcceptanceTest;@JsonKey(name: "start_date") DateTime? get startDate; String? get incoterms;@JsonKey(name: "required_on_site_date") DateTime? get requiredOnSiteDate;
/// Create a copy of Lot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LotCopyWith<Lot> get copyWith => _$LotCopyWithImpl<Lot>(this as Lot, _$identity);

  /// Serializes this Lot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Lot&&(identical(other.lotId, lotId) || other.lotId == lotId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.title, title) || other.title == title)&&(identical(other.itp, itp) || other.itp == itp)&&(identical(other.finalAcceptanceTest, finalAcceptanceTest) || other.finalAcceptanceTest == finalAcceptanceTest)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.incoterms, incoterms) || other.incoterms == incoterms)&&(identical(other.requiredOnSiteDate, requiredOnSiteDate) || other.requiredOnSiteDate == requiredOnSiteDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lotId,projectId,title,itp,finalAcceptanceTest,startDate,incoterms,requiredOnSiteDate);

@override
String toString() {
  return 'Lot(lotId: $lotId, projectId: $projectId, title: $title, itp: $itp, finalAcceptanceTest: $finalAcceptanceTest, startDate: $startDate, incoterms: $incoterms, requiredOnSiteDate: $requiredOnSiteDate)';
}


}

/// @nodoc
abstract mixin class $LotCopyWith<$Res>  {
  factory $LotCopyWith(Lot value, $Res Function(Lot) _then) = _$LotCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "lot_id") String lotId,@JsonKey(name: "project_id") String projectId, String title, String? itp,@JsonKey(name: "final_acceptance_test") String? finalAcceptanceTest,@JsonKey(name: "start_date") DateTime? startDate, String? incoterms,@JsonKey(name: "required_on_site_date") DateTime? requiredOnSiteDate
});




}
/// @nodoc
class _$LotCopyWithImpl<$Res>
    implements $LotCopyWith<$Res> {
  _$LotCopyWithImpl(this._self, this._then);

  final Lot _self;
  final $Res Function(Lot) _then;

/// Create a copy of Lot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lotId = null,Object? projectId = null,Object? title = null,Object? itp = freezed,Object? finalAcceptanceTest = freezed,Object? startDate = freezed,Object? incoterms = freezed,Object? requiredOnSiteDate = freezed,}) {
  return _then(_self.copyWith(
lotId: null == lotId ? _self.lotId : lotId // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,itp: freezed == itp ? _self.itp : itp // ignore: cast_nullable_to_non_nullable
as String?,finalAcceptanceTest: freezed == finalAcceptanceTest ? _self.finalAcceptanceTest : finalAcceptanceTest // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,incoterms: freezed == incoterms ? _self.incoterms : incoterms // ignore: cast_nullable_to_non_nullable
as String?,requiredOnSiteDate: freezed == requiredOnSiteDate ? _self.requiredOnSiteDate : requiredOnSiteDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Lot implements Lot {
  const _Lot({@JsonKey(name: "lot_id") required this.lotId, @JsonKey(name: "project_id") required this.projectId, required this.title, this.itp, @JsonKey(name: "final_acceptance_test") this.finalAcceptanceTest, @JsonKey(name: "start_date") this.startDate, this.incoterms, @JsonKey(name: "required_on_site_date") this.requiredOnSiteDate});
  factory _Lot.fromJson(Map<String, dynamic> json) => _$LotFromJson(json);

@override@JsonKey(name: "lot_id") final  String lotId;
@override@JsonKey(name: "project_id") final  String projectId;
@override final  String title;
@override final  String? itp;
@override@JsonKey(name: "final_acceptance_test") final  String? finalAcceptanceTest;
@override@JsonKey(name: "start_date") final  DateTime? startDate;
@override final  String? incoterms;
@override@JsonKey(name: "required_on_site_date") final  DateTime? requiredOnSiteDate;

/// Create a copy of Lot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LotCopyWith<_Lot> get copyWith => __$LotCopyWithImpl<_Lot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Lot&&(identical(other.lotId, lotId) || other.lotId == lotId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.title, title) || other.title == title)&&(identical(other.itp, itp) || other.itp == itp)&&(identical(other.finalAcceptanceTest, finalAcceptanceTest) || other.finalAcceptanceTest == finalAcceptanceTest)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.incoterms, incoterms) || other.incoterms == incoterms)&&(identical(other.requiredOnSiteDate, requiredOnSiteDate) || other.requiredOnSiteDate == requiredOnSiteDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lotId,projectId,title,itp,finalAcceptanceTest,startDate,incoterms,requiredOnSiteDate);

@override
String toString() {
  return 'Lot(lotId: $lotId, projectId: $projectId, title: $title, itp: $itp, finalAcceptanceTest: $finalAcceptanceTest, startDate: $startDate, incoterms: $incoterms, requiredOnSiteDate: $requiredOnSiteDate)';
}


}

/// @nodoc
abstract mixin class _$LotCopyWith<$Res> implements $LotCopyWith<$Res> {
  factory _$LotCopyWith(_Lot value, $Res Function(_Lot) _then) = __$LotCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "lot_id") String lotId,@JsonKey(name: "project_id") String projectId, String title, String? itp,@JsonKey(name: "final_acceptance_test") String? finalAcceptanceTest,@JsonKey(name: "start_date") DateTime? startDate, String? incoterms,@JsonKey(name: "required_on_site_date") DateTime? requiredOnSiteDate
});




}
/// @nodoc
class __$LotCopyWithImpl<$Res>
    implements _$LotCopyWith<$Res> {
  __$LotCopyWithImpl(this._self, this._then);

  final _Lot _self;
  final $Res Function(_Lot) _then;

/// Create a copy of Lot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lotId = null,Object? projectId = null,Object? title = null,Object? itp = freezed,Object? finalAcceptanceTest = freezed,Object? startDate = freezed,Object? incoterms = freezed,Object? requiredOnSiteDate = freezed,}) {
  return _then(_Lot(
lotId: null == lotId ? _self.lotId : lotId // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,itp: freezed == itp ? _self.itp : itp // ignore: cast_nullable_to_non_nullable
as String?,finalAcceptanceTest: freezed == finalAcceptanceTest ? _self.finalAcceptanceTest : finalAcceptanceTest // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,incoterms: freezed == incoterms ? _self.incoterms : incoterms // ignore: cast_nullable_to_non_nullable
as String?,requiredOnSiteDate: freezed == requiredOnSiteDate ? _self.requiredOnSiteDate : requiredOnSiteDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
