import 'package:client/features/companies_projects_roles/models/project.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'company.freezed.dart';
part 'company.g.dart';

@freezed
abstract class Company with _$Company {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Company({required int id, required String name, @Default([]) List<Project> items}) = _Company;

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);
}
