// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimelineEntry _$TimelineEntryFromJson(Map<String, dynamic> json) =>
    _TimelineEntry(
      label: json['label'] as String,
      date: json['date'] as String,
      isPassed: json['isPassed'] as bool? ?? false,
      isHighlighted: json['isHighlighted'] as bool? ?? false,
    );

Map<String, dynamic> _$TimelineEntryToJson(_TimelineEntry instance) =>
    <String, dynamic>{
      'label': instance.label,
      'date': instance.date,
      'isPassed': instance.isPassed,
      'isHighlighted': instance.isHighlighted,
    };
