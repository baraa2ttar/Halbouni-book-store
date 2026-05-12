import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/use_cases/use_case.dart';
import '../entities/product_entity.dart';
import '../repos/home_repo.dart';

class FetchProductsByCategoryUseCase
    extends UseCase<List<ProductEntity>, String> {
  final HomeRepo homeRepo;

  FetchProductsByCategoryUseCase(this.homeRepo);

  @override
  Future<Either<Failure, List<ProductEntity>>> call([String? param]) async {
    return await homeRepo.fetchProductsByCategory(
      categoryName: param ?? '',
    );
  }
}
