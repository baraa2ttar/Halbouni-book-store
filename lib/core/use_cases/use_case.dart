import 'package:dartz/dartz.dart';

import '../errors/failure.dart';

abstract class UseCase<T, Param> {
  // Every real subclass overrides this as `call([Param? param])` — the base
  // needs the same nullable, no-default optional parameter, or an
  // unbounded generic `Param` here resolves to a non-nullable optional
  // parameter with no default, which isn't valid under null safety and
  // cascades into "wrong argument count" errors at call sites everywhere.
  Future<Either<Failure, T>> call([Param? param]);
}

class NoParam {}
