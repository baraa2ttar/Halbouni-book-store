import 'dart:developer' as developer;

import '../constant/supabase_config.dart';

abstract final class AppConfig {
  AppConfig._();

  static String get supabaseUrl => SupabaseConfig.url;
  static String get supabaseAnonKey => SupabaseConfig.anonKey;

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  static void validate() {
    if (!isConfigured) {
      developer.log(
        '═══════════════════════════════════════════════════════════\n'
        '  Supabase credentials not configured!\n'
        '  Run with:\n'
        '  flutter run --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co '
        '--dart-define=SUPABASE_ANON_KEY=YOUR_PUBLIC_ANON_KEY\n'
        '═══════════════════════════════════════════════════════════',
        name: 'AppConfig',
      );
    }
  }
}
