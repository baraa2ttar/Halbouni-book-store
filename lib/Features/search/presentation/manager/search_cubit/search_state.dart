part of 'search_cubit.dart';

sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

final class SearchSuccess extends SearchState {
  SearchSuccess(this.products);

  final List<ProductEntity> products;
}

final class SearchFailure extends SearchState {
  SearchFailure(this.message);

  final String message;
}
