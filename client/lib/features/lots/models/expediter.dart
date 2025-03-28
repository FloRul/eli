import 'package:freezed_annotation/freezed_annotation.dart';
part 'expediter.freezed.dart';
part 'expediter.g.dart';

@freezed
abstract class Expediter with _$Expediter {
  const factory Expediter({
    @JsonKey(name: "expediter_id") required String expediterId,
    required String name,
    String? email,
  }) = _Expediter;

  factory Expediter.fromJson(Map<String, Object?> json) => _$ExpediterFromJson(json);
}
