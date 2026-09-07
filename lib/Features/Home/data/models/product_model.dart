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
    super.rating,
    super.bookDetails,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] as String? ?? '',
      categoryName: _categoryName(json),
      isFeatured: json['is_featured'] as bool? ?? false,
      rating: parseRating(json),
      bookDetails: _bookDetails(json['book_details']),
    );
  }

  /// Reads `products.rating` from Supabase (also nested / string / decimal).
  static double? parseRating(Map<String, dynamic> json) {
    final nested = json['book_details'];
    final nestedMap = switch (nested) {
      Map value => Map<String, dynamic>.from(value),
      List list when list.isNotEmpty && list.first is Map =>
        Map<String, dynamic>.from(list.first as Map),
      _ => null,
    };

    for (final candidate in [
      json['rating'],
      json['average_rating'],
      nestedMap?['rating'],
      nestedMap?['average_rating'],
    ]) {
      final value = _toDouble(candidate);
      if (value != null) return value;
    }
    return null;
  }

  static double? _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.trim());
    return null;
  }

  static String _categoryName(Map<String, dynamic> json) {
    final categories = json['categories'];
    if (categories is Map) {
      return categories['name'] as String? ?? '';
    }
    if (categories is List && categories.isNotEmpty && categories.first is Map) {
      return (categories.first as Map)['name'] as String? ?? '';
    }
    return json['category_name'] as String? ?? '';
  }

  static BookDetailModel? _bookDetails(dynamic raw) {
    if (raw == null) return null;
    if (raw is List) {
      if (raw.isEmpty || raw.first is! Map) return null;
      return BookDetailModel.fromJson(Map<String, dynamic>.from(raw.first as Map));
    }
    if (raw is Map) {
      return BookDetailModel.fromJson(Map<String, dynamic>.from(raw));
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (description != null) 'description': description,
        'price': price,
        'image_url': imageUrl,
        'categories': {'name': categoryName},
        'is_featured': isFeatured,
        'rating': rating,
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
