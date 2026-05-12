import 'package:adv/Features/Home/domain/entities/product_entity.dart';
import 'package:adv/Features/Home/domain/use_cases/fetch_newest_books_use_case.dart';
import 'package:adv/Features/Home/domain/use_cases/fetch_products_by_category_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'newest_books_state.dart';

class NewestBooksCubit extends Cubit<NewestBooksState> {
  NewestBooksCubit(
    this.fetchNewestBooksUseCase,
    this.fetchProductsByCategoryUseCase,
  ) : super(NewestBooksInitial());

  final FetchNewestBooksUseCase fetchNewestBooksUseCase;
  final FetchProductsByCategoryUseCase fetchProductsByCategoryUseCase;

  String? _activeCategory;

  String? get activeCategory => _activeCategory;

  Future<void> fetchNewestBooks({String? categoryName}) async {
    _activeCategory = categoryName;
    emit(NewestBooksLoading());

    final result = categoryName != null && categoryName.isNotEmpty
        ? await fetchProductsByCategoryUseCase.call(categoryName)
        : await fetchNewestBooksUseCase.call();

    result.fold(
      (failure) => emit(NewestBooksFailure(failure.message)),
      (books) => emit(NewestBooksSuccess(books)),
    );
  }
}
