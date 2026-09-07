import 'package:adv/Features/profile/domain/entities/profile_entity.dart';
import 'package:adv/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

abstract interface class ProfileRepo {
  Future<Either<Failure, ProfileEntity>> fetchProfile();

  Future<Either<Failure, void>> saveProfile({
    required List<String> interests,
    String? gender,
    String? ageRange,
  });

  Future<Either<Failure, void>> ensureProfile({
    required String userId,
    required String email,
  });
}
