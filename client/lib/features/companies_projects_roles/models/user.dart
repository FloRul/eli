import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';
part 'user.g.dart';

enum Role { admin, member, viewer }

@freezed
abstract class UserWithRole with _$UserWithRole {
  const factory UserWithRole({required String firstName, required String lastName, required Role role}) = _UserWithRole;

  factory UserWithRole.fromJson(Map<String, Object?> json) => _$UserWithRoleFromJson(json);
}
