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
mixin _$TenantUser {

 String get userId;// Dart: camelCase
 Role get role; String? get email; String get firstName; String get lastName;
/// Create a copy of TenantUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TenantUserCopyWith<TenantUser> get copyWith => _$TenantUserCopyWithImpl<TenantUser>(this as TenantUser, _$identity);

  /// Serializes this TenantUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TenantUser&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,role,email,firstName,lastName);

@override
String toString() {
  return 'TenantUser(userId: $userId, role: $role, email: $email, firstName: $firstName, lastName: $lastName)';
}


}

/// @nodoc
abstract mixin class $TenantUserCopyWith<$Res>  {
  factory $TenantUserCopyWith(TenantUser value, $Res Function(TenantUser) _then) = _$TenantUserCopyWithImpl;
@useResult
$Res call({
 String userId, Role role, String? email, String firstName, String lastName
});




}
/// @nodoc
class _$TenantUserCopyWithImpl<$Res>
    implements $TenantUserCopyWith<$Res> {
  _$TenantUserCopyWithImpl(this._self, this._then);

  final TenantUser _self;
  final $Res Function(TenantUser) _then;

/// Create a copy of TenantUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? role = null,Object? email = freezed,Object? firstName = null,Object? lastName = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as Role,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _TenantUser implements TenantUser {
  const _TenantUser({required this.userId, required this.role, this.email, required this.firstName, required this.lastName});
  factory _TenantUser.fromJson(Map<String, dynamic> json) => _$TenantUserFromJson(json);

@override final  String userId;
// Dart: camelCase
@override final  Role role;
@override final  String? email;
@override final  String firstName;
@override final  String lastName;

/// Create a copy of TenantUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TenantUserCopyWith<_TenantUser> get copyWith => __$TenantUserCopyWithImpl<_TenantUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TenantUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TenantUser&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,role,email,firstName,lastName);

@override
String toString() {
  return 'TenantUser(userId: $userId, role: $role, email: $email, firstName: $firstName, lastName: $lastName)';
}


}

/// @nodoc
abstract mixin class _$TenantUserCopyWith<$Res> implements $TenantUserCopyWith<$Res> {
  factory _$TenantUserCopyWith(_TenantUser value, $Res Function(_TenantUser) _then) = __$TenantUserCopyWithImpl;
@override @useResult
$Res call({
 String userId, Role role, String? email, String firstName, String lastName
});




}
/// @nodoc
class __$TenantUserCopyWithImpl<$Res>
    implements _$TenantUserCopyWith<$Res> {
  __$TenantUserCopyWithImpl(this._self, this._then);

  final _TenantUser _self;
  final $Res Function(_TenantUser) _then;

/// Create a copy of TenantUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? role = null,Object? email = freezed,Object? firstName = null,Object? lastName = null,}) {
  return _then(_TenantUser(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as Role,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
