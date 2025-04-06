// companies_projects_roles/models/project.dart
// No changes needed from your provided file
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project.freezed.dart';
part 'project.g.dart';

@freezed
abstract class Project with _$Project {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Project({required int id, required String name, required int companyId /* Added companyId */}) =
      _Project;

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);
}
