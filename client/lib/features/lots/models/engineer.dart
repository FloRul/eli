import 'package:freezed_annotation/freezed_annotation.dart';
part 'engineer.freezed.dart';
part 'engineer.g.dart';

@freezed
abstract class Engineer with _$Engineer {
  const factory Engineer({
    required String name,
    @JsonKey(name: "engineer_id") required String engineerId,
    String? email,
  }) = _Engineer;

  factory Engineer.fromJson(Map<String, Object?> json) => _$EngineerFromJson(json);
}
