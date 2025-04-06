// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserWithRole {

 String get firstName; String get lastName; Role get role;
/// Create a copy of UserWithRole
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserWithRoleCopyWith<UserWithRole> get copyWith => _$UserWithRoleCopyWithImpl<UserWithRole>(this as UserWithRole, _$identity);

  /// Serializes this UserWithRole to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserWithRole&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,role);

@override
String toString() {
  return 'UserWithRole(firstName: $firstName, lastName: $lastName, role: $role)';
}


}

/// @nodoc
abstract mixin class $UserWithRoleCopyWith<$Res>  {
  factory $UserWithRoleCopyWith(UserWithRole value, $Res Function(UserWithRole) _then) = _$UserWithRoleCopyWithImpl;
@useResult
$Res call({
 String firstName, String lastName, Role role
});




}
/// @nodoc
class _$UserWithRoleCopyWithImpl<$Res>
    implements $UserWithRoleCopyWith<$Res> {
  _$UserWithRoleCopyWithImpl(this._self, this._then);

  final UserWithRole _self;
  final $Res Function(UserWithRole) _then;

/// Create a copy of UserWithRole
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? firstName = null,Object? lastName = null,Object? role = null,}) {
  return _then(_self.copyWith(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as Role,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _UserWithRole implements UserWithRole {
  const _UserWithRole({required this.firstName, required this.lastName, required this.role});
  factory _UserWithRole.fromJson(Map<String, dynamic> json) => _$UserWithRoleFromJson(json);

@override final  String firstName;
@override final  String lastName;
@override final  Role role;

/// Create a copy of UserWithRole
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserWithRoleCopyWith<_UserWithRole> get copyWith => __$UserWithRoleCopyWithImpl<_UserWithRole>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserWithRoleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserWithRole&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,role);

@override
String toString() {
  return 'UserWithRole(firstName: $firstName, lastName: $lastName, role: $role)';
}


}

/// @nodoc
abstract mixin class _$UserWithRoleCopyWith<$Res> implements $UserWithRoleCopyWith<$Res> {
  factory _$UserWithRoleCopyWith(_UserWithRole value, $Res Function(_UserWithRole) _then) = __$UserWithRoleCopyWithImpl;
@override @useResult
$Res call({
 String firstName, String lastName, Role role
});




}
/// @nodoc
class __$UserWithRoleCopyWithImpl<$Res>
    implements _$UserWithRoleCopyWith<$Res> {
  __$UserWithRoleCopyWithImpl(this._self, this._then);

  final _UserWithRole _self;
  final $Res Function(_UserWithRole) _then;

/// Create a copy of UserWithRole
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? firstName = null,Object? lastName = null,Object? role = null,}) {
  return _then(_UserWithRole(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as Role,
  ));
}


}

// dart format on
