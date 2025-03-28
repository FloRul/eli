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
    final supabase = ref.read(supabaseProvider);

    supabase.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        ref.invalidateSelf();
      } else if (data.event == AuthChangeEvent.signedOut) {
        ref.invalidateSelf();
      } else if (data.event == AuthChangeEvent.userUpdated) {
        ref.invalidateSelf();
      }
    });
  }

  Future<UserModel?> _getCurrentUser() async {
    final supabase = ref.read(supabaseProvider);
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
    final supabase = ref.read(supabaseProvider);

    state = const AsyncValue.loading();

    try {
      await supabase.auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> signUp({required String email, required String password, String? fullName}) async {
    final supabase = ref.read(supabaseProvider);

    state = const AsyncValue.loading();

    try {
      await supabase.auth.signUp(email: email, password: password, data: {if (fullName != null) 'full_name': fullName});
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> signOut() async {
    final supabase = ref.read(supabaseProvider);

    try {
      await supabase.auth.signOut();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}
