part of 'cart_cubit.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartLoaded extends CartState {
  final List<CartItemModel> items;

  CartLoaded(this.items);
}

final class CartFailure extends CartState {
  final String message;

  CartFailure(this.message);
}
