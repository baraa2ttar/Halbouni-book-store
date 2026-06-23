import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../Home/domain/entities/product_entity.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../domain/repos/cart_repo.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepo _cartRepo;

  CartCubit(this._cartRepo) : super(CartInitial());

  Future<void> loadCart() async {
    emit(CartLoading());
    final result = await _cartRepo.fetchCartItems();
    result.fold(
      (failure) => emit(CartFailure(failure.message)),
      (items) => emit(CartLoaded(items)),
    );
  }

  Future<void> addItem(ProductEntity product) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      final existingIndex =
          currentState.items.indexWhere((item) => item.id == product.id);
      if (existingIndex != -1) {
        await changeQuantity(product.id, 1);
        return;
      }
    }

    final item = CartItemModel.fromProductEntity(product);
    final result = await _cartRepo.addToCart(item);
    result.fold(
      (failure) => emit(CartFailure(failure.message)),
      (_) => loadCart(),
    );
  }

  Future<void> removeItem(String productId) async {
    final result = await _cartRepo.removeFromCart(productId);
    result.fold(
      (failure) => emit(CartFailure(failure.message)),
      (_) => loadCart(),
    );
  }

  Future<void> changeQuantity(String productId, int delta) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    final existingIndex =
        currentState.items.indexWhere((item) => item.id == productId);
    if (existingIndex == -1) return;

    final existing = currentState.items[existingIndex];
    final newQuantity = existing.quantity + delta;

    if (newQuantity <= 0) {
      await removeItem(productId);
      return;
    }

    final result = await _cartRepo.updateQuantity(productId, newQuantity);
    result.fold(
      (failure) => emit(CartFailure(failure.message)),
      (_) => loadCart(),
    );
  }
}
