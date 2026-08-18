import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';

/// Supabase configuration — replace with your project's values.
///
/// You can find these in the Supabase dashboard under
///   Settings → API → Project URL  /  anon public key.
const String _supabaseUrl = 'https://your-project-id.supabase.co';
const String _supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.placeholder';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // -----------------------------------------------------------------------
  // Supabase initialisation
  // -----------------------------------------------------------------------
  await Supabase.initialize(
    url: _supabaseUrl,
    anonKey: _supabaseAnonKey,
  );

  runApp(
    // Riverpod's ProviderScope must wrap the entire app so that all
    // providers (auth, services, bookings, …) are accessible everywhere.
    const ProviderScope(
      child: HerfiyahApp(),
    ),
  );
}