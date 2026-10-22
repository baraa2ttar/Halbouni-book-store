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

  @HiveField(5)
  final String author;

  const CartItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    this.author = '',
  });

  factory CartItemModel.fromProductEntity(ProductEntity p, {int qty = 1}) {
    return CartItemModel(
      id: p.id,
      name: p.name,
      price: p.price,
      imageUrl: p.imageUrl,
      quantity: qty,
      author: p.bookDetails?.author ?? '',
    );
  }

  CartItemModel copyWith({
    String? id,
    String? name,
    double? price,
    String? imageUrl,
    int? quantity,
    String? author,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      author: author ?? this.author,
    );
  }
}
