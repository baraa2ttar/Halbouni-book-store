import '../repos/onboarding_repo.dart';

class CompleteOnboardingUseCase {
  final OnboardingRepo _repo;
  const CompleteOnboardingUseCase(this._repo);

  Future<void> call() => _repo.setCompleted(true);
}

