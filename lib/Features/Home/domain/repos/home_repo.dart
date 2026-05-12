import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/product_entity.dart';

abstract class HomeRepo {
  Future<Either<Failure, List<ProductEntity>>> fetchFeaturedBooks({
    int pageNumber = 0,
  });

  Future<Either<Failure, List<ProductEntity>>> fetchNewestBooks();

  Future<Either<Failure, ProductEntity>> fetchProductById({
    required String productId,
  });

  Future<Either<Failure, List<ProductEntity>>> searchProducts({
    required String query,
  });

  Future<Either<Failure, List<ProductEntity>>> fetchProductsByCategory({
    required String categoryName,
  });
}