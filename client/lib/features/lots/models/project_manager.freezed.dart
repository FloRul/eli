// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_manager.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectManager {

@JsonKey(name: "project_manager_id") String get projectManagerId; String get name; String? get email;
/// Create a copy of ProjectManager
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectManagerCopyWith<ProjectManager> get copyWith => _$ProjectManagerCopyWithImpl<ProjectManager>(this as ProjectManager, _$identity);

  /// Serializes this ProjectManager to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectManager&&(identical(other.projectManagerId, projectManagerId) || other.projectManagerId == projectManagerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,projectManagerId,name,email);

@override
String toString() {
  return 'ProjectManager(projectManagerId: $projectManagerId, name: $name, email: $email)';
}


}

/// @nodoc
abstract mixin class $ProjectManagerCopyWith<$Res>  {
  factory $ProjectManagerCopyWith(ProjectManager value, $Res Function(ProjectManager) _then) = _$ProjectManagerCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "project_manager_id") String projectManagerId, String name, String? email
});




}
/// @nodoc
class _$ProjectManagerCopyWithImpl<$Res>
    implements $ProjectManagerCopyWith<$Res> {
  _$ProjectManagerCopyWithImpl(this._self, this._then);

  final ProjectManager _self;
  final $Res Function(ProjectManager) _then;

/// Create a copy of ProjectManager
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? projectManagerId = null,Object? name = null,Object? email = freezed,}) {
  return _then(_self.copyWith(
projectManagerId: null == projectManagerId ? _self.projectManagerId : projectManagerId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ProjectManager implements ProjectManager {
  const _ProjectManager({@JsonKey(name: "project_manager_id") required this.projectManagerId, required this.name, this.email});
  factory _ProjectManager.fromJson(Map<String, dynamic> json) => _$ProjectManagerFromJson(json);

@override@JsonKey(name: "project_manager_id") final  String projectManagerId;
@override final  String name;
@override final  String? email;

/// Create a copy of ProjectManager
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectManagerCopyWith<_ProjectManager> get copyWith => __$ProjectManagerCopyWithImpl<_ProjectManager>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectManagerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectManager&&(identical(other.projectManagerId, projectManagerId) || other.projectManagerId == projectManagerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,projectManagerId,name,email);

@override
String toString() {
  return 'ProjectManager(projectManagerId: $projectManagerId, name: $name, email: $email)';
}


}

/// @nodoc
abstract mixin class _$ProjectManagerCopyWith<$Res> implements $ProjectManagerCopyWith<$Res> {
  factory _$ProjectManagerCopyWith(_ProjectManager value, $Res Function(_ProjectManager) _then) = __$ProjectManagerCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "project_manager_id") String projectManagerId, String name, String? email
});




}
/// @nodoc
class __$ProjectManagerCopyWithImpl<$Res>
    implements _$ProjectManagerCopyWith<$Res> {
  __$ProjectManagerCopyWithImpl(this._self, this._then);

  final _ProjectManager _self;
  final $Res Function(_ProjectManager) _then;

/// Create a copy of ProjectManager
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? projectManagerId = null,Object? name = null,Object? email = freezed,}) {
  return _then(_ProjectManager(
projectManagerId: null == projectManagerId ? _self.projectManagerId : projectManagerId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
