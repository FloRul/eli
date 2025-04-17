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

 int get id; String get title; String get number; String get provider;@JsonKey(name: 'full_name', includeToJson: false, readValue: _readExpediter) String? get assignedToFullName;@JsonKey(name: 'email', includeToJson: false, readValue: _readExpediter) String? get assignedToEmail; String? get assignedExpediterId;@JsonKey(includeToJson: false, includeFromJson: true) List<LotItem> get lotItems;@JsonKey(includeToJson: false, includeFromJson: true) List<Deliverable> get deliverables;
/// Create a copy of Lot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LotCopyWith<Lot> get copyWith => _$LotCopyWithImpl<Lot>(this as Lot, _$identity);

  /// Serializes this Lot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Lot&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.number, number) || other.number == number)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.assignedToFullName, assignedToFullName) || other.assignedToFullName == assignedToFullName)&&(identical(other.assignedToEmail, assignedToEmail) || other.assignedToEmail == assignedToEmail)&&(identical(other.assignedExpediterId, assignedExpediterId) || other.assignedExpediterId == assignedExpediterId)&&const DeepCollectionEquality().equals(other.lotItems, lotItems)&&const DeepCollectionEquality().equals(other.deliverables, deliverables));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,number,provider,assignedToFullName,assignedToEmail,assignedExpediterId,const DeepCollectionEquality().hash(lotItems),const DeepCollectionEquality().hash(deliverables));

@override
String toString() {
  return 'Lot(id: $id, title: $title, number: $number, provider: $provider, assignedToFullName: $assignedToFullName, assignedToEmail: $assignedToEmail, assignedExpediterId: $assignedExpediterId, lotItems: $lotItems, deliverables: $deliverables)';
}


}

/// @nodoc
abstract mixin class $LotCopyWith<$Res>  {
  factory $LotCopyWith(Lot value, $Res Function(Lot) _then) = _$LotCopyWithImpl;
@useResult
$Res call({
 int id, String title, String number, String provider,@JsonKey(name: 'full_name', includeToJson: false, readValue: _readExpediter) String? assignedToFullName,@JsonKey(name: 'email', includeToJson: false, readValue: _readExpediter) String? assignedToEmail, String? assignedExpediterId,@JsonKey(includeToJson: false, includeFromJson: true) List<LotItem> lotItems,@JsonKey(includeToJson: false, includeFromJson: true) List<Deliverable> deliverables
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? number = null,Object? provider = null,Object? assignedToFullName = freezed,Object? assignedToEmail = freezed,Object? assignedExpediterId = freezed,Object? lotItems = null,Object? deliverables = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,assignedToFullName: freezed == assignedToFullName ? _self.assignedToFullName : assignedToFullName // ignore: cast_nullable_to_non_nullable
as String?,assignedToEmail: freezed == assignedToEmail ? _self.assignedToEmail : assignedToEmail // ignore: cast_nullable_to_non_nullable
as String?,assignedExpediterId: freezed == assignedExpediterId ? _self.assignedExpediterId : assignedExpediterId // ignore: cast_nullable_to_non_nullable
as String?,lotItems: null == lotItems ? _self.lotItems : lotItems // ignore: cast_nullable_to_non_nullable
as List<LotItem>,deliverables: null == deliverables ? _self.deliverables : deliverables // ignore: cast_nullable_to_non_nullable
as List<Deliverable>,
  ));
}

}


/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Lot extends Lot {
  const _Lot({required this.id, required this.title, required this.number, required this.provider, @JsonKey(name: 'full_name', includeToJson: false, readValue: _readExpediter) this.assignedToFullName, @JsonKey(name: 'email', includeToJson: false, readValue: _readExpediter) this.assignedToEmail, this.assignedExpediterId, @JsonKey(includeToJson: false, includeFromJson: true) final  List<LotItem> lotItems = const [], @JsonKey(includeToJson: false, includeFromJson: true) final  List<Deliverable> deliverables = const []}): _lotItems = lotItems,_deliverables = deliverables,super._();
  factory _Lot.fromJson(Map<String, dynamic> json) => _$LotFromJson(json);

@override final  int id;
@override final  String title;
@override final  String number;
@override final  String provider;
@override@JsonKey(name: 'full_name', includeToJson: false, readValue: _readExpediter) final  String? assignedToFullName;
@override@JsonKey(name: 'email', includeToJson: false, readValue: _readExpediter) final  String? assignedToEmail;
@override final  String? assignedExpediterId;
 final  List<LotItem> _lotItems;
@override@JsonKey(includeToJson: false, includeFromJson: true) List<LotItem> get lotItems {
  if (_lotItems is EqualUnmodifiableListView) return _lotItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lotItems);
}

 final  List<Deliverable> _deliverables;
@override@JsonKey(includeToJson: false, includeFromJson: true) List<Deliverable> get deliverables {
  if (_deliverables is EqualUnmodifiableListView) return _deliverables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_deliverables);
}


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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Lot&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.number, number) || other.number == number)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.assignedToFullName, assignedToFullName) || other.assignedToFullName == assignedToFullName)&&(identical(other.assignedToEmail, assignedToEmail) || other.assignedToEmail == assignedToEmail)&&(identical(other.assignedExpediterId, assignedExpediterId) || other.assignedExpediterId == assignedExpediterId)&&const DeepCollectionEquality().equals(other._lotItems, _lotItems)&&const DeepCollectionEquality().equals(other._deliverables, _deliverables));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,number,provider,assignedToFullName,assignedToEmail,assignedExpediterId,const DeepCollectionEquality().hash(_lotItems),const DeepCollectionEquality().hash(_deliverables));

@override
String toString() {
  return 'Lot(id: $id, title: $title, number: $number, provider: $provider, assignedToFullName: $assignedToFullName, assignedToEmail: $assignedToEmail, assignedExpediterId: $assignedExpediterId, lotItems: $lotItems, deliverables: $deliverables)';
}


}

/// @nodoc
abstract mixin class _$LotCopyWith<$Res> implements $LotCopyWith<$Res> {
  factory _$LotCopyWith(_Lot value, $Res Function(_Lot) _then) = __$LotCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String number, String provider,@JsonKey(name: 'full_name', includeToJson: false, readValue: _readExpediter) String? assignedToFullName,@JsonKey(name: 'email', includeToJson: false, readValue: _readExpediter) String? assignedToEmail, String? assignedExpediterId,@JsonKey(includeToJson: false, includeFromJson: true) List<LotItem> lotItems,@JsonKey(includeToJson: false, includeFromJson: true) List<Deliverable> deliverables
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? number = null,Object? provider = null,Object? assignedToFullName = freezed,Object? assignedToEmail = freezed,Object? assignedExpediterId = freezed,Object? lotItems = null,Object? deliverables = null,}) {
  return _then(_Lot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,assignedToFullName: freezed == assignedToFullName ? _self.assignedToFullName : assignedToFullName // ignore: cast_nullable_to_non_nullable
as String?,assignedToEmail: freezed == assignedToEmail ? _self.assignedToEmail : assignedToEmail // ignore: cast_nullable_to_non_nullable
as String?,assignedExpediterId: freezed == assignedExpediterId ? _self.assignedExpediterId : assignedExpediterId // ignore: cast_nullable_to_non_nullable
as String?,lotItems: null == lotItems ? _self._lotItems : lotItems // ignore: cast_nullable_to_non_nullable
as List<LotItem>,deliverables: null == deliverables ? _self._deliverables : deliverables // ignore: cast_nullable_to_non_nullable
as List<Deliverable>,
  ));
}


}

// dart format on
