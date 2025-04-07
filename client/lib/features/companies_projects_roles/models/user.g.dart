// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TenantUser _$TenantUserFromJson(Map<String, dynamic> json) => _TenantUser(
  userId: json['user_id'] as String,
  role: $enumDecode(_$RoleEnumMap, json['role']),
  email: nestedReader(json, 'user_profiles/email') as String,
  fullName: nestedReader(json, 'user_profiles/full_name') as String?,
);

Map<String, dynamic> _$TenantUserToJson(_TenantUser instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'role': _$RoleEnumMap[instance.role]!,
      'user_profiles/email': instance.email,
      'user_profiles/full_name': instance.fullName,
    };

const _$RoleEnumMap = {
  Role.admin: 'admin',
  Role.member: 'member',
  Role.viewer: 'viewer',
};
