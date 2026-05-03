import '../../domain/repos/onboarding_repo.dart';
import '../datasources/onboarding_local_data_source.dart';

class OnboardingRepoImpl implements OnboardingRepo {
  final OnboardingLocalDataSource _local;
  const OnboardingRepoImpl(this._local);

  @override
  Future<bool> isCompleted() => _local.isCompleted();

  @override
  Future<void> setCompleted(bool value) => _local.setCompleted(value);
}

