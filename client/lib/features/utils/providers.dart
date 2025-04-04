import 'package:client/features/auth/models/user_model.dart';
import 'package:client/features/auth/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'providers.g.dart';

@Riverpod(keepAlive: true)
bool isAdmin(Ref ref) {
  return ref.watch(authProvider)?.role == UserRole.admin;
}
