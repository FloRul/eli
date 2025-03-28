import 'package:freezed_annotation/freezed_annotation.dart';
part 'lot_item.freezed.dart';
part 'lot_item.g.dart';

@freezed
abstract class LotItem with _$LotItem {
  const factory LotItem({
    @JsonKey(name: "lot_item_id") required String lotItemId,
    @JsonKey(name: "parent_lot_id") required String parentLotId,
    required String status,
    required String title,
    @JsonKey(name: "provider_id") required String? providerId,
    @JsonKey(name: "major_components") required String? majorComponents,
  }) = _LotItem;

  factory LotItem.fromJson(Map<String, Object?> json) => _$LotItemFromJson(json);
}
