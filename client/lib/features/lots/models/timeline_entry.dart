import 'package:freezed_annotation/freezed_annotation.dart';
part 'timeline_entry.freezed.dart';
part 'timeline_entry.g.dart';

@freezed
abstract class TimelineEntry with _$TimelineEntry {
  const factory TimelineEntry({
    required String label,
    required String date,
    @Default(false) bool isPassed,
    @Default(false) bool isHighlighted,
  }) = _TimelineEntry;

  factory TimelineEntry.fromJson(Map<String, Object?> json) => _$TimelineEntryFromJson(json);
}
