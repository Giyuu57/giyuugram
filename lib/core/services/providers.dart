import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return supabase;
});

/// Emits the current auth state (signed in / signed out) in realtime.
final authStateProvider = StreamProvider<AuthState>((ref) {
  return supabase.auth.onAuthStateChange;
});

/// Convenience provider: current logged-in user's id (nullable).
final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider).valueOrNull;
  return authState?.session?.user.id ?? supabase.auth.currentUser?.id;
});