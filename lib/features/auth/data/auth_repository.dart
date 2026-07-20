import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}

class AuthRepository {
  final SupabaseClient _client;
  AuthRepository(this._client);

  User? get currentUser => _client.auth.currentUser;

  // ---------------- EMAIL ----------------

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String username,
    required String fullName,
  }) async {
    final existing = await _client
        .from('profiles')
        .select('id')
        .eq('username', username)
        .maybeSingle();
    if (existing != null) {
      throw AuthException('Username is already taken');
    }

    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'username': username,
        'full_name': fullName,
      },
    );

    if (response.user == null) {
      throw AuthException('Sign up failed. Please try again.');
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
    } on AuthApiException catch (e) {
      throw AuthException(e.message);
    }
  }

  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  // ---------------- GOOGLE (Web + Android only) ----------------

  Future<void> signInWithGoogle() async {
    // TODO: Replace with your real Web Client ID from Google Cloud Console.
    // Must match: web/index.html meta tag AND Supabase Dashboard -> Auth ->
    // Providers -> Google -> Client ID.
    const webClientId = 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = kIsWeb
        ? GoogleSignIn(
            // On web, the client ID is read from the
            // <meta name="google-signin-client_id"> tag in web/index.html.
            clientId: webClientId,
          )
        : GoogleSignIn(
            // On Android, serverClientId scopes the ID token to the Web
            // client so Supabase can verify it server-side. The Android
            // client itself is auto-detected via package name + SHA-1
            // registered in Google Cloud Console.
            serverClientId: webClientId,
          );

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw AuthException('Google sign-in cancelled');
    }

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    final accessToken = googleAuth.accessToken;

    if (idToken == null) {
      throw AuthException('No ID token found from Google sign-in');
    }

    await _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  // ---------------- SIGN OUT ----------------

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
