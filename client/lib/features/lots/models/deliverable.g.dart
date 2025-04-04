// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deliverable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Deliverable _$DeliverableFromJson(Map<String, dynamic> json) => _Deliverable(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  dueDate: DateTime.parse(json['due_date'] as String),
  isReceived: json['is_received'] as bool,
);

Map<String, dynamic> _$DeliverableToJson(_Deliverable instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'due_date': instance.dueDate.toIso8601String(),
      'is_received': instance.isReceived,
    };
