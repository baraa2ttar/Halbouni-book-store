import '../../domain/entities/pending_onboarding_profile.dart';
import '../../domain/repos/onboarding_repo.dart';
import 'package:adv/Features/profile/domain/repos/profile_repo.dart';
import 'package:adv/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/onboarding_local_data_source.dart';

class OnboardingRepoImpl implements OnboardingRepo {
  final OnboardingLocalDataSource _local;
  final ProfileRepo? _profileRepo;
  final SupabaseClient? _client;

  const OnboardingRepoImpl(this._local, this._profileRepo, [this._client]);

  bool get _isSignedIn {
    try {
      return (_client ?? Supabase.instance.client).auth.currentUser != null;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> isCompleted() => _local.isCompleted();

  @override
  Future<void> setCompleted(bool value) => _local.setCompleted(value);

  @override
  Future<PendingOnboardingProfile> loadPendingProfile() =>
      _local.loadPendingProfile();

  @override
  Future<void> savePendingDraft({
    List<String>? interests,
    String? gender,
    String? ageRange,
    int? ageIndex,
  }) {
    return _local.savePendingProfile(
      interests: interests,
      gender: gender,
      ageRange: ageRange,
      ageIndex: ageIndex,
    );
  }

  @override
  Future<Either<Failure, void>> saveUserProfile({
    required List<String> interests,
    String? gender,
    String? ageRange,
  }) async {
    await _local.savePendingProfile(
      interests: interests,
      gender: gender,
      ageRange: ageRange,
    );

    if (!_isSignedIn) {
      return right(null);
    }

    final profileRepo = _profileRepo;
    if (profileRepo == null) {
      return left(ServerFailure('Supabase not configured'));
    }

    final result = await profileRepo.saveProfile(
      interests: interests,
      gender: gender,
      ageRange: ageRange,
    );
    if (result.isLeft()) return result;
    await _local.clearPendingProfile();
    return right(null);
  }

  @override
  Future<Either<Failure, void>> syncPendingProfile() async {
    if (!_isSignedIn) return right(null);

    final pending = await _local.loadPendingProfile();
    if (!pending.hasData) return right(null);

    final profileRepo = _profileRepo;
    if (profileRepo == null) {
      return left(ServerFailure('Supabase not configured'));
    }

    final result = await profileRepo.saveProfile(
      interests: pending.interests,
      gender: pending.gender,
      ageRange: pending.ageRange,
    );
    if (result.isLeft()) return result;
    await _local.clearPendingProfile();
    return right(null);
  }
}
