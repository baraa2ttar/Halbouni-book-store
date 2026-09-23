import 'package:dartz/dartz.dart';

import '../errors/failure.dart';

abstract class UseCase<Result, Param> {
  Future<Either<Failure, Result>> call([Param param]);
}

class NoParam {}