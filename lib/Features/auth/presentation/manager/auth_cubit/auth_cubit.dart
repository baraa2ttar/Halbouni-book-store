import 'package:adv/Features/Auth/domain/entities/auth_entity.dart';
import 'package:adv/Features/Auth/domain/repos/auth_repo.dart';
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
      (user) => emit(AuthAuthenticated(user, fromSignUp: true)),
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
}
