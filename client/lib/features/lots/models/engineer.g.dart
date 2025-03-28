// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'engineer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Engineer _$EngineerFromJson(Map<String, dynamic> json) => _Engineer(
  name: json['name'] as String,
  engineerId: json['engineer_id'] as String,
  email: json['email'] as String?,
);

Map<String, dynamic> _$EngineerToJson(_Engineer instance) => <String, dynamic>{
  'name': instance.name,
  'engineer_id': instance.engineerId,
  'email': instance.email,
};
