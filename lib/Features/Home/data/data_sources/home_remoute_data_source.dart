import 'package:adv/core/constant/app_constants.dart';
import 'package:hive/hive.dart';

import '../../../../core/services/api_service.dart';
import '../../domain/entities/book_entity.dart';
import '../models/book_model/book_model.dart';

abstract class HomeRemouteDataSource {
  Future<List<BookEntity>> fetchFeaturedBooks({int pageNumber =0});
  Future<List<BookEntity>> fetchNewestBooks();
}

class HomeReouteDataSourceImpl implements HomeRemouteDataSource {
  final ApiService apiService;
  static const int _pageSize = 10;

  HomeReouteDataSourceImpl(this.apiService);
  @override
  Future<List<BookEntity>> fetchFeaturedBooks({int pageNumber =0}) async {
    final startIndex = pageNumber * _pageSize;
    var data = await apiService.get(
      endpoint:
          'volumes?q=fiction&maxResults=$_pageSize&startIndex=$startIndex&orderBy=relevance&key=AIzaSyCwVGiG1bCw23obQ60tfaxiHi-7GADH_K4',
    );
    final raw = data['items'];
    if (raw is! List) return [];
    List<BookEntity> books = [];
    for (final item in raw) {
      if (item is Map<String, dynamic>) {
        books.add(BookModel.fromJson(item));
      }
    }
    return books;
  }

  @override
  Future<List<BookEntity>> fetchNewestBooks() async{
    var data = await apiService.get(
      endpoint:
          'volumes?q=fiction&maxResults=20&orderBy=newest&key=AIzaSyCwVGiG1bCw23obQ60tfaxiHi-7GADH_K4',
    );
    final raw = data['items'];
    if (raw is! List) return [];
    List<BookEntity> books = [];
    for (final item in raw) {
      if (item is Map<String, dynamic>) {
        books.add(BookModel.fromJson(item));
      }
    }
    var box = Hive.box(kNewestBox);
    box.addAll(books);
    return books;
  }
}
