/// Environment configuration loaded from .env file
///
/// Usage: add `flutter_dotenv` to pubspec.yaml, load in main.dart,
/// then access via EnvConfig.supabaseUrl.
class EnvConfig {
  EnvConfig._();

  /// Supabase project URL
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project-id.supabase.co',
  );

  /// Supabase anon public key
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.placeholder',
  );
}