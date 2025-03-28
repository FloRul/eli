import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({required String id, required String email, String? fullName, String? avatarUrl}) =
      _UserModel;

  factory UserModel.fromSession(Session session) {
    return UserModel(
      id: session.user.id,
      email: session.user.email!,
      fullName: session.user.userMetadata!['full_name'] as String?,
      avatarUrl: session.user.userMetadata!['avatar_url'] as String?,
    );
  }
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
