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

 int get id; String get title; String get number; String get provider;@NestedJsonKey(name: 'user_profiles/full_name') String? get assignedToFullName;@NestedJsonKey(name: 'user_profiles/email') String? get assignedToEmail;@NestedJsonKey(name: 'user_profiles/id') String? get assignedExpediterId;// Items list will be populated by the provider
 List<LotItem> get items; List<Deliverable> get deliverables;
/// Create a copy of Lot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LotCopyWith<Lot> get copyWith => _$LotCopyWithImpl<Lot>(this as Lot, _$identity);

  /// Serializes this Lot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Lot&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.number, number) || other.number == number)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.assignedToFullName, assignedToFullName) || other.assignedToFullName == assignedToFullName)&&(identical(other.assignedToEmail, assignedToEmail) || other.assignedToEmail == assignedToEmail)&&(identical(other.assignedExpediterId, assignedExpediterId) || other.assignedExpediterId == assignedExpediterId)&&const DeepCollectionEquality().equals(other.items, items)&&const DeepCollectionEquality().equals(other.deliverables, deliverables));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,number,provider,assignedToFullName,assignedToEmail,assignedExpediterId,const DeepCollectionEquality().hash(items),const DeepCollectionEquality().hash(deliverables));

@override
String toString() {
  return 'Lot(id: $id, title: $title, number: $number, provider: $provider, assignedToFullName: $assignedToFullName, assignedToEmail: $assignedToEmail, assignedExpediterId: $assignedExpediterId, items: $items, deliverables: $deliverables)';
}


}

/// @nodoc
abstract mixin class $LotCopyWith<$Res>  {
  factory $LotCopyWith(Lot value, $Res Function(Lot) _then) = _$LotCopyWithImpl;
@useResult
$Res call({
 int id, String title, String number, String provider,@NestedJsonKey(name: 'user_profiles/full_name') String? assignedToFullName,@NestedJsonKey(name: 'user_profiles/email') String? assignedToEmail,@NestedJsonKey(name: 'user_profiles/id') String? assignedExpediterId, List<LotItem> items, List<Deliverable> deliverables
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? number = null,Object? provider = null,Object? assignedToFullName = freezed,Object? assignedToEmail = freezed,Object? assignedExpediterId = freezed,Object? items = null,Object? deliverables = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,assignedToFullName: freezed == assignedToFullName ? _self.assignedToFullName : assignedToFullName // ignore: cast_nullable_to_non_nullable
as String?,assignedToEmail: freezed == assignedToEmail ? _self.assignedToEmail : assignedToEmail // ignore: cast_nullable_to_non_nullable
as String?,assignedExpediterId: freezed == assignedExpediterId ? _self.assignedExpediterId : assignedExpediterId // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<LotItem>,deliverables: null == deliverables ? _self.deliverables : deliverables // ignore: cast_nullable_to_non_nullable
as List<Deliverable>,
  ));
}

}


/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _Lot extends Lot {
  const _Lot({required this.id, required this.title, required this.number, required this.provider, @NestedJsonKey(name: 'user_profiles/full_name') this.assignedToFullName, @NestedJsonKey(name: 'user_profiles/email') this.assignedToEmail, @NestedJsonKey(name: 'user_profiles/id') this.assignedExpediterId, final  List<LotItem> items = const [], final  List<Deliverable> deliverables = const []}): _items = items,_deliverables = deliverables,super._();
  factory _Lot.fromJson(Map<String, dynamic> json) => _$LotFromJson(json);

@override final  int id;
@override final  String title;
@override final  String number;
@override final  String provider;
@override@NestedJsonKey(name: 'user_profiles/full_name') final  String? assignedToFullName;
@override@NestedJsonKey(name: 'user_profiles/email') final  String? assignedToEmail;
@override@NestedJsonKey(name: 'user_profiles/id') final  String? assignedExpediterId;
// Items list will be populated by the provider
 final  List<LotItem> _items;
// Items list will be populated by the provider
@override@JsonKey() List<LotItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  List<Deliverable> _deliverables;
@override@JsonKey() List<Deliverable> get deliverables {
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Lot&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.number, number) || other.number == number)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.assignedToFullName, assignedToFullName) || other.assignedToFullName == assignedToFullName)&&(identical(other.assignedToEmail, assignedToEmail) || other.assignedToEmail == assignedToEmail)&&(identical(other.assignedExpediterId, assignedExpediterId) || other.assignedExpediterId == assignedExpediterId)&&const DeepCollectionEquality().equals(other._items, _items)&&const DeepCollectionEquality().equals(other._deliverables, _deliverables));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,number,provider,assignedToFullName,assignedToEmail,assignedExpediterId,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_deliverables));

@override
String toString() {
  return 'Lot(id: $id, title: $title, number: $number, provider: $provider, assignedToFullName: $assignedToFullName, assignedToEmail: $assignedToEmail, assignedExpediterId: $assignedExpediterId, items: $items, deliverables: $deliverables)';
}


}

/// @nodoc
abstract mixin class _$LotCopyWith<$Res> implements $LotCopyWith<$Res> {
  factory _$LotCopyWith(_Lot value, $Res Function(_Lot) _then) = __$LotCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String number, String provider,@NestedJsonKey(name: 'user_profiles/full_name') String? assignedToFullName,@NestedJsonKey(name: 'user_profiles/email') String? assignedToEmail,@NestedJsonKey(name: 'user_profiles/id') String? assignedExpediterId, List<LotItem> items, List<Deliverable> deliverables
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? number = null,Object? provider = null,Object? assignedToFullName = freezed,Object? assignedToEmail = freezed,Object? assignedExpediterId = freezed,Object? items = null,Object? deliverables = null,}) {
  return _then(_Lot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,assignedToFullName: freezed == assignedToFullName ? _self.assignedToFullName : assignedToFullName // ignore: cast_nullable_to_non_nullable
as String?,assignedToEmail: freezed == assignedToEmail ? _self.assignedToEmail : assignedToEmail // ignore: cast_nullable_to_non_nullable
as String?,assignedExpediterId: freezed == assignedExpediterId ? _self.assignedExpediterId : assignedExpediterId // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<LotItem>,deliverables: null == deliverables ? _self._deliverables : deliverables // ignore: cast_nullable_to_non_nullable
as List<Deliverable>,
  ));
}


}

// dart format on
