abstract final class SupabaseConfig {
  static const url = 'https://ghzqbleakxfajzfrjudr.supabase.co';
  static const anonKey =
      'sb_publishable_6vx5rtY8xfgcorArweZ6ZA_gXyhnTMY';

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;
}
