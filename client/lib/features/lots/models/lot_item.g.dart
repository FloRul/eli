// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lot_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LotItem _$LotItemFromJson(Map<String, dynamic> json) => _LotItem(
  lotItemId: json['lot_item_id'] as String,
  parentLotId: json['parent_lot_id'] as String,
  status: json['status'] as String,
  title: json['title'] as String,
  providerId: json['provider_id'] as String?,
  majorComponents: json['major_components'] as String?,
);

Map<String, dynamic> _$LotItemToJson(_LotItem instance) => <String, dynamic>{
  'lot_item_id': instance.lotItemId,
  'parent_lot_id': instance.parentLotId,
  'status': instance.status,
  'title': instance.title,
  'provider_id': instance.providerId,
  'major_components': instance.majorComponents,
};
