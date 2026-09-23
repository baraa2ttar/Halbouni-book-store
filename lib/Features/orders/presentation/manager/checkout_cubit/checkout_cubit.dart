import 'package:adv/Features/cart/data/models/cart_item_model.dart';
import 'package:adv/Features/cart/domain/repos/cart_repo.dart';
import 'package:adv/Features/orders/domain/entities/order_entity.dart';
import 'package:adv/Features/orders/domain/repos/orders_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit(this._ordersRepo, this._cartRepo) : super(const CheckoutInitial());

  final OrdersRepo _ordersRepo;
  final CartRepo _cartRepo;

  bool _submitting = false;

  Future<void> placeOrder({
    required List<CartItemModel> items,
    String? notes,
  }) async {
    if (_submitting) return;
    _submitting = true;
    emit(const CheckoutLoading());

    try {
      final result = await _ordersRepo.createOrder(items: items, notes: notes);
      await result.fold(
        (failure) async => emit(CheckoutFailure(failure.message)),
        (order) async {
          final clearResult = await _cartRepo.clearCart();
          final warning = clearResult.fold(
            (failure) => failure.message,
            (_) => null,
          );
          emit(CheckoutSuccess(order, warning: warning));
        },
      );
    } finally {
      _submitting = false;
    }
  }
}