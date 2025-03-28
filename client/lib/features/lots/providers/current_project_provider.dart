import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_project_provider.g.dart';

@riverpod
Future<String> currentProject(Ref ref) {
  return Future.delayed(Duration(seconds: 1), () {
    return 'current_project';
  });
}
