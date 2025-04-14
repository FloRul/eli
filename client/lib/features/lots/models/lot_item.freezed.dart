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

 int get id; int get parentLotId; String? get title; String? get quantity; DateTime? get endManufacturingDate; DateTime? get readyToShipDate; DateTime? get plannedDeliveryDate; int get purchasingProgress; int get engineeringProgress; int get manufacturingProgress; String? get originCountry;@JsonKey(fromJson: Incoterm.fromString) Incoterm get incoterms; String? get comments; DateTime? get requiredOnSiteDate;@JsonKey(fromJson: Status.fromString) Status get status;
/// Create a copy of LotItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LotItemCopyWith<LotItem> get copyWith => _$LotItemCopyWithImpl<LotItem>(this as LotItem, _$identity);

  /// Serializes this LotItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LotItem&&(identical(other.id, id) || other.id == id)&&(identical(other.parentLotId, parentLotId) || other.parentLotId == parentLotId)&&(identical(other.title, title) || other.title == title)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.endManufacturingDate, endManufacturingDate) || other.endManufacturingDate == endManufacturingDate)&&(identical(other.readyToShipDate, readyToShipDate) || other.readyToShipDate == readyToShipDate)&&(identical(other.plannedDeliveryDate, plannedDeliveryDate) || other.plannedDeliveryDate == plannedDeliveryDate)&&(identical(other.purchasingProgress, purchasingProgress) || other.purchasingProgress == purchasingProgress)&&(identical(other.engineeringProgress, engineeringProgress) || other.engineeringProgress == engineeringProgress)&&(identical(other.manufacturingProgress, manufacturingProgress) || other.manufacturingProgress == manufacturingProgress)&&(identical(other.originCountry, originCountry) || other.originCountry == originCountry)&&(identical(other.incoterms, incoterms) || other.incoterms == incoterms)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.requiredOnSiteDate, requiredOnSiteDate) || other.requiredOnSiteDate == requiredOnSiteDate)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,parentLotId,title,quantity,endManufacturingDate,readyToShipDate,plannedDeliveryDate,purchasingProgress,engineeringProgress,manufacturingProgress,originCountry,incoterms,comments,requiredOnSiteDate,status);

@override
String toString() {
  return 'LotItem(id: $id, parentLotId: $parentLotId, title: $title, quantity: $quantity, endManufacturingDate: $endManufacturingDate, readyToShipDate: $readyToShipDate, plannedDeliveryDate: $plannedDeliveryDate, purchasingProgress: $purchasingProgress, engineeringProgress: $engineeringProgress, manufacturingProgress: $manufacturingProgress, originCountry: $originCountry, incoterms: $incoterms, comments: $comments, requiredOnSiteDate: $requiredOnSiteDate, status: $status)';
}


}

/// @nodoc
abstract mixin class $LotItemCopyWith<$Res>  {
  factory $LotItemCopyWith(LotItem value, $Res Function(LotItem) _then) = _$LotItemCopyWithImpl;
@useResult
$Res call({
 int id, int parentLotId, String? title, String? quantity, DateTime? endManufacturingDate, DateTime? readyToShipDate, DateTime? plannedDeliveryDate, int purchasingProgress, int engineeringProgress, int manufacturingProgress, String? originCountry,@JsonKey(fromJson: Incoterm.fromString) Incoterm incoterms, String? comments, DateTime? requiredOnSiteDate,@JsonKey(fromJson: Status.fromString) Status status
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? parentLotId = null,Object? title = freezed,Object? quantity = freezed,Object? endManufacturingDate = freezed,Object? readyToShipDate = freezed,Object? plannedDeliveryDate = freezed,Object? purchasingProgress = null,Object? engineeringProgress = null,Object? manufacturingProgress = null,Object? originCountry = freezed,Object? incoterms = null,Object? comments = freezed,Object? requiredOnSiteDate = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,parentLotId: null == parentLotId ? _self.parentLotId : parentLotId // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String?,endManufacturingDate: freezed == endManufacturingDate ? _self.endManufacturingDate : endManufacturingDate // ignore: cast_nullable_to_non_nullable
as DateTime?,readyToShipDate: freezed == readyToShipDate ? _self.readyToShipDate : readyToShipDate // ignore: cast_nullable_to_non_nullable
as DateTime?,plannedDeliveryDate: freezed == plannedDeliveryDate ? _self.plannedDeliveryDate : plannedDeliveryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,purchasingProgress: null == purchasingProgress ? _self.purchasingProgress : purchasingProgress // ignore: cast_nullable_to_non_nullable
as int,engineeringProgress: null == engineeringProgress ? _self.engineeringProgress : engineeringProgress // ignore: cast_nullable_to_non_nullable
as int,manufacturingProgress: null == manufacturingProgress ? _self.manufacturingProgress : manufacturingProgress // ignore: cast_nullable_to_non_nullable
as int,originCountry: freezed == originCountry ? _self.originCountry : originCountry // ignore: cast_nullable_to_non_nullable
as String?,incoterms: null == incoterms ? _self.incoterms : incoterms // ignore: cast_nullable_to_non_nullable
as Incoterm,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,requiredOnSiteDate: freezed == requiredOnSiteDate ? _self.requiredOnSiteDate : requiredOnSiteDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,
  ));
}

}


/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _LotItem extends LotItem {
  const _LotItem({required this.id, required this.parentLotId, this.title, this.quantity, this.endManufacturingDate, this.readyToShipDate, this.plannedDeliveryDate, required this.purchasingProgress, required this.engineeringProgress, required this.manufacturingProgress, this.originCountry, @JsonKey(fromJson: Incoterm.fromString) required this.incoterms, this.comments, this.requiredOnSiteDate, @JsonKey(fromJson: Status.fromString) required this.status}): super._();
  factory _LotItem.fromJson(Map<String, dynamic> json) => _$LotItemFromJson(json);

@override final  int id;
@override final  int parentLotId;
@override final  String? title;
@override final  String? quantity;
@override final  DateTime? endManufacturingDate;
@override final  DateTime? readyToShipDate;
@override final  DateTime? plannedDeliveryDate;
@override final  int purchasingProgress;
@override final  int engineeringProgress;
@override final  int manufacturingProgress;
@override final  String? originCountry;
@override@JsonKey(fromJson: Incoterm.fromString) final  Incoterm incoterms;
@override final  String? comments;
@override final  DateTime? requiredOnSiteDate;
@override@JsonKey(fromJson: Status.fromString) final  Status status;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LotItem&&(identical(other.id, id) || other.id == id)&&(identical(other.parentLotId, parentLotId) || other.parentLotId == parentLotId)&&(identical(other.title, title) || other.title == title)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.endManufacturingDate, endManufacturingDate) || other.endManufacturingDate == endManufacturingDate)&&(identical(other.readyToShipDate, readyToShipDate) || other.readyToShipDate == readyToShipDate)&&(identical(other.plannedDeliveryDate, plannedDeliveryDate) || other.plannedDeliveryDate == plannedDeliveryDate)&&(identical(other.purchasingProgress, purchasingProgress) || other.purchasingProgress == purchasingProgress)&&(identical(other.engineeringProgress, engineeringProgress) || other.engineeringProgress == engineeringProgress)&&(identical(other.manufacturingProgress, manufacturingProgress) || other.manufacturingProgress == manufacturingProgress)&&(identical(other.originCountry, originCountry) || other.originCountry == originCountry)&&(identical(other.incoterms, incoterms) || other.incoterms == incoterms)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.requiredOnSiteDate, requiredOnSiteDate) || other.requiredOnSiteDate == requiredOnSiteDate)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,parentLotId,title,quantity,endManufacturingDate,readyToShipDate,plannedDeliveryDate,purchasingProgress,engineeringProgress,manufacturingProgress,originCountry,incoterms,comments,requiredOnSiteDate,status);

@override
String toString() {
  return 'LotItem(id: $id, parentLotId: $parentLotId, title: $title, quantity: $quantity, endManufacturingDate: $endManufacturingDate, readyToShipDate: $readyToShipDate, plannedDeliveryDate: $plannedDeliveryDate, purchasingProgress: $purchasingProgress, engineeringProgress: $engineeringProgress, manufacturingProgress: $manufacturingProgress, originCountry: $originCountry, incoterms: $incoterms, comments: $comments, requiredOnSiteDate: $requiredOnSiteDate, status: $status)';
}


}

/// @nodoc
abstract mixin class _$LotItemCopyWith<$Res> implements $LotItemCopyWith<$Res> {
  factory _$LotItemCopyWith(_LotItem value, $Res Function(_LotItem) _then) = __$LotItemCopyWithImpl;
@override @useResult
$Res call({
 int id, int parentLotId, String? title, String? quantity, DateTime? endManufacturingDate, DateTime? readyToShipDate, DateTime? plannedDeliveryDate, int purchasingProgress, int engineeringProgress, int manufacturingProgress, String? originCountry,@JsonKey(fromJson: Incoterm.fromString) Incoterm incoterms, String? comments, DateTime? requiredOnSiteDate,@JsonKey(fromJson: Status.fromString) Status status
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? parentLotId = null,Object? title = freezed,Object? quantity = freezed,Object? endManufacturingDate = freezed,Object? readyToShipDate = freezed,Object? plannedDeliveryDate = freezed,Object? purchasingProgress = null,Object? engineeringProgress = null,Object? manufacturingProgress = null,Object? originCountry = freezed,Object? incoterms = null,Object? comments = freezed,Object? requiredOnSiteDate = freezed,Object? status = null,}) {
  return _then(_LotItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,parentLotId: null == parentLotId ? _self.parentLotId : parentLotId // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String?,endManufacturingDate: freezed == endManufacturingDate ? _self.endManufacturingDate : endManufacturingDate // ignore: cast_nullable_to_non_nullable
as DateTime?,readyToShipDate: freezed == readyToShipDate ? _self.readyToShipDate : readyToShipDate // ignore: cast_nullable_to_non_nullable
as DateTime?,plannedDeliveryDate: freezed == plannedDeliveryDate ? _self.plannedDeliveryDate : plannedDeliveryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,purchasingProgress: null == purchasingProgress ? _self.purchasingProgress : purchasingProgress // ignore: cast_nullable_to_non_nullable
as int,engineeringProgress: null == engineeringProgress ? _self.engineeringProgress : engineeringProgress // ignore: cast_nullable_to_non_nullable
as int,manufacturingProgress: null == manufacturingProgress ? _self.manufacturingProgress : manufacturingProgress // ignore: cast_nullable_to_non_nullable
as int,originCountry: freezed == originCountry ? _self.originCountry : originCountry // ignore: cast_nullable_to_non_nullable
as String?,incoterms: null == incoterms ? _self.incoterms : incoterms // ignore: cast_nullable_to_non_nullable
as Incoterm,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,requiredOnSiteDate: freezed == requiredOnSiteDate ? _self.requiredOnSiteDate : requiredOnSiteDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,
  ));
}


}

// dart format on
