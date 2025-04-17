// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Lot _$LotFromJson(Map<String, dynamic> json) => _Lot(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  number: json['number'] as String,
  provider: json['provider'] as String,
  assignedToFullName: _readExpediter(json, 'full_name') as String?,
  assignedToEmail: _readExpediter(json, 'email') as String?,
  assignedExpediterId: json['assigned_expediter_id'] as String?,
  lotItems:
      (json['lot_items'] as List<dynamic>?)
          ?.map((e) => LotItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  deliverables:
      (json['deliverables'] as List<dynamic>?)
          ?.map((e) => Deliverable.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$LotToJson(_Lot instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'number': instance.number,
  'provider': instance.provider,
  'assigned_expediter_id': instance.assignedExpediterId,
};
