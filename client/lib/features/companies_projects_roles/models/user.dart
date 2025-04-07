// companies_projects_roles/models/user.dart
// ignore_for_file: avoid_dynamic_calls

import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';
part 'user.g.dart';

// Keep the Role enum as is
enum Role { admin, member, viewer }

@freezed
abstract class TenantUser with _$TenantUser {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TenantUser({
    required String userId, // Dart: camelCase
    required Role role,
    String? email,
    required String firstName,
    required String lastName,
  }) = _TenantUser;

  // Custom factory handles mapping explicitly here
  factory TenantUser.fromJson(Map<String, dynamic> json) => _$TenantUserFromJson(json);
}
