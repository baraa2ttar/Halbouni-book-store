import 'package:equatable/equatable.dart';

class BookDetailEntity extends Equatable {
  final String author;
  final String? isbn;
  final String? publisher;
  final int? pageCount;
  final String? previewLink;

  const BookDetailEntity({
    required this.author,
    this.isbn,
    this.publisher,
    this.pageCount,
    this.previewLink,
  });

  @override
  List<Object?> get props => [
        author,
        isbn,
        publisher,
        pageCount,
        previewLink,
      ];
}
