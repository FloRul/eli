// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expediter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Expediter _$ExpediterFromJson(Map<String, dynamic> json) => _Expediter(
  expediterId: json['expediter_id'] as String,
  name: json['name'] as String,
  email: json['email'] as String?,
);

Map<String, dynamic> _$ExpediterToJson(_Expediter instance) =>
    <String, dynamic>{
      'expediter_id': instance.expediterId,
      'name': instance.name,
      'email': instance.email,
    };
