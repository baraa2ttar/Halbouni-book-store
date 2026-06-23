import 'package:equatable/equatable.dart';

import 'book_detail_entity.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String imageUrl;
  final String categoryName;
  final bool isFeatured;
  final double? rating;
  final BookDetailEntity? bookDetails;

  const ProductEntity({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryName,
    required this.isFeatured,
    this.rating,
    this.bookDetails,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        imageUrl,
        categoryName,
        isFeatured,
        rating,
        bookDetails,
      ];
}
