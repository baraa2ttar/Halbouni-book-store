abstract final class SupabaseConfig {
  /// Read from `--dart-define=SUPABASE_URL=...` at build/run time.
  /// Falls back to the (previously hardcoded) development project URL.
  static const url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://ghzqbleakxfajzfrjudr.supabase.co',
  );

  /// Read from `--dart-define=SUPABASE_ANON_KEY=...` at build/run time.
  /// Falls back to the publishable anon key of the development project.
  static const anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_6vx5rtY8xfgcorArweZ6ZA_gXyhnTMY',
  );

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;

  @Deprecated('Use AppConfig.validate() instead')
  static void validate() {}
}