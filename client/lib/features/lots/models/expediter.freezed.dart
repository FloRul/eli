// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expediter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Expediter {

@JsonKey(name: "expediter_id") String get expediterId; String get name; String? get email;
/// Create a copy of Expediter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpediterCopyWith<Expediter> get copyWith => _$ExpediterCopyWithImpl<Expediter>(this as Expediter, _$identity);

  /// Serializes this Expediter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Expediter&&(identical(other.expediterId, expediterId) || other.expediterId == expediterId)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,expediterId,name,email);

@override
String toString() {
  return 'Expediter(expediterId: $expediterId, name: $name, email: $email)';
}


}

/// @nodoc
abstract mixin class $ExpediterCopyWith<$Res>  {
  factory $ExpediterCopyWith(Expediter value, $Res Function(Expediter) _then) = _$ExpediterCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "expediter_id") String expediterId, String name, String? email
});




}
/// @nodoc
class _$ExpediterCopyWithImpl<$Res>
    implements $ExpediterCopyWith<$Res> {
  _$ExpediterCopyWithImpl(this._self, this._then);

  final Expediter _self;
  final $Res Function(Expediter) _then;

/// Create a copy of Expediter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? expediterId = null,Object? name = null,Object? email = freezed,}) {
  return _then(_self.copyWith(
expediterId: null == expediterId ? _self.expediterId : expediterId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Expediter implements Expediter {
  const _Expediter({@JsonKey(name: "expediter_id") required this.expediterId, required this.name, this.email});
  factory _Expediter.fromJson(Map<String, dynamic> json) => _$ExpediterFromJson(json);

@override@JsonKey(name: "expediter_id") final  String expediterId;
@override final  String name;
@override final  String? email;

/// Create a copy of Expediter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpediterCopyWith<_Expediter> get copyWith => __$ExpediterCopyWithImpl<_Expediter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpediterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Expediter&&(identical(other.expediterId, expediterId) || other.expediterId == expediterId)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,expediterId,name,email);

@override
String toString() {
  return 'Expediter(expediterId: $expediterId, name: $name, email: $email)';
}


}

/// @nodoc
abstract mixin class _$ExpediterCopyWith<$Res> implements $ExpediterCopyWith<$Res> {
  factory _$ExpediterCopyWith(_Expediter value, $Res Function(_Expediter) _then) = __$ExpediterCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "expediter_id") String expediterId, String name, String? email
});




}
/// @nodoc
class __$ExpediterCopyWithImpl<$Res>
    implements _$ExpediterCopyWith<$Res> {
  __$ExpediterCopyWithImpl(this._self, this._then);

  final _Expediter _self;
  final $Res Function(_Expediter) _then;

/// Create a copy of Expediter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? expediterId = null,Object? name = null,Object? email = freezed,}) {
  return _then(_Expediter(
expediterId: null == expediterId ? _self.expediterId : expediterId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
