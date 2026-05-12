part of 'product_details_cubit.dart';

sealed class ProductDetailsState {}

final class ProductDetailsInitial extends ProductDetailsState {}

final class ProductDetailsLoading extends ProductDetailsState {}

final class ProductDetailsSuccess extends ProductDetailsState {
  ProductDetailsSuccess(this.product);

  final ProductEntity product;
}

final class ProductDetailsFailure extends ProductDetailsState {
  ProductDetailsFailure(this.message);

  final String message;
}
