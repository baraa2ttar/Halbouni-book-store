abstract class OnboardingRepo {
  Future<bool> isCompleted();
  Future<void> setCompleted(bool value);
}

