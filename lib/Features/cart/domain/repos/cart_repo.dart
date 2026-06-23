import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../data/models/cart_item_model.dart';

abstract class CartRepo {
  Future<Either<Failure, List<CartItemModel>>> fetchCartItems();

  Future<Either<Failure, void>> addToCart(CartItemModel item);

  Future<Either<Failure, void>> removeFromCart(String productId);

  Future<Either<Failure, void>> updateQuantity(
    String productId,
    int quantity,
  );
}
