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
  factory TenantUser.fromJson(Map<String, dynamic> json) {
    return TenantUser(
      userId: json['user_id'] as String, // JSON: snake_case (manual mapping)
      role: Role.values.firstWhere(
        (role) => role.name == json['role'] as String?, // JSON: 'role' (manual mapping)
        orElse: () => Role.viewer,
      ), // JSON: 'role' (standard)
      firstName: json['first_name'] as String, // Nested structure
      lastName: json['last_name'] as String, // Nested structure
      email: json['email'] as String?, // Nested structure
      // ...
    );
  }
}
