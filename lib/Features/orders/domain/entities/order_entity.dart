import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final double total;
  final String status;
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, total, status, createdAt];
}
