// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Provider _$ProviderFromJson(Map<String, dynamic> json) => _Provider(
  providerId: json['provider_id'] as String,
  name: json['name'] as String,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  adress: json['adress'] as String?,
);

Map<String, dynamic> _$ProviderToJson(_Provider instance) => <String, dynamic>{
  'provider_id': instance.providerId,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'adress': instance.adress,
};
