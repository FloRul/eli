import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_project_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentProjectProvider extends _$CurrentProjectProvider {
  @override
  int? build() => 1;

  // This is a placeholder for the actual implementation
  // In a real application, you would fetch the project ID from a data source
  // or pass it as an argument to the constructor.
  // For now, we just return a default value.
}
