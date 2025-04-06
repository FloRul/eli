// ignore_for_file: avoid_dynamic_calls

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserRole { admin, member, viewer }

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    String? fullName,
    String? avatarUrl,
    required String tenantName,
    required String tenantId,
    required UserRole role,
  }) = _UserModel;

  const UserModel._();
  factory UserModel.fromSession(Session session) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(session.accessToken);
    return UserModel(
      id: session.user.id,
      email: session.user.email!,
      fullName: session.user.userMetadata!['full_name'] as String?,
      avatarUrl: session.user.userMetadata!['avatar_url'] as String?,
      tenantName: decodedToken['user_metadata']!['tenant_name'] as String,
      tenantId: decodedToken['tenant_id'] as String,
      role: UserRole.values.firstWhere(
        (role) => role.name == decodedToken['user_metadata']!['role'],
        orElse: () => UserRole.viewer,
      ),
    );
  }
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  bool get isAdmin => role == UserRole.admin;
}
