import 'package:freezed_annotation/freezed_annotation.dart';
part 'lot.freezed.dart';
part 'lot.g.dart';

@freezed
abstract class Lot with _$Lot {
  const factory Lot({
    @JsonKey(name: "lot_id") required String lotId,
    @JsonKey(name: "project_id") required String projectId,
    required String title,
    String? itp,
    @JsonKey(name: "final_acceptance_test") String? finalAcceptanceTest,
    @JsonKey(name: "start_date") DateTime? startDate,
    String? incoterms,
    @JsonKey(name: "required_on_site_date") DateTime? requiredOnSiteDate,
  }) = _Lot;

  factory Lot.fromJson(Map<String, Object?> json) => _$LotFromJson(json);
}
