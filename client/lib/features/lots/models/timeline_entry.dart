import 'package:freezed_annotation/freezed_annotation.dart';
part 'timeline_entry.freezed.dart';

@freezed
abstract class TimelineEntry with _$TimelineEntry {
  const factory TimelineEntry({
    required String label,
    required String key,
    required DateTime? date,
    @Default(false) bool isPassed,
    @Default(false) bool isHighlighted,
  }) = _TimelineEntry;
}
