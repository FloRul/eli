// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserCompanyAccess _$UserCompanyAccessFromJson(Map<String, dynamic> json) =>
    _UserCompanyAccess(
      userId: json['user_id'] as String,
      companyId: (json['company_id'] as num).toInt(),
    );

Map<String, dynamic> _$UserCompanyAccessToJson(_UserCompanyAccess instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'company_id': instance.companyId,
    };

_UserProjectAccess _$UserProjectAccessFromJson(Map<String, dynamic> json) =>
    _UserProjectAccess(
      userId: json['user_id'] as String,
      projectId: (json['project_id'] as num).toInt(),
    );

Map<String, dynamic> _$UserProjectAccessToJson(_UserProjectAccess instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'project_id': instance.projectId,
    };
