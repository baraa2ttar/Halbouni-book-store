import 'package:adv/Features/Home/domain/entities/book_entity.dart';
import 'package:adv/Features/Home/domain/use_cases/fetch_featured_books_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'featured_books_state.dart';

class FeaturedBooksCubit extends Cubit<FeaturedBooksState> {
  FeaturedBooksCubit(this.featuredBooksUseCase) : super(FeaturedBooksInitial());

 final FetchFeaturedBooksUseCase featuredBooksUseCase ;
 int _pageNumber = 0;
 bool _isFetching = false;
 bool _hasReachedMax = false;
 final List<BookEntity> _books = [];

  Future <void> fetchFeaturedBooks({bool loadMore = false}) async{
    if (_isFetching) return;
    if (loadMore && _hasReachedMax) return;

    _isFetching = true;

    if (!loadMore) {
      _pageNumber = 0;
      _hasReachedMax = false;
      _books.clear();
      emit(FeaturedBooksLoading());
    } else {
      emit(
        FeaturedBooksSuccess(
          List<BookEntity>.from(_books),
          isLoadingMore: true,
          hasReachedMax: _hasReachedMax,
        ),
      );
    }

    var result = await featuredBooksUseCase.call(_pageNumber);
    result.fold((failure) {
      emit(FeaturedBooksFailure(failure.message));
    },
        (books){
      if (books.isEmpty) {
        _hasReachedMax = true;
      } else {
        _books.addAll(books);
        _pageNumber++;
      }

      emit(
        FeaturedBooksSuccess(
          List<BookEntity>.from(_books),
          isLoadingMore: false,
          hasReachedMax: _hasReachedMax,
        ),
      );
    });
    _isFetching = false;
  }
}
