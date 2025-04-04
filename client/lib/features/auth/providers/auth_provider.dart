import 'dart:async';

// Make sure this path is correct for your project structure
import 'package:client/core/providers/supabase_provider.dart';
import 'package:client/features/auth/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  // Subscription to Supabase auth state changes
  StreamSubscription<AuthState>? _authStateSubscription;

  @override
  UserModel? build() {
    _initListener();

    // 3. Clean up the listener when the provider is disposed
    ref.onDispose(() {
      print("Disposing Auth provider and cancelling subscription.");
      _authStateSubscription?.cancel();
    });

    final currentSession = supabase.auth.currentSession;
    print("Auth build: Initial session is ${currentSession == null ? 'null' : 'present'}");
    if (currentSession != null) {
      return UserModel.fromSession(currentSession);
    } else {
      return null;
    }
  }

  void _initListener() {
    // Avoid creating multiple listeners if build is called again
    if (_authStateSubscription != null) return;

    print("Initializing AuthState listener");
    _authStateSubscription = supabase.auth.onAuthStateChange.listen(
      (AuthState data) {
        // This callback runs whenever the auth state changes (login, logout, token refresh, initial load)
        final session = data.session;
        final event = data.event;
        print("AuthState changed: Session is ${session == null ? 'null' : 'present'} (Event: $event)");

        // Update the Riverpod state which will notify listeners (UI)
        state = session == null ? null : UserModel.fromSession(session);

        // Handle specific events if needed
        switch (event) {
          case AuthChangeEvent.signedIn:
            print("User signed in.");
            // You could potentially trigger fetching user profile data here
            break;
          case AuthChangeEvent.signedOut:
            print("User signed out.");
            break;
          case AuthChangeEvent.userUpdated:
            print("User data updated.");
            // Update user model if necessary, though fromSession should handle it
            break;
          case AuthChangeEvent.passwordRecovery:
            print("Password recovery event.");
            break;
          case AuthChangeEvent.tokenRefreshed:
            print("Auth token refreshed.");
            // Usually no action needed here as the session object is updated
            break;
          case AuthChangeEvent.initialSession:
            print("Initial session loaded by listener.");
            // This confirms the listener picked up the persisted session
            break;
          case AuthChangeEvent.mfaChallengeVerified:
            print("MFA challenge verified.");
            break;
          case _:
            break;
        }
      },
      onError: (error) {
        // Handle potential errors in the stream
        print("Error in AuthState stream: $error");
        // Consider setting state to null or logging the error appropriately
        state = null;
      },
      onDone: () {
        print("AuthState stream closed.");
      },
      // Set cancelOnError to false if you want the stream to continue after an error
      // cancelOnError: false,
    );
  }

  // --- Authentication Methods ---

  Future<String?> login({required String email, required String password}) async {
    try {
      await supabase.auth.signInWithPassword(password: password, email: email);
      // No need to manually set `state` here.
      // The `onAuthStateChange` listener will receive the SIGNED_IN event
      // and update the state automatically.
      print("Login successful for $email");
      return null; // Indicates success
    } on AuthException catch (er) {
      print("Login AuthException: ${er.statusCode} ${er.message}");
      return er.message; // Return error message
    } catch (err) {
      print("Login generic error: ${err.toString()}");
      return "An unexpected error occurred during login."; // Generic error message
    }
  }

  Future<void> logout() async {
    try {
      print("Attempting logout...");
      await supabase.auth.signOut();
      print("Logout successful.");
    } catch (err) {
      print("Error during logout: ${err.toString()}");
    }
  }

  // Modified signUp to return an error message for better UI feedback
  Future<String?> signUp({required String email, required String password, String? fullName}) async {
    try {
      final AuthResponse response = await supabase.auth.signUp(email: email, password: password);

      // Check if email confirmation is required (user exists but no session)
      if (response.user != null && response.session == null) {
        print("Signup successful for $email. Email confirmation likely required.");
        // You might want to return a specific message for this case
        return "Signup successful. Please check your email to confirm your account.";
      } else if (response.user != null && response.session != null) {
        print("Signup successful for $email and user is logged in.");
        // Listener will handle state update
        return null; // Indicates immediate success and login
      } else {
        print("Signup response indicates potential issue (User: ${response.user}, Session: ${response.session})");
        return "An unexpected issue occurred during sign up.";
      }
    } on AuthException catch (er) {
      print("SignUp AuthException: ${er.statusCode} ${er.message}");
      return er.message; // Return specific auth error
    } catch (err) {
      print("SignUp generic error: ${err.toString()}");
      return "An unknown error occurred during sign up."; // Generic error message
    }
  }
}
