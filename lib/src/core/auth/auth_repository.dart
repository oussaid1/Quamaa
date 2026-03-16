import 'package:supabase_flutter/supabase_flutter.dart';

import '../supabase/supabase_initializer.dart';

class AuthRepository {
  SupabaseClient get _client => SupabaseInitializer.client;

  Stream<AuthState> authStateChanges() => _client.auth.onAuthStateChange;

  Session? currentSession() => _client.auth.currentSession;

  Future<void> signInWithMagicLink(String email) async {
    await _client.auth.signInWithOtp(email: email, emailRedirectTo: null);
  }

  Future<void> signOut() => _client.auth.signOut();
}
