import '../../domain/entities/book_detail_entity.dart';

class BookDetailModel extends BookDetailEntity {
  const BookDetailModel({
    required super.author,
    super.isbn,
    super.publisher,
    super.pageCount,
    super.previewLink,
  });

  factory BookDetailModel.fromJson(Map<String, dynamic> json) {
    return BookDetailModel(
      author: json['author'] as String,
      isbn: json['isbn'] as String?,
      publisher: json['publisher'] as String?,
      pageCount: json['page_count'] as int?,
      previewLink: json['preview_link'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'author': author,
        if (isbn != null) 'isbn': isbn,
        if (publisher != null) 'publisher': publisher,
        if (pageCount != null) 'page_count': pageCount,
        if (previewLink != null) 'preview_link': previewLink,
      };
}
