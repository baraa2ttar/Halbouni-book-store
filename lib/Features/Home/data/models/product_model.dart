import '../../domain/entities/product_entity.dart';
import 'book_detail_model.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    super.description,
    required super.price,
    required super.imageUrl,
    required super.categoryName,
    required super.isFeatured,
    super.bookDetails,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] as String,
      categoryName: (json['categories'] as Map<String, dynamic>)['name'] as String,
      isFeatured: json['is_featured'] as bool,
      bookDetails: (json['book_details'] as List?)
              ?.cast<Map<String, dynamic>>()
              .map(BookDetailModel.fromJson)
              .firstOrNull,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (description != null) 'description': description,
        'price': price,
        'image_url': imageUrl,
        'categories': {'name': categoryName},
        'is_featured': isFeatured,
        if (bookDetails != null)
          'book_details': [
            (bookDetails! is BookDetailModel
                    ? bookDetails! as BookDetailModel
                    : BookDetailModel(
                        author: bookDetails!.author,
                        isbn: bookDetails!.isbn,
                        publisher: bookDetails!.publisher,
                        pageCount: bookDetails!.pageCount,
                        previewLink: bookDetails!.previewLink,
                      ))
                .toJson()
          ],
      };
}
