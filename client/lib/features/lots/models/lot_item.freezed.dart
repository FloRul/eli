// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lot_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LotItem {

@JsonKey(name: "lot_item_id") String get lotItemId;@JsonKey(name: "parent_lot_id") String get parentLotId; String get status; String get title;@JsonKey(name: "provider_id") String? get providerId;@JsonKey(name: "major_components") String? get majorComponents;
/// Create a copy of LotItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LotItemCopyWith<LotItem> get copyWith => _$LotItemCopyWithImpl<LotItem>(this as LotItem, _$identity);

  /// Serializes this LotItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LotItem&&(identical(other.lotItemId, lotItemId) || other.lotItemId == lotItemId)&&(identical(other.parentLotId, parentLotId) || other.parentLotId == parentLotId)&&(identical(other.status, status) || other.status == status)&&(identical(other.title, title) || other.title == title)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.majorComponents, majorComponents) || other.majorComponents == majorComponents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lotItemId,parentLotId,status,title,providerId,majorComponents);

@override
String toString() {
  return 'LotItem(lotItemId: $lotItemId, parentLotId: $parentLotId, status: $status, title: $title, providerId: $providerId, majorComponents: $majorComponents)';
}


}

/// @nodoc
abstract mixin class $LotItemCopyWith<$Res>  {
  factory $LotItemCopyWith(LotItem value, $Res Function(LotItem) _then) = _$LotItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "lot_item_id") String lotItemId,@JsonKey(name: "parent_lot_id") String parentLotId, String status, String title,@JsonKey(name: "provider_id") String? providerId,@JsonKey(name: "major_components") String? majorComponents
});




}
/// @nodoc
class _$LotItemCopyWithImpl<$Res>
    implements $LotItemCopyWith<$Res> {
  _$LotItemCopyWithImpl(this._self, this._then);

  final LotItem _self;
  final $Res Function(LotItem) _then;

/// Create a copy of LotItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lotItemId = null,Object? parentLotId = null,Object? status = null,Object? title = null,Object? providerId = freezed,Object? majorComponents = freezed,}) {
  return _then(_self.copyWith(
lotItemId: null == lotItemId ? _self.lotItemId : lotItemId // ignore: cast_nullable_to_non_nullable
as String,parentLotId: null == parentLotId ? _self.parentLotId : parentLotId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,providerId: freezed == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String?,majorComponents: freezed == majorComponents ? _self.majorComponents : majorComponents // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _LotItem implements LotItem {
  const _LotItem({@JsonKey(name: "lot_item_id") required this.lotItemId, @JsonKey(name: "parent_lot_id") required this.parentLotId, required this.status, required this.title, @JsonKey(name: "provider_id") required this.providerId, @JsonKey(name: "major_components") required this.majorComponents});
  factory _LotItem.fromJson(Map<String, dynamic> json) => _$LotItemFromJson(json);

@override@JsonKey(name: "lot_item_id") final  String lotItemId;
@override@JsonKey(name: "parent_lot_id") final  String parentLotId;
@override final  String status;
@override final  String title;
@override@JsonKey(name: "provider_id") final  String? providerId;
@override@JsonKey(name: "major_components") final  String? majorComponents;

/// Create a copy of LotItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LotItemCopyWith<_LotItem> get copyWith => __$LotItemCopyWithImpl<_LotItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LotItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LotItem&&(identical(other.lotItemId, lotItemId) || other.lotItemId == lotItemId)&&(identical(other.parentLotId, parentLotId) || other.parentLotId == parentLotId)&&(identical(other.status, status) || other.status == status)&&(identical(other.title, title) || other.title == title)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.majorComponents, majorComponents) || other.majorComponents == majorComponents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lotItemId,parentLotId,status,title,providerId,majorComponents);

@override
String toString() {
  return 'LotItem(lotItemId: $lotItemId, parentLotId: $parentLotId, status: $status, title: $title, providerId: $providerId, majorComponents: $majorComponents)';
}


}

/// @nodoc
abstract mixin class _$LotItemCopyWith<$Res> implements $LotItemCopyWith<$Res> {
  factory _$LotItemCopyWith(_LotItem value, $Res Function(_LotItem) _then) = __$LotItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "lot_item_id") String lotItemId,@JsonKey(name: "parent_lot_id") String parentLotId, String status, String title,@JsonKey(name: "provider_id") String? providerId,@JsonKey(name: "major_components") String? majorComponents
});




}
/// @nodoc
class __$LotItemCopyWithImpl<$Res>
    implements _$LotItemCopyWith<$Res> {
  __$LotItemCopyWithImpl(this._self, this._then);

  final _LotItem _self;
  final $Res Function(_LotItem) _then;

/// Create a copy of LotItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lotItemId = null,Object? parentLotId = null,Object? status = null,Object? title = null,Object? providerId = freezed,Object? majorComponents = freezed,}) {
  return _then(_LotItem(
lotItemId: null == lotItemId ? _self.lotItemId : lotItemId // ignore: cast_nullable_to_non_nullable
as String,parentLotId: null == parentLotId ? _self.parentLotId : parentLotId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,providerId: freezed == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String?,majorComponents: freezed == majorComponents ? _self.majorComponents : majorComponents // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
