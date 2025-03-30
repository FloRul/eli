// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lot_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LotItem _$LotItemFromJson(Map<String, dynamic> json) => _LotItem(
  id: (json['id'] as num).toInt(),
  parentLotId: (json['parent_lot_id'] as num).toInt(),
  title: json['title'] as String?,
  quantity: json['quantity'] as String?,
  endManufacturingDate:
      json['end_manufacturing_date'] == null
          ? null
          : DateTime.parse(json['end_manufacturing_date'] as String),
  readyToShipDate:
      json['ready_to_ship_date'] == null
          ? null
          : DateTime.parse(json['ready_to_ship_date'] as String),
  plannedDeliveryDate:
      json['planned_delivery_date'] == null
          ? null
          : DateTime.parse(json['planned_delivery_date'] as String),
  purchasingProgress: (json['purchasing_progress'] as num).toInt(),
  engineeringProgress: (json['engineering_progress'] as num).toInt(),
  manufacturingProgress: (json['manufacturing_progress'] as num).toInt(),
  originCountry: json['origin_country'] as String?,
  incoterms: Incoterm.fromString(json['incoterms'] as String?),
  comments: json['comments'] as String?,
  requiredOnSiteDate:
      json['required_on_site_date'] == null
          ? null
          : DateTime.parse(json['required_on_site_date'] as String),
  status: Status.fromString(json['status'] as String?),
);

Map<String, dynamic> _$LotItemToJson(_LotItem instance) => <String, dynamic>{
  'id': instance.id,
  'parent_lot_id': instance.parentLotId,
  'title': instance.title,
  'quantity': instance.quantity,
  'end_manufacturing_date': instance.endManufacturingDate?.toIso8601String(),
  'ready_to_ship_date': instance.readyToShipDate?.toIso8601String(),
  'planned_delivery_date': instance.plannedDeliveryDate?.toIso8601String(),
  'purchasing_progress': instance.purchasingProgress,
  'engineering_progress': instance.engineeringProgress,
  'manufacturing_progress': instance.manufacturingProgress,
  'origin_country': instance.originCountry,
  'incoterms': instance.incoterms.toJson(),
  'comments': instance.comments,
  'required_on_site_date': instance.requiredOnSiteDate?.toIso8601String(),
  'status': instance.status.toJson(),
};
