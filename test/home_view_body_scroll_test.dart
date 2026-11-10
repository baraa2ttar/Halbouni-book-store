import 'package:adv/Features/Home/domain/entities/category_entity.dart';
import 'package:adv/Features/Home/domain/entities/product_entity.dart';
import 'package:adv/Features/Home/domain/repos/home_repo.dart';
import 'package:adv/Features/Home/domain/use_cases/fetch_categories_use_case.dart';
import 'package:adv/Features/Home/domain/use_cases/fetch_featured_books_use_case.dart';
import 'package:adv/Features/Home/domain/use_cases/fetch_newest_books_use_case.dart';
import 'package:adv/Features/Home/domain/use_cases/fetch_products_by_category_use_case.dart';
import 'package:adv/Features/Home/presentation/manager/featured_books_cubit/featured_books_cubit.dart';
import 'package:adv/Features/Home/presentation/manager/newest_books_cubit/newest_books_cubit.dart';
import 'package:adv/Features/Home/presentation/views/widgets/home_view_body.dart';
import 'package:adv/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

ProductEntity _product(String name, {bool featured = false}) => ProductEntity(
      id: name,
      name: name,
      price: 10,
      // Empty URL keeps the test off the network; CachedNetworkImage falls
      // back to its errorWidget (a bundled asset).
      imageUrl: '',
      categoryId: 'c',
      categoryName: 'Cat',
      isFeatured: featured,
    );

/// Minimal fake repo: featured (page 0 only) and newest are exercised here.
class _FakeHomeRepo implements HomeRepo {
  _FakeHomeRepo({required this.newest, required this.featured});

  final List<ProductEntity> newest;
  final List<ProductEntity> featured;

  @override
  Future<Either<Failure, List<ProductEntity>>> fetchFeaturedBooks({
    int pageNumber = 0,
  }) async =>
      pageNumber == 0 ? right(featured) : right(const <ProductEntity>[]);

  @override
  Future<Either<Failure, List<ProductEntity>>> fetchNewestBooks() async =>
      right(newest);

  @override
  Future<Either<Failure, List<CategoryEntity>>> fetchCategories() async =>
      right(const <CategoryEntity>[]);

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
  testWidgets('scrolls through 30 books to the last item with no overflow',
      (tester) async {
    final repo = _FakeHomeRepo(
      newest: [for (var i = 0; i < 30; i++) _product('Book $i')],
      featured: [
        _product('Featured 0', featured: true),
        _product('Featured 1', featured: true),
      ],
    );
    final featuredCubit = FeaturedBooksCubit(FetchFeaturedBooksUseCase(repo));
    final newestCubit = NewestBooksCubit(
      FetchNewestBooksUseCase(repo),
      FetchProductsByCategoryUseCase(repo),
      FetchCategoriesUseCase(repo),
    );
    // Prime both cubits with data before building the view.
    await featuredCubit.fetchFeaturedBooks();
    await newestCubit.fetchNewestBooks();

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) => MaterialApp(
          home: Scaffold(
            body: MultiBlocProvider(
              providers: [
                BlocProvider<FeaturedBooksCubit>.value(value: featuredCubit),
                BlocProvider<NewestBooksCubit>.value(value: newestCubit),
              ],
              child: const HomeViewBody(),
            ),
          ),
        ),
      ),
    );

    // Lay out the first frame and let the cached images start resolving.
    // Manual pumps (no pumpAndSettle): CachedNetworkImage placeholders animate
    // while loading, which would make pumpAndSettle time out.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Book 0'), findsOneWidget);

    // The whole page is one CustomScrollView; scroll it down to the 30th book.
    final last = find.text('Book 29');
    var guard = 0;
    while (last.evaluate().isEmpty && guard < 80) {
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
      await tester.pump();
      guard++;
    }
    expect(last, findsOneWidget);

    // No RenderFlex overflow or other framework errors should have fired.
    expect(tester.takeException(), isNull);

    await featuredCubit.close();
    await newestCubit.close();
  });
}
