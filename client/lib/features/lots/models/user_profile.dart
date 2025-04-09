import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UserProfile({required String id, String? fullName, String? email}) = _UserProfile;

  factory UserProfile.fromJson(Map<String, Object?> json) => _$UserProfileFromJson(json);
}
