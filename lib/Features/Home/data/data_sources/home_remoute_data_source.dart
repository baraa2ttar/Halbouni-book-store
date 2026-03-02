import '../../../../core/services/api_service.dart';
import '../../domain/entities/book_entity.dart';
import '../models/book_model/book_model.dart';

abstract class HomeRemouteDataSource {
  Future<List<BookEntity>> fetchFeaturedBooks();
  Future<List<BookEntity>> fetchNewestBooks();
}

class HomeReouteDataSourceImpl implements HomeRemouteDataSource {
  final ApiService apiService;

  HomeReouteDataSourceImpl(this.apiService);
  @override
  Future<List<BookEntity>> fetchFeaturedBooks() async {
    var data = await apiService.get(
      endpoint:
          'volumes/s1gVAAAAYAAJ?key=AIzaSyCwVGiG1bCw23obQ60tfaxiHi-7GADH_K4',
    );
    List<BookEntity> books = [];
    for (var BookMap in data["items"]) {
      books.add(BookModel.fromJson(BookMap));
    }
    return books;
  }

  @override
  Future<List<BookEntity>> fetchNewestBooks() async{
    var data = await apiService.get(
      endpoint:
          'volumes/s1gVAAAAYAAJ?key=AIzaSyCwVGiG1bCw23obQ60tfaxiHi-7GADH_K4',
    );
    List<BookEntity> books = [];
    for (var BookMap in data["items"]) {
      books.add(BookModel.fromJson(BookMap));
    }
    return books;
  }
}
