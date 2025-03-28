// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Lot _$LotFromJson(Map<String, dynamic> json) => _Lot(
  lotId: json['lot_id'] as String,
  projectId: json['project_id'] as String,
  title: json['title'] as String,
  itp: json['itp'] as String?,
  finalAcceptanceTest: json['final_acceptance_test'] as String?,
  startDate:
      json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
  incoterms: json['incoterms'] as String?,
  requiredOnSiteDate:
      json['required_on_site_date'] == null
          ? null
          : DateTime.parse(json['required_on_site_date'] as String),
);

Map<String, dynamic> _$LotToJson(_Lot instance) => <String, dynamic>{
  'lot_id': instance.lotId,
  'project_id': instance.projectId,
  'title': instance.title,
  'itp': instance.itp,
  'final_acceptance_test': instance.finalAcceptanceTest,
  'start_date': instance.startDate?.toIso8601String(),
  'incoterms': instance.incoterms,
  'required_on_site_date': instance.requiredOnSiteDate?.toIso8601String(),
};
