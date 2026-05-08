import 'package:adv/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

abstract class OnboardingRepo {
  Future<bool> isCompleted();
  Future<void> setCompleted(bool value);
  Future<Either<Failure, void>> updateUserInterests({
    required List<String> interests,
  });
}

