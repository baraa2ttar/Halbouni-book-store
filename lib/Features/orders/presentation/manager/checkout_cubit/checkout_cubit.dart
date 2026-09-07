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

  Future<void> placeOrder({
    required List<CartItemModel> items,
    required double total,
    String? notes,
  }) async {
    emit(const CheckoutLoading());
    final result = await _ordersRepo.createOrder(
      items: items,
      total: total,
      notes: notes,
    );
    await result.fold(
      (failure) async => emit(CheckoutFailure(failure.message)),
      (order) async {
        final clearResult = await _cartRepo.clearCart();
        clearResult.fold(
          (failure) => emit(CheckoutFailure(failure.message)),
          (_) => emit(CheckoutSuccess(order)),
        );
      },
    );
  }
}
