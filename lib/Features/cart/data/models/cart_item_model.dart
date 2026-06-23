import 'package:hive/hive.dart';

import '../../../Home/domain/entities/product_entity.dart';

part 'cart_item_model.g.dart';

@HiveType(typeId: 1)
class CartItemModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  final int quantity;

  const CartItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });

  factory CartItemModel.fromProductEntity(ProductEntity p, {int qty = 1}) {
    return CartItemModel(
      id: p.id,
      name: p.name,
      price: p.price,
      imageUrl: p.imageUrl,
      quantity: qty,
    );
  }
}
