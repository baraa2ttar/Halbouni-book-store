import '../../domain/repos/onboarding_repo.dart';
import 'package:adv/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/onboarding_local_data_source.dart';

class OnboardingRepoImpl implements OnboardingRepo {
  final OnboardingLocalDataSource _local;
  final SupabaseClient _supabase;
  const OnboardingRepoImpl(this._local, this._supabase);

  @override
  Future<bool> isCompleted() => _local.isCompleted();

  @override
  Future<void> setCompleted(bool value) => _local.setCompleted(value);

  @override
  Future<Either<Failure, void>> updateUserInterests({
    required List<String> interests,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        return left(ServerFailure('No authenticated user found'));
      }
      await _supabase
          .from('profiles')
          .update({'interests': interests})
          .eq('id', user.id);
      return right(null);
    } on AuthException catch (e) {
      return left(ServerFailure(e.message));
    } on PostgrestException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}

