// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'access.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserCompanyAccess {

 String get userId; int get companyId;
/// Create a copy of UserCompanyAccess
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCompanyAccessCopyWith<UserCompanyAccess> get copyWith => _$UserCompanyAccessCopyWithImpl<UserCompanyAccess>(this as UserCompanyAccess, _$identity);

  /// Serializes this UserCompanyAccess to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserCompanyAccess&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.companyId, companyId) || other.companyId == companyId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,companyId);

@override
String toString() {
  return 'UserCompanyAccess(userId: $userId, companyId: $companyId)';
}


}

/// @nodoc
abstract mixin class $UserCompanyAccessCopyWith<$Res>  {
  factory $UserCompanyAccessCopyWith(UserCompanyAccess value, $Res Function(UserCompanyAccess) _then) = _$UserCompanyAccessCopyWithImpl;
@useResult
$Res call({
 String userId, int companyId
});




}
/// @nodoc
class _$UserCompanyAccessCopyWithImpl<$Res>
    implements $UserCompanyAccessCopyWith<$Res> {
  _$UserCompanyAccessCopyWithImpl(this._self, this._then);

  final UserCompanyAccess _self;
  final $Res Function(UserCompanyAccess) _then;

/// Create a copy of UserCompanyAccess
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? companyId = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,companyId: null == companyId ? _self.companyId : companyId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _UserCompanyAccess implements UserCompanyAccess {
  const _UserCompanyAccess({required this.userId, required this.companyId});
  factory _UserCompanyAccess.fromJson(Map<String, dynamic> json) => _$UserCompanyAccessFromJson(json);

@override final  String userId;
@override final  int companyId;

/// Create a copy of UserCompanyAccess
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCompanyAccessCopyWith<_UserCompanyAccess> get copyWith => __$UserCompanyAccessCopyWithImpl<_UserCompanyAccess>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserCompanyAccessToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserCompanyAccess&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.companyId, companyId) || other.companyId == companyId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,companyId);

@override
String toString() {
  return 'UserCompanyAccess(userId: $userId, companyId: $companyId)';
}


}

/// @nodoc
abstract mixin class _$UserCompanyAccessCopyWith<$Res> implements $UserCompanyAccessCopyWith<$Res> {
  factory _$UserCompanyAccessCopyWith(_UserCompanyAccess value, $Res Function(_UserCompanyAccess) _then) = __$UserCompanyAccessCopyWithImpl;
@override @useResult
$Res call({
 String userId, int companyId
});




}
/// @nodoc
class __$UserCompanyAccessCopyWithImpl<$Res>
    implements _$UserCompanyAccessCopyWith<$Res> {
  __$UserCompanyAccessCopyWithImpl(this._self, this._then);

  final _UserCompanyAccess _self;
  final $Res Function(_UserCompanyAccess) _then;

/// Create a copy of UserCompanyAccess
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? companyId = null,}) {
  return _then(_UserCompanyAccess(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,companyId: null == companyId ? _self.companyId : companyId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$UserProjectAccess {

 String get userId; int get projectId;
/// Create a copy of UserProjectAccess
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProjectAccessCopyWith<UserProjectAccess> get copyWith => _$UserProjectAccessCopyWithImpl<UserProjectAccess>(this as UserProjectAccess, _$identity);

  /// Serializes this UserProjectAccess to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProjectAccess&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.projectId, projectId) || other.projectId == projectId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,projectId);

@override
String toString() {
  return 'UserProjectAccess(userId: $userId, projectId: $projectId)';
}


}

/// @nodoc
abstract mixin class $UserProjectAccessCopyWith<$Res>  {
  factory $UserProjectAccessCopyWith(UserProjectAccess value, $Res Function(UserProjectAccess) _then) = _$UserProjectAccessCopyWithImpl;
@useResult
$Res call({
 String userId, int projectId
});




}
/// @nodoc
class _$UserProjectAccessCopyWithImpl<$Res>
    implements $UserProjectAccessCopyWith<$Res> {
  _$UserProjectAccessCopyWithImpl(this._self, this._then);

  final UserProjectAccess _self;
  final $Res Function(UserProjectAccess) _then;

/// Create a copy of UserProjectAccess
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? projectId = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _UserProjectAccess implements UserProjectAccess {
  const _UserProjectAccess({required this.userId, required this.projectId});
  factory _UserProjectAccess.fromJson(Map<String, dynamic> json) => _$UserProjectAccessFromJson(json);

@override final  String userId;
@override final  int projectId;

/// Create a copy of UserProjectAccess
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProjectAccessCopyWith<_UserProjectAccess> get copyWith => __$UserProjectAccessCopyWithImpl<_UserProjectAccess>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProjectAccessToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProjectAccess&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.projectId, projectId) || other.projectId == projectId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,projectId);

@override
String toString() {
  return 'UserProjectAccess(userId: $userId, projectId: $projectId)';
}


}

/// @nodoc
abstract mixin class _$UserProjectAccessCopyWith<$Res> implements $UserProjectAccessCopyWith<$Res> {
  factory _$UserProjectAccessCopyWith(_UserProjectAccess value, $Res Function(_UserProjectAccess) _then) = __$UserProjectAccessCopyWithImpl;
@override @useResult
$Res call({
 String userId, int projectId
});




}
/// @nodoc
class __$UserProjectAccessCopyWithImpl<$Res>
    implements _$UserProjectAccessCopyWith<$Res> {
  __$UserProjectAccessCopyWithImpl(this._self, this._then);

  final _UserProjectAccess _self;
  final $Res Function(_UserProjectAccess) _then;

/// Create a copy of UserProjectAccess
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? projectId = null,}) {
  return _then(_UserProjectAccess(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
