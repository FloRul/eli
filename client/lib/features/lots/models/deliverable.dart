import 'package:freezed_annotation/freezed_annotation.dart';
part 'deliverable.freezed.dart';
part 'deliverable.g.dart';

@freezed
abstract class Deliverable with _$Deliverable {
  @JsonSerializable(
    fieldRename: FieldRename.snake, // Match Supabase columns
    explicitToJson: true,
  )
  const factory Deliverable({
    required int id,
    required String title,
    required DateTime dueDate,
    required bool isReceived,
  }) = _Deliverable;

  factory Deliverable.fromJson(Map<String, Object?> json) => _$DeliverableFromJson(json);
}
