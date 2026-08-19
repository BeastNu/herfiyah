import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'shared/config/env_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // -----------------------------------------------------------------------
  // Supabase initialisation
  // -----------------------------------------------------------------------
  await Supabase.initialize(
    url: EnvConfig.supabaseUrl,
    anonKey: EnvConfig.supabaseAnonKey,
  );

  runApp(
    // Riverpod's ProviderScope must wrap the entire app so that all
    // providers (auth, services, bookings, …) are accessible everywhere.
    const ProviderScope(
      child: HerfiyahApp(),
    ),
  );
}