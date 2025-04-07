// companies_projects_roles/models/user.dart
// ignore_for_file: avoid_dynamic_calls

import 'package:client/features/utils/json_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';
part 'user.g.dart';

// Keep the Role enum as is
enum Role { admin, member, viewer }

@freezed
abstract class TenantUser with _$TenantUser {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TenantUser({
    required String userId,
    required Role role,
    @NestedJsonKey(name: 'user_profiles/email') required String email,
    @NestedJsonKey(name: 'user_profiles/full_name') String? fullName,
  }) = _TenantUser;

  // Custom factory handles mapping explicitly here
  factory TenantUser.fromJson(Map<String, dynamic> json) => _$TenantUserFromJson(json);
}
