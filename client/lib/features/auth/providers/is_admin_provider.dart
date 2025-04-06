import 'package:client/features/auth/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'is_admin_provider.g.dart';

@Riverpod(keepAlive: true)
bool isAdmin(Ref ref) {
  final user = ref.watch(authProvider);
  if (user == null) return false;
  return user.isAdmin;
}
