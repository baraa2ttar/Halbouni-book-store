part of 'newest_books_cubit.dart';

@immutable
sealed class NewestBooksState {
  const NewestBooksState();
}

final class NewestBooksInitial extends NewestBooksState {}
final class NewestBooksLoading extends NewestBooksState {}

final class NewestBooksSuccess extends NewestBooksState {
  final List<ProductEntity> books;
  final List<CategoryEntity> categories;
  final String? activeCategoryId;

  const NewestBooksSuccess({
    required this.books,
    this.categories = const [],
    this.activeCategoryId,
  });
}

final class NewestBooksFailure extends NewestBooksState {
  final String message;

  const NewestBooksFailure(this.message);
}