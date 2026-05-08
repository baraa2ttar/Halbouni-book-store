/// Authenticated Supabase user data for linking to `profiles` and app state.
class AuthEntity {
  final String id;
  final String email;
  /// Present when Supabase returned a session (e.g. after sign-in, or sign-up without email confirmation blocking session).
  final String? accessToken;
  /// Raw Supabase user metadata (JSON); safe for eventual profile syncing.
  final Map<String, dynamic> userMetadata;

  const AuthEntity({
    required this.id,
    required this.email,
    this.accessToken,
    this.userMetadata = const {},
  });
}
