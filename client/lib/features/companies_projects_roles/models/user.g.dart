// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TenantUser _$TenantUserFromJson(Map<String, dynamic> json) => _TenantUser(
  userId: json['user_id'] as String,
  role: $enumDecode(_$RoleEnumMap, json['role']),
  email: json['email'] as String?,
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
);

Map<String, dynamic> _$TenantUserToJson(_TenantUser instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'role': _$RoleEnumMap[instance.role]!,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
    };

const _$RoleEnumMap = {
  Role.admin: 'admin',
  Role.member: 'member',
  Role.viewer: 'viewer',
};
