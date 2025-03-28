import 'dart:async';

import 'package:client/core/providers/supabase_provider.dart';
import 'package:client/features/auth/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  late final StreamSubscription<AuthState> _authStateSubscription;

  @override
  UserModel? build() {
    _initListener();
    ref.onDispose(_authStateSubscription.cancel);
    return supabase.auth.currentSession == null ? null : UserModel.fromSession(supabase.auth.currentSession!);
  }

  void _initListener() {
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (data.session == null) {
        state = null;
        return;
      }
      state = UserModel.fromSession(data.session!);
    });
  }

  Future<String?> login({required String email, required String password}) async {
    try {
      await supabase.auth.signInWithPassword(password: password, email: email);
      return null;
    } on AuthException catch (er) {
      print(er.message);
      return er.message;
    } catch (err) {
      return err.toString();
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  Future<void> signUp({required String email, required String password, String? fullName}) async {
    try {
      await supabase.auth.signUp(email: email, password: password);
    } on AuthException catch (er) {
      rethrow;
    } catch (err) {
      rethrow;
    }
  }
}
