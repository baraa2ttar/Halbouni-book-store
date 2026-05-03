import '../repos/onboarding_repo.dart';

class IsOnboardingCompletedUseCase {
  final OnboardingRepo _repo;
  const IsOnboardingCompletedUseCase(this._repo);

  Future<bool> call() => _repo.isCompleted();
}

