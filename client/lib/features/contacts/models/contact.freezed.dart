// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Contact {

 int get id; String get email; String? get cellphoneNumber; String? get officePhoneNumber; String? get firstName; String? get lastName; int get companyId;// Store company ID
// Include the nested company data directly if fetched that way
// Adjust name if your Supabase query uses a different alias/structure
@JsonKey(name: 'companies') Company? get company;
/// Create a copy of Contact
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactCopyWith<Contact> get copyWith => _$ContactCopyWithImpl<Contact>(this as Contact, _$identity);

  /// Serializes this Contact to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Contact&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.cellphoneNumber, cellphoneNumber) || other.cellphoneNumber == cellphoneNumber)&&(identical(other.officePhoneNumber, officePhoneNumber) || other.officePhoneNumber == officePhoneNumber)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.companyId, companyId) || other.companyId == companyId)&&(identical(other.company, company) || other.company == company));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,cellphoneNumber,officePhoneNumber,firstName,lastName,companyId,company);

@override
String toString() {
  return 'Contact(id: $id, email: $email, cellphoneNumber: $cellphoneNumber, officePhoneNumber: $officePhoneNumber, firstName: $firstName, lastName: $lastName, companyId: $companyId, company: $company)';
}


}

/// @nodoc
abstract mixin class $ContactCopyWith<$Res>  {
  factory $ContactCopyWith(Contact value, $Res Function(Contact) _then) = _$ContactCopyWithImpl;
@useResult
$Res call({
 int id, String email, String? cellphoneNumber, String? officePhoneNumber, String? firstName, String? lastName, int companyId,@JsonKey(name: 'companies') Company? company
});


$CompanyCopyWith<$Res>? get company;

}
/// @nodoc
class _$ContactCopyWithImpl<$Res>
    implements $ContactCopyWith<$Res> {
  _$ContactCopyWithImpl(this._self, this._then);

  final Contact _self;
  final $Res Function(Contact) _then;

/// Create a copy of Contact
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? cellphoneNumber = freezed,Object? officePhoneNumber = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? companyId = null,Object? company = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,cellphoneNumber: freezed == cellphoneNumber ? _self.cellphoneNumber : cellphoneNumber // ignore: cast_nullable_to_non_nullable
as String?,officePhoneNumber: freezed == officePhoneNumber ? _self.officePhoneNumber : officePhoneNumber // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,companyId: null == companyId ? _self.companyId : companyId // ignore: cast_nullable_to_non_nullable
as int,company: freezed == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as Company?,
  ));
}
/// Create a copy of Contact
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompanyCopyWith<$Res>? get company {
    if (_self.company == null) {
    return null;
  }

  return $CompanyCopyWith<$Res>(_self.company!, (value) {
    return _then(_self.copyWith(company: value));
  });
}
}


/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Contact extends Contact {
  const _Contact({required this.id, required this.email, this.cellphoneNumber, this.officePhoneNumber, this.firstName, this.lastName, required this.companyId, @JsonKey(name: 'companies') this.company}): super._();
  factory _Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);

@override final  int id;
@override final  String email;
@override final  String? cellphoneNumber;
@override final  String? officePhoneNumber;
@override final  String? firstName;
@override final  String? lastName;
@override final  int companyId;
// Store company ID
// Include the nested company data directly if fetched that way
// Adjust name if your Supabase query uses a different alias/structure
@override@JsonKey(name: 'companies') final  Company? company;

/// Create a copy of Contact
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactCopyWith<_Contact> get copyWith => __$ContactCopyWithImpl<_Contact>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContactToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Contact&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.cellphoneNumber, cellphoneNumber) || other.cellphoneNumber == cellphoneNumber)&&(identical(other.officePhoneNumber, officePhoneNumber) || other.officePhoneNumber == officePhoneNumber)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.companyId, companyId) || other.companyId == companyId)&&(identical(other.company, company) || other.company == company));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,cellphoneNumber,officePhoneNumber,firstName,lastName,companyId,company);

@override
String toString() {
  return 'Contact(id: $id, email: $email, cellphoneNumber: $cellphoneNumber, officePhoneNumber: $officePhoneNumber, firstName: $firstName, lastName: $lastName, companyId: $companyId, company: $company)';
}


}

/// @nodoc
abstract mixin class _$ContactCopyWith<$Res> implements $ContactCopyWith<$Res> {
  factory _$ContactCopyWith(_Contact value, $Res Function(_Contact) _then) = __$ContactCopyWithImpl;
@override @useResult
$Res call({
 int id, String email, String? cellphoneNumber, String? officePhoneNumber, String? firstName, String? lastName, int companyId,@JsonKey(name: 'companies') Company? company
});


@override $CompanyCopyWith<$Res>? get company;

}
/// @nodoc
class __$ContactCopyWithImpl<$Res>
    implements _$ContactCopyWith<$Res> {
  __$ContactCopyWithImpl(this._self, this._then);

  final _Contact _self;
  final $Res Function(_Contact) _then;

/// Create a copy of Contact
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? cellphoneNumber = freezed,Object? officePhoneNumber = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? companyId = null,Object? company = freezed,}) {
  return _then(_Contact(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,cellphoneNumber: freezed == cellphoneNumber ? _self.cellphoneNumber : cellphoneNumber // ignore: cast_nullable_to_non_nullable
as String?,officePhoneNumber: freezed == officePhoneNumber ? _self.officePhoneNumber : officePhoneNumber // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,companyId: null == companyId ? _self.companyId : companyId // ignore: cast_nullable_to_non_nullable
as int,company: freezed == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as Company?,
  ));
}

/// Create a copy of Contact
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompanyCopyWith<$Res>? get company {
    if (_self.company == null) {
    return null;
  }

  return $CompanyCopyWith<$Res>(_self.company!, (value) {
    return _then(_self.copyWith(company: value));
  });
}
}

// dart format on
