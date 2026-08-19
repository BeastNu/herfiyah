import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ---------------------------------------------------------------------------
// Auth provider
// ---------------------------------------------------------------------------
// Provides the current Supabase Auth session state as a Riverpod stream.
// Widgets can watch this provider to reactively update the UI when the
// authentication state changes (login / logout / token refresh).
// ---------------------------------------------------------------------------

/// Expose the Supabase client so other providers can use it.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Stream of the current [AuthState] — emits the initial state immediately,
/// then every change (sign-in, sign-out, token refresh).
final authStateProvider = StreamProvider<AuthState>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.auth.onAuthStateChange;
});

/// Whether the user is currently authenticated (non-null [Session]).
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).valueOrNull?.session != null;
});

/// The current [User] object, or `null` when signed out.
final currentUserProvider = Provider<User?>((ref) {
  final session = ref.watch(authStateProvider).valueOrNull?.session;
  return session?.user;
});

/// The current [Session] object, or `null` when signed out.
final currentSessionProvider = Provider<Session?>((ref) {
  return ref.watch(authStateProvider).valueOrNull?.session;
});