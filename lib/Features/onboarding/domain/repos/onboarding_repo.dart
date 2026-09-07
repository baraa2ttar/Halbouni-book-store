import 'package:adv/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

import '../entities/pending_onboarding_profile.dart';

abstract class OnboardingRepo {
  Future<bool> isCompleted();
  Future<void> setCompleted(bool value);
  Future<Either<Failure, void>> saveUserProfile({
    required List<String> interests,
    String? gender,
    String? ageRange,
  });

  Future<PendingOnboardingProfile> loadPendingProfile();

  Future<void> savePendingDraft({
    List<String>? interests,
    String? gender,
    String? ageRange,
    int? ageIndex,
  });

  /// Pushes locally saved onboarding choices to `profiles` after the user signs in.
  Future<Either<Failure, void>> syncPendingProfile();
}
