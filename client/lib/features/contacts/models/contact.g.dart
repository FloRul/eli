// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Contact _$ContactFromJson(Map<String, dynamic> json) => _Contact(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  cellphoneNumber: json['cellphone_number'] as String?,
  officePhoneNumber: json['office_phone_number'] as String?,
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  companyId: (json['company_id'] as num).toInt(),
  company:
      json['companies'] == null
          ? null
          : Company.fromJson(json['companies'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ContactToJson(_Contact instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'cellphone_number': instance.cellphoneNumber,
  'office_phone_number': instance.officePhoneNumber,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'company_id': instance.companyId,
  'companies': instance.company?.toJson(),
};
