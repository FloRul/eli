// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lot_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LotFilter _$LotFilterFromJson(Map<String, dynamic> json) => _LotFilter(
  status: $enumDecodeNullable(_$StatusEnumMap, json['status']),
  search: json['search'] as String?,
);

Map<String, dynamic> _$LotFilterToJson(_LotFilter instance) =>
    <String, dynamic>{
      'status': instance.status?.toJson(),
      'search': instance.search,
    };

const _$StatusEnumMap = {
  Status.completed: 'completed',
  Status.onhold: 'onhold',
  Status.ongoing: 'ongoing',
  Status.closefollowuprequired: 'closefollowuprequired',
  Status.critical: 'critical',
};
