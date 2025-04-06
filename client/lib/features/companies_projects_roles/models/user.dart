// companies_projects_roles/models/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';
part 'user.g.dart';

// Keep the Role enum as is
enum Role { admin, member, viewer }

extension RoleExtension on Role {
  static Role fromValue(String value) {
    switch (value) {
      case 'admin':
        return Role.admin;
      case 'member':
        return Role.member;
      case 'viewer':
        return Role.viewer;
      default:
        throw ArgumentError('Unknown role value: $value');
    }
  }
}

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
      role: RoleExtension.fromValue(json['role'] as String), // JSON: 'role' (standard)
      firstName: json['users']?['first_name'] as String, // Nested structure
      lastName: json['users']?['last_name'] as String, // Nested structure
      // ignore: avoid_dynamic_calls
      email: json['users']?['email'] as String?, // Nested structure
      // ...
    );
  }
}
