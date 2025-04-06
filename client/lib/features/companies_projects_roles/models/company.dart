import 'package:freezed_annotation/freezed_annotation.dart';
import 'project.dart'; 

part 'company.freezed.dart';
part 'company.g.dart';

@freezed
abstract class Company with _$Company {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Company({
    required int id,
    required String name,
    required String tenantId,
    @Default([]) List<Project> projects,
  }) = _Company;

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);
}
