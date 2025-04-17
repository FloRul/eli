import 'package:client/features/lots/models/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'lot_filter.freezed.dart';
part 'lot_filter.g.dart';

@freezed
abstract class LotFilter with _$LotFilter {
  const factory LotFilter({required Status? status, required String? search}) = _LotFilter;

  factory LotFilter.empty() => const LotFilter(status: null, search: null);

  factory LotFilter.fromJson(Map<String, Object?> json) => _$LotFilterFromJson(json);
}
