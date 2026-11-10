import 'package:adv/Features/Home/domain/entities/product_entity.dart';
import 'package:adv/Features/Home/domain/use_cases/fetch_featured_books_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'featured_books_state.dart';

class FeaturedBooksCubit extends Cubit<FeaturedBooksState> {
  FeaturedBooksCubit(this.featuredBooksUseCase) : super(FeaturedBooksInitial());

  final FetchFeaturedBooksUseCase featuredBooksUseCase;
  int _pageNumber = 0;
  bool _isFetching = false;
  bool _hasReachedMax = false;
  final List<ProductEntity> _books = [];

  Future<void> fetchFeaturedBooks({
    bool loadMore = false,
    bool refresh = false,
  }) async {
    if (_isFetching) return;
    if (loadMore && _hasReachedMax) return;

    _isFetching = true;

    // Refresh in place: keep the current list visible instead of flashing a
    // loading spinner. Only when we already have data to show.
    final hasData = state is FeaturedBooksSuccess &&
        (state as FeaturedBooksSuccess).book.isNotEmpty;

    if (refresh && hasData) {
      _pageNumber = 0;
      _hasReachedMax = false;
      // Keep _books shown until the fresh first page arrives.
    } else if (!loadMore) {
      _pageNumber = 0;
      _hasReachedMax = false;
      _books.clear();
      emit(FeaturedBooksLoading());
    } else {
      emit(
        FeaturedBooksSuccess(
          List<ProductEntity>.from(_books),
          isLoadingMore: true,
          hasReachedMax: _hasReachedMax,
        ),
      );
    }

    final result = await featuredBooksUseCase.call(_pageNumber);
    result.fold((failure) {
      emit(FeaturedBooksFailure(failure.message));
    }, (books) {
      if (refresh && hasData) {
        // Swap in the fresh first page, replacing the list kept on screen.
        _books
          ..clear()
          ..addAll(books);
        _pageNumber = books.isEmpty ? 0 : 1;
        _hasReachedMax = books.isEmpty;
      } else if (books.isEmpty) {
        _hasReachedMax = true;
      } else {
        _books.addAll(books);
        _pageNumber++;
      }

      emit(
        FeaturedBooksSuccess(
          List<ProductEntity>.from(_books),
          isLoadingMore: false,
          hasReachedMax: _hasReachedMax,
        ),
      );
    });
    _isFetching = false;
  }
}
