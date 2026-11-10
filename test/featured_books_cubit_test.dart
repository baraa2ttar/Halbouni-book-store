import 'package:adv/Features/Home/domain/entities/category_entity.dart';
import 'package:adv/Features/Home/domain/entities/product_entity.dart';
import 'package:adv/Features/Home/domain/repos/home_repo.dart';
import 'package:adv/Features/Home/domain/use_cases/fetch_featured_books_use_case.dart';
import 'package:adv/Features/Home/presentation/manager/featured_books_cubit/featured_books_cubit.dart';
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
      isFeatured: true,
    );

/// Minimal fake repo: only [fetchFeaturedBooks] is exercised here.
class _FakeHomeRepo implements HomeRepo {
  _FakeHomeRepo(this.books);
  final List<ProductEntity> books;

  @override
  Future<Either<Failure, List<ProductEntity>>> fetchFeaturedBooks({
    int pageNumber = 0,
  }) async =>
      right(books);

  @override
  Future<Either<Failure, List<ProductEntity>>> fetchNewestBooks() async =>
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
  Future<Either<Failure, List<CategoryEntity>>> fetchCategories() async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<ProductEntity>>> fetchProductsByCategory({
    required String categoryId,
  }) async =>
      throw UnimplementedError();
}

void main() {
  group('FeaturedBooksCubit', () {
    test('does not pass through Loading on refresh', () async {
      final cubit = FeaturedBooksCubit(
        FetchFeaturedBooksUseCase(_FakeHomeRepo([_product('1'), _product('2')])),
      );
      // Prime the cubit with a successful first page so there is data to keep.
      await cubit.fetchFeaturedBooks();
      expect(cubit.state, isA<FeaturedBooksSuccess>());

      final states = <FeaturedBooksState>[];
      final sub = cubit.stream.listen(states.add);
      await cubit.fetchFeaturedBooks(refresh: true);
      await Future.delayed(Duration.zero); // flush pending stream events
      await sub.cancel();

      expect(states, isNot(contains(isA<FeaturedBooksLoading>())));
      expect(cubit.state, isA<FeaturedBooksSuccess>());

      await cubit.close();
    });
  });
}
