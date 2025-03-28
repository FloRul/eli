import 'package:freezed_annotation/freezed_annotation.dart';
part 'provider.freezed.dart';
part 'provider.g.dart';

@freezed
abstract class Provider with _$Provider {
  const factory Provider({
    @JsonKey(name: "provider_id") required String providerId,
    required String name,
    String? email,
    String? phone,
    String? adress,
  }) = _Provider;

  factory Provider.fromJson(Map<String, Object?> json) => _$ProviderFromJson(json);
}
