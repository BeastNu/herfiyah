/// Application-wide constants for the Herfiyah (حِرفيّة) marketplace.
///
/// Keep magic numbers, keys, and configuration values here so they are easy
/// to find and change in one place.

class AppConstants {
  AppConstants._();

  // --- Brand ----------------------------------------------------------------
  static const String appName = 'Herfiyah';
  static const String appNameArabic = 'حرفية';

  // --- API / Supabase -------------------------------------------------------
  // TODO: Move to environment variables or .env file before release.
  static const String supabaseUrl = 'https://your-project-id.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.placeholder';

  // --- Pagination -----------------------------------------------------------
  static const int pageSize = 20;

  // --- Debounce / Throttle --------------------------------------------------
  static const Duration searchDebounce = Duration(milliseconds: 400);
}