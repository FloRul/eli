import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'lot_item.freezed.dart';
part 'lot_item.g.dart';

@freezed
abstract class LotItem with _$LotItem {
  @JsonSerializable(
    fieldRename: FieldRename.snake, // Match Supabase columns
    explicitToJson: true, // Needed if nested enums require toJson
  )
  const factory LotItem({
    required int id,
    required int parentLotId,
    String? title,
    String? quantity,
    DateTime? endManufacturingDate,
    DateTime? readyToShipDate,
    DateTime? plannedDeliveryDate,
    required int purchasingProgress,
    required int engineeringProgress,
    required int manufacturingProgress,
    String? originCountry,
    @JsonKey(fromJson: Incoterm.fromString) required Incoterm incoterms,
    String? comments,
    DateTime? requiredOnSiteDate,
    @JsonKey(fromJson: Status.fromString) required Status status,
  }) = _LotItem;

  factory LotItem.fromJson(Map<String, dynamic> json) => _$LotItemFromJson(json);
}
