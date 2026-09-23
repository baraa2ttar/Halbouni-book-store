import 'package:adv/Features/cart/data/models/cart_item_model.dart';
import 'package:adv/Features/orders/domain/entities/order_entity.dart';
import 'package:adv/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

abstract interface class OrdersRepo {
  Future<Either<Failure, OrderEntity>> createOrder({
    required List<CartItemModel> items,
    String? notes,
  });
}
