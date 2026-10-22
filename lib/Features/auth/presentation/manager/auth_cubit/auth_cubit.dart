import 'package:adv/Features/auth/domain/entities/auth_entity.dart';
import 'package:adv/Features/auth/domain/repos/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepo) : super(AuthInitial());

  final AuthRepo _authRepo;

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    final result = await _authRepo.signUp(email: email, password: password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) {
        // No accessToken means Supabase created the account but returned no
        // session — email confirmation is pending. The user is NOT actually
        // signed in yet, so nothing was synced to `profiles`. Don't claim
        // success here; that false-positive is what broke onboarding sync.
        if (user.accessToken == null) {
          emit(AuthEmailConfirmationRequired(user.email));
        } else {
          emit(AuthAuthenticated(user, fromSignUp: true));
        }
      },
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    final result = await _authRepo.signIn(email: email, password: password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user, fromSignUp: false)),
    );
  }

  void reset() => emit(AuthInitial());

  Future<void> signOut() async {
    emit(AuthLoading());
    final result = await _authRepo.signOut();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthInitial()),
    );
  }
}
