import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:client/features/auth/models/user_model.dart';
import 'package:client/core/providers/supabase_provider.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  Future<UserModel?> build() async {
    // Set up auth state change listener
    _setupAuthStateListener();

    // Get current user
    return _getCurrentUser();
  }

  void _setupAuthStateListener() {
    supabase.auth.onAuthStateChange.listen((data) {
      switch (data.event) {
        case AuthChangeEvent.signedIn || AuthChangeEvent.signedOut || AuthChangeEvent.userUpdated:
          ref.invalidateSelf();
          break;
        default:
      }
    });
  }

  Future<UserModel?> _getCurrentUser() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      return null;
    }

    return UserModel(
      id: user.id,
      email: user.email ?? '',
      fullName: user.userMetadata?['full_name'] as String?,
      avatarUrl: user.userMetadata?['avatar_url'] as String?,
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncValue.loading();

    try {
      await supabase.auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> signUp({required String email, required String password, String? fullName}) async {
    state = const AsyncValue.loading();

    try {
      await supabase.auth.signUp(email: email, password: password, data: {if (fullName != null) 'full_name': fullName});
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}
