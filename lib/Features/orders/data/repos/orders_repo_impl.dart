import 'package:adv/Features/cart/data/models/cart_item_model.dart';
import 'package:adv/Features/orders/domain/entities/order_entity.dart';
import 'package:adv/Features/orders/domain/repos/orders_repo.dart';
import 'package:adv/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrdersRepoImpl implements OrdersRepo {
  OrdersRepoImpl({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<Either<Failure, OrderEntity>> createOrder({
    required List<CartItemModel> items,
    required double total,
    String? notes,
  }) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        return left(ServerFailure('You must be signed in to place an order'));
      }
      if (items.isEmpty) {
        return left(ServerFailure('Your cart is empty'));
      }

      final orderRow = await _client
          .from('orders')
          .insert({
            'user_id': user.id,
            'total': total,
            'status': 'pending',
            if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
          })
          .select()
          .single();

      final orderId = orderRow['id'] as String;

      final orderItems = items
          .map(
            (item) => {
              'order_id': orderId,
              'product_id': item.id,
              'quantity': item.quantity,
              'price': item.price,
            },
          )
          .toList();

      await _client.from('order_items').insert(orderItems);

      return right(
        OrderEntity(
          id: orderId,
          userId: user.id,
          total: (orderRow['total'] as num).toDouble(),
          status: orderRow['status'] as String? ?? 'pending',
          createdAt: DateTime.parse(orderRow['created_at'] as String),
        ),
      );
    } on PostgrestException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
