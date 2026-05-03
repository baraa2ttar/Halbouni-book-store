part of 'featured_books_cubit.dart';

@immutable
sealed class FeaturedBooksState {}

final class FeaturedBooksInitial extends FeaturedBooksState {}
final class FeaturedBooksLoading extends FeaturedBooksState {}
final class FeaturedBooksFailure extends FeaturedBooksState {
  final String message;

  FeaturedBooksFailure(this.message);
}
final class FeaturedBooksSuccess extends FeaturedBooksState {
  final List <BookEntity> book ;
  final bool isLoadingMore;
  final bool hasReachedMax;

  FeaturedBooksSuccess(
    this.book, {
    this.isLoadingMore = false,
    this.hasReachedMax = false,
  });
}
