// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deliverable.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Deliverable {

 int get id; int get parentLotId; String get title; DateTime get dueDate; bool get isReceived;
/// Create a copy of Deliverable
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliverableCopyWith<Deliverable> get copyWith => _$DeliverableCopyWithImpl<Deliverable>(this as Deliverable, _$identity);

  /// Serializes this Deliverable to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Deliverable&&(identical(other.id, id) || other.id == id)&&(identical(other.parentLotId, parentLotId) || other.parentLotId == parentLotId)&&(identical(other.title, title) || other.title == title)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.isReceived, isReceived) || other.isReceived == isReceived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,parentLotId,title,dueDate,isReceived);

@override
String toString() {
  return 'Deliverable(id: $id, parentLotId: $parentLotId, title: $title, dueDate: $dueDate, isReceived: $isReceived)';
}


}

/// @nodoc
abstract mixin class $DeliverableCopyWith<$Res>  {
  factory $DeliverableCopyWith(Deliverable value, $Res Function(Deliverable) _then) = _$DeliverableCopyWithImpl;
@useResult
$Res call({
 int id, int parentLotId, String title, DateTime dueDate, bool isReceived
});




}
/// @nodoc
class _$DeliverableCopyWithImpl<$Res>
    implements $DeliverableCopyWith<$Res> {
  _$DeliverableCopyWithImpl(this._self, this._then);

  final Deliverable _self;
  final $Res Function(Deliverable) _then;

/// Create a copy of Deliverable
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? parentLotId = null,Object? title = null,Object? dueDate = null,Object? isReceived = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,parentLotId: null == parentLotId ? _self.parentLotId : parentLotId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,isReceived: null == isReceived ? _self.isReceived : isReceived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _Deliverable implements Deliverable {
  const _Deliverable({required this.id, required this.parentLotId, required this.title, required this.dueDate, required this.isReceived});
  factory _Deliverable.fromJson(Map<String, dynamic> json) => _$DeliverableFromJson(json);

@override final  int id;
@override final  int parentLotId;
@override final  String title;
@override final  DateTime dueDate;
@override final  bool isReceived;

/// Create a copy of Deliverable
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeliverableCopyWith<_Deliverable> get copyWith => __$DeliverableCopyWithImpl<_Deliverable>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeliverableToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Deliverable&&(identical(other.id, id) || other.id == id)&&(identical(other.parentLotId, parentLotId) || other.parentLotId == parentLotId)&&(identical(other.title, title) || other.title == title)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.isReceived, isReceived) || other.isReceived == isReceived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,parentLotId,title,dueDate,isReceived);

@override
String toString() {
  return 'Deliverable(id: $id, parentLotId: $parentLotId, title: $title, dueDate: $dueDate, isReceived: $isReceived)';
}


}

/// @nodoc
abstract mixin class _$DeliverableCopyWith<$Res> implements $DeliverableCopyWith<$Res> {
  factory _$DeliverableCopyWith(_Deliverable value, $Res Function(_Deliverable) _then) = __$DeliverableCopyWithImpl;
@override @useResult
$Res call({
 int id, int parentLotId, String title, DateTime dueDate, bool isReceived
});




}
/// @nodoc
class __$DeliverableCopyWithImpl<$Res>
    implements _$DeliverableCopyWith<$Res> {
  __$DeliverableCopyWithImpl(this._self, this._then);

  final _Deliverable _self;
  final $Res Function(_Deliverable) _then;

/// Create a copy of Deliverable
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? parentLotId = null,Object? title = null,Object? dueDate = null,Object? isReceived = null,}) {
  return _then(_Deliverable(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,parentLotId: null == parentLotId ? _self.parentLotId : parentLotId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,isReceived: null == isReceived ? _self.isReceived : isReceived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
