import 'package:adv/Features/Home/domain/entities/category_entity.dart';
import 'package:adv/Features/Home/domain/entities/product_entity.dart';
import 'package:adv/Features/Home/domain/use_cases/fetch_categories_use_case.dart';
import 'package:adv/Features/Home/domain/use_cases/fetch_newest_books_use_case.dart';
import 'package:adv/Features/Home/domain/use_cases/fetch_products_by_category_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'newest_books_state.dart';

class NewestBooksCubit extends Cubit<NewestBooksState> {
  NewestBooksCubit(
    this.fetchNewestBooksUseCase,
    this.fetchProductsByCategoryUseCase,
    this.fetchCategoriesUseCase,
  ) : super(NewestBooksInitial());

  final FetchNewestBooksUseCase fetchNewestBooksUseCase;
  final FetchProductsByCategoryUseCase fetchProductsByCategoryUseCase;
  final FetchCategoriesUseCase fetchCategoriesUseCase;

  String? _activeCategoryId;
  List<CategoryEntity> _categories = const [];
  Future<List<CategoryEntity>>? _categoriesFuture;
  int _requestId = 0;

  String? get activeCategoryId => _activeCategoryId;
  List<CategoryEntity> get categories => _categories;

  Future<void> fetchNewestBooks({String? categoryId, bool refresh = false}) async {
    final requestId = ++_requestId;
    _activeCategoryId = categoryId;

    // Refresh in place: keep the current list visible instead of flashing a
    // loading spinner. Only when we already have data to show.
    final hasData = state is NewestBooksSuccess &&
        (state as NewestBooksSuccess).books.isNotEmpty;

    if (!(refresh && hasData)) {
      emit(NewestBooksLoading());
    }

    // Load categories once (non-blocking); reused across requests.
    final categoriesFuture = _loadCategoriesOnce();

    final result = categoryId != null && categoryId.isNotEmpty
        ? await fetchProductsByCategoryUseCase.call(categoryId)
        : await fetchNewestBooksUseCase.call();

    final categories = await categoriesFuture;

    // Ignore stale responses from older, superseded requests.
    if (requestId != _requestId) return;

    result.fold(
      (failure) => emit(NewestBooksFailure(failure.message)),
      (books) => emit(
        NewestBooksSuccess(
          books: books,
          categories: categories,
          activeCategoryId: _activeCategoryId,
        ),
      ),
    );
  }

  Future<List<CategoryEntity>> _loadCategoriesOnce() {
    return _categoriesFuture ??= _fetchCategories();
  }

  Future<List<CategoryEntity>> _fetchCategories() async {
    final result = await fetchCategoriesUseCase.call();
    _categories = result.fold(
      (failure) => const <CategoryEntity>[],
      (categories) => categories,
    );
    return _categories;
  }
}