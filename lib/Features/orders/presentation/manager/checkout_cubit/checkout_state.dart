part of 'checkout_cubit.dart';

sealed class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

final class CheckoutInitial extends CheckoutState {
  const CheckoutInitial();
}

final class CheckoutLoading extends CheckoutState {
  const CheckoutLoading();
}

final class CheckoutSuccess extends CheckoutState {
  const CheckoutSuccess(this.order, {this.warning});

  final OrderEntity order;

  /// Set when the order was placed but the local cart could not be cleared.
  final String? warning;

  @override
  List<Object?> get props => [order, warning];
}

final class CheckoutFailure extends CheckoutState {
  const CheckoutFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
