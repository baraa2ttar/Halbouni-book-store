import 'package:adv/Features/Home/domain/entities/book_entity.dart';
import 'package:hive/hive.dart';

import '../../../../core/constant/app_constants.dart';

abstract class HomeLocalDataSource{
  List<BookEntity> fetchFeaturedBooks();
  List<BookEntity> fetchNewestBooks();

}
class HomeLocalDataSourceImpl extends HomeLocalDataSource {
  @override
  List<BookEntity> fetchFeaturedBooks() {

    var box = Hive.box<BookEntity>(kFeaturedBox);
    return box.values.toList ();
  }

  @override
  List<BookEntity> fetchNewestBooks() {
    var box = Hive.box<BookEntity>(kNewestBox);
    return box.values.toList ();
  }

}