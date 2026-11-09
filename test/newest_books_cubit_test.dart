import 'package:adv/Features/Home/domain/entities/category_entity.dart';
import 'package:adv/Features/Home/domain/entities/product_entity.dart';
import 'package:adv/Features/Home/domain/repos/home_repo.dart';
import 'package:adv/Features/Home/domain/use_cases/fetch_categories_use_case.dart';
import 'package:adv/Features/Home/domain/use_cases/fetch_newest_books_use_case.dart';
import 'package:adv/Features/Home/domain/use_cases/fetch_products_by_category_use_case.dart';
import 'package:adv/Features/Home/presentation/manager/newest_books_cubit/newest_books_cubit.dart';
import 'package:adv/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

ProductEntity _product(String id) => ProductEntity(
      id: id,
      name: 'Book $id',
      price: 10,
      imageUrl: '',
      categoryId: 'c',
      categoryName: 'Cat',
      isFeatured: false,
    );

/// Minimal fake repo: only [fetchNewestBooks] and [fetchCategories] are used.
class _FakeHomeRepo implements HomeRepo {
  _FakeHomeRepo(this.newest);

  final List<ProductEntity> newest;

  @override
  Future<Either<Failure, List<ProductEntity>>> fetchNewestBooks() async =>
      right(newest);

  @override
  Future<Either<Failure, List<CategoryEntity>>> fetchCategories() async =>
      right(const <CategoryEntity>[]);

  @override
  Future<Either<Failure, List<ProductEntity>>> fetchFeaturedBooks({
    int pageNumber = 0,
  }) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, ProductEntity>> fetchProductById({
    required String productId,
  }) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts({
    required String query,
  }) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<ProductEntity>>> fetchProductsByCategory({
    required String categoryId,
  }) async =>
      throw UnimplementedError();
}

void main() {
  group('NewestBooksCubit', () {
    test('does not pass through Loading on refresh', () async {
      final repo = _FakeHomeRepo([_product('1'), _product('2')]);
      final cubit = NewestBooksCubit(
        FetchNewestBooksUseCase(repo),
        FetchProductsByCategoryUseCase(repo),
        FetchCategoriesUseCase(repo),
      );
      // Prime the cubit with a successful first load so there is data to keep.
      await cubit.fetchNewestBooks();
      expect(cubit.state, isA<NewestBooksSuccess>());

      final states = <NewestBooksState>[];
      final sub = cubit.stream.listen(states.add);
      await cubit.fetchNewestBooks(refresh: true);
      await Future.delayed(Duration.zero); // flush pending stream events
      await sub.cancel();

      expect(states, isNot(contains(isA<NewestBooksLoading>())));
      expect(cubit.state, isA<NewestBooksSuccess>());

      await cubit.close();
    });
  });
}
