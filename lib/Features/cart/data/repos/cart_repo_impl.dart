import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/repos/cart_repo.dart';
import '../models/cart_item_model.dart';

class CartRepoImpl implements CartRepo {
  final Box<CartItemModel> _box;

  CartRepoImpl({required Box<CartItemModel> box}) : _box = box;

  @override
  Future<Either<Failure, List<CartItemModel>>> fetchCartItems() async {
    try {
      final items = _box.values.toList();
      return right(items);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToCart(CartItemModel item) async {
    try {
      await _box.put(item.id, item);
      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(String productId) async {
    try {
      await _box.delete(productId);
      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateQuantity(
    String productId,
    int quantity,
  ) async {
    try {
      final existing = _box.get(productId);
      if (existing == null) {
        return left(ServerFailure('Item not found in cart'));
      }
      final updated = CartItemModel(
        id: existing.id,
        name: existing.name,
        price: existing.price,
        imageUrl: existing.imageUrl,
        quantity: quantity,
      );
      await _box.put(productId, updated);
      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
