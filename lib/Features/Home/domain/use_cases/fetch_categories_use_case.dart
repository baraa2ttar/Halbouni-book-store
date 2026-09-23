import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/use_cases/use_case.dart';
import '../entities/category_entity.dart';
import '../repos/home_repo.dart';

class FetchCategoriesUseCase extends UseCase<List<CategoryEntity>, NoParam> {
  final HomeRepo homeRepo;

  FetchCategoriesUseCase(this.homeRepo);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call([NoParam? param]) async {
    return await homeRepo.fetchCategories();
  }
}