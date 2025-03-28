import 'package:freezed_annotation/freezed_annotation.dart';
part 'project_manager.freezed.dart';
part 'project_manager.g.dart';

@freezed
abstract class ProjectManager with _$ProjectManager {
  const factory ProjectManager({
    @JsonKey(name: "project_manager_id") required String projectManagerId,
    required String name,
    String? email,
  }) = _ProjectManager;

  factory ProjectManager.fromJson(Map<String, Object?> json) => _$ProjectManagerFromJson(json);
}
