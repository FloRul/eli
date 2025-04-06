// companies_projects_roles/models/access.dart (New File)
import 'package:freezed_annotation/freezed_annotation.dart';

part 'access.freezed.dart';
part 'access.g.dart';

@freezed
abstract class UserCompanyAccess with _$UserCompanyAccess {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UserCompanyAccess({required String userId, required int companyId}) = _UserCompanyAccess;

  factory UserCompanyAccess.fromJson(Map<String, dynamic> json) => _$UserCompanyAccessFromJson(json);
}

@freezed
abstract class UserProjectAccess with _$UserProjectAccess {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UserProjectAccess({required String userId, required int projectId}) = _UserProjectAccess;

  factory UserProjectAccess.fromJson(Map<String, dynamic> json) => _$UserProjectAccessFromJson(json);
}
