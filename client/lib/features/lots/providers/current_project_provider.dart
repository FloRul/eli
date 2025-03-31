import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_project_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentProjectNotifier extends _$CurrentProjectNotifier {
  @override
  int? build() => 1;
}
