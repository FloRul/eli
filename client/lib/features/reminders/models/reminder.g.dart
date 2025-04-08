// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Reminder _$ReminderFromJson(Map<String, dynamic> json) => _Reminder(
  id: (json['id'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  note: json['note'] as String?,
  dueDate:
      json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
  isCompleted: json['is_completed'] as bool,
  userId: json['user_id'] as String,
  projectId: (json['project_id'] as num?)?.toInt(),
  lotId: (json['lot_id'] as num?)?.toInt(),
  tenantId: json['tenant_id'] as String,
);

Map<String, dynamic> _$ReminderToJson(_Reminder instance) => <String, dynamic>{
  'id': instance.id,
  'created_at': instance.createdAt.toIso8601String(),
  'note': instance.note,
  'due_date': instance.dueDate?.toIso8601String(),
  'is_completed': instance.isCompleted,
  'user_id': instance.userId,
  'project_id': instance.projectId,
  'lot_id': instance.lotId,
  'tenant_id': instance.tenantId,
};
