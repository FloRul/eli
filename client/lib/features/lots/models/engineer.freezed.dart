// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'engineer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Engineer {

 String get name;@JsonKey(name: "engineer_id") String get engineerId; String? get email;
/// Create a copy of Engineer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EngineerCopyWith<Engineer> get copyWith => _$EngineerCopyWithImpl<Engineer>(this as Engineer, _$identity);

  /// Serializes this Engineer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Engineer&&(identical(other.name, name) || other.name == name)&&(identical(other.engineerId, engineerId) || other.engineerId == engineerId)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,engineerId,email);

@override
String toString() {
  return 'Engineer(name: $name, engineerId: $engineerId, email: $email)';
}


}

/// @nodoc
abstract mixin class $EngineerCopyWith<$Res>  {
  factory $EngineerCopyWith(Engineer value, $Res Function(Engineer) _then) = _$EngineerCopyWithImpl;
@useResult
$Res call({
 String name,@JsonKey(name: "engineer_id") String engineerId, String? email
});




}
/// @nodoc
class _$EngineerCopyWithImpl<$Res>
    implements $EngineerCopyWith<$Res> {
  _$EngineerCopyWithImpl(this._self, this._then);

  final Engineer _self;
  final $Res Function(Engineer) _then;

/// Create a copy of Engineer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? engineerId = null,Object? email = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,engineerId: null == engineerId ? _self.engineerId : engineerId // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Engineer implements Engineer {
  const _Engineer({required this.name, @JsonKey(name: "engineer_id") required this.engineerId, this.email});
  factory _Engineer.fromJson(Map<String, dynamic> json) => _$EngineerFromJson(json);

@override final  String name;
@override@JsonKey(name: "engineer_id") final  String engineerId;
@override final  String? email;

/// Create a copy of Engineer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EngineerCopyWith<_Engineer> get copyWith => __$EngineerCopyWithImpl<_Engineer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EngineerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Engineer&&(identical(other.name, name) || other.name == name)&&(identical(other.engineerId, engineerId) || other.engineerId == engineerId)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,engineerId,email);

@override
String toString() {
  return 'Engineer(name: $name, engineerId: $engineerId, email: $email)';
}


}

/// @nodoc
abstract mixin class _$EngineerCopyWith<$Res> implements $EngineerCopyWith<$Res> {
  factory _$EngineerCopyWith(_Engineer value, $Res Function(_Engineer) _then) = __$EngineerCopyWithImpl;
@override @useResult
$Res call({
 String name,@JsonKey(name: "engineer_id") String engineerId, String? email
});




}
/// @nodoc
class __$EngineerCopyWithImpl<$Res>
    implements _$EngineerCopyWith<$Res> {
  __$EngineerCopyWithImpl(this._self, this._then);

  final _Engineer _self;
  final $Res Function(_Engineer) _then;

/// Create a copy of Engineer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? engineerId = null,Object? email = freezed,}) {
  return _then(_Engineer(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,engineerId: null == engineerId ? _self.engineerId : engineerId // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
