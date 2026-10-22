import 'package:adv/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

import '../entities/pending_onboarding_profile.dart';

abstract class OnboardingRepo {
  /// Whether a Supabase session currently exists. Used to decide whether
  /// onboarding choices can be pushed to the backend immediately or must
  /// wait for the user to create an account.
  bool get isSignedIn;

  Future<bool> isCompleted();
  Future<void> setCompleted(bool value);
  Future<Either<Failure, void>> saveUserProfile({
    required List<String> interests,
    String? gender,
    String? ageRange,
  });

  Future<PendingOnboardingProfile> loadPendingProfile();

  /// Discards any locally staged (unsynced) onboarding draft. Call this on
  /// sign-out so a leftover draft from one account can never be replayed
  /// onto whichever account signs in next on this device.
  Future<void> clearPendingDraft();

  Future<void> savePendingDraft({
    List<String>? interests,
    String? gender,
    String? ageRange,
    int? ageIndex,
  });

  /// Pushes locally saved onboarding choices to `profiles` after the user signs in.
  Future<Either<Failure, void>> syncPendingProfile();
}
