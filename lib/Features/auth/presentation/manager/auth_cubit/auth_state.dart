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

final class AuthError extends AuthState {
  AuthError(this.message);

  final String message;
}
