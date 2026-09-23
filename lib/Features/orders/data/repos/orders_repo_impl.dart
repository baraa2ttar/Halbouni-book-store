import 'dart:convert';

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

      // Server-side `place_order` RPC validates stock, computes totals, and
      // inserts the order + items atomically. Client never sends price/total.
      final orderId = await _client.rpc(
        'place_order',
        params: {
          'items': [
            for (final item in items)
              {'product_id': item.id, 'quantity': item.quantity},
          ],
          'order_notes': (notes == null || notes.trim().isEmpty)
              ? null
              : notes.trim(),
        },
      );

      final id = orderId is String && orderId.isNotEmpty
          ? orderId
          : (orderId as String?) ?? '';
      if (id.isEmpty) {
        return left(ServerFailure('Order was not created. Please try again.'));
      }

      final orderRow = await _client
          .from('orders')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (orderRow == null) {
        return right(
          OrderEntity(
            id: id,
            userId: user.id,
            total: 0,
            status: 'pending',
            createdAt: DateTime.now(),
          ),
        );
      }

      return right(
        OrderEntity(
          id: orderRow['id'] as String,
          userId: orderRow['user_id'] as String? ?? user.id,
          total: ((orderRow['total'] as num?) ?? 0).toDouble(),
          status: orderRow['status'] as String? ?? 'pending',
          createdAt:
              DateTime.tryParse(orderRow['created_at'] as String? ?? '') ??
                  DateTime.now(),
        ),
      );
    } on PostgrestException catch (e) {
      return left(ServerFailure(_rpcErrorMessage(e)));
    } catch (e) {
      return left(ServerFailure(failureMessage(e)));
    }
  }

  /// Postgrest surfaces RPC `raise exception` payloads as a JSON string inside
  /// `message` — unwrap it so users see the real server-side message.
  static String _rpcErrorMessage(PostgrestException e) {
    final raw = e.message.trim();
    if (raw.isEmpty) return failureMessage(e);
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        final message = decoded['message'];
        if (message is String && message.isNotEmpty) return message;
      }
    } catch (_) {
      // Not JSON — surface the raw message as-is.
    }
    return raw;
  }
}