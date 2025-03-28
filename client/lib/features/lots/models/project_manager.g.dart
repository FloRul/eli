// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_manager.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectManager _$ProjectManagerFromJson(Map<String, dynamic> json) =>
    _ProjectManager(
      projectManagerId: json['project_manager_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$ProjectManagerToJson(_ProjectManager instance) =>
    <String, dynamic>{
      'project_manager_id': instance.projectManagerId,
      'name': instance.name,
      'email': instance.email,
    };
