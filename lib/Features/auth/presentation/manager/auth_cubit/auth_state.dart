part of 'auth_cubit.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthAuthenticated extends AuthState {
  AuthAuthenticated(this.user, {this.fromSignUp = false});

  final AuthEntity user;

  /// When true, [user] arrived from [AuthCubit.signUp] — UI should branch (e.g. interests / profile onboarding).
  final bool fromSignUp;
}

/// Account was created but Supabase returned no session — email
/// confirmation is required before the user is actually signed in.
/// Treat this distinctly from [AuthAuthenticated]: nothing was synced to
/// `profiles` yet, and the app should not claim the user is logged in.
final class AuthEmailConfirmationRequired extends AuthState {
  AuthEmailConfirmationRequired(this.email);

  final String email;
}

final class AuthError extends AuthState {
  AuthError(this.message);

  final String message;
}
