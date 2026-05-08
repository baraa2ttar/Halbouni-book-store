import 'package:adv/Features/Auth/domain/entities/auth_entity.dart';
import 'package:adv/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

abstract interface class AuthRepo {
  Future<Either<Failure, AuthEntity>> signUp({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthEntity>> signIn({
    required String email,
    required String password,
  });
}
