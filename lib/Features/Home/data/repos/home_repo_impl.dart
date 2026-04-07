import 'package:adv/Features/Home/data/data_sources/home_remoute_data_source.dart';
import 'package:adv/Features/Home/domain/entities/book_entity.dart';
import 'package:adv/Features/Home/domain/repos/home_repo.dart';
import 'package:adv/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../data_sources/home_local_datasource.dart';

class HomeRepoImpl extends HomeRepo{
  final HomeRemouteDataSource homeRemouteDataSource ;
  final HomeLocalDataSource homeLocalDataSource ;

  HomeRepoImpl({required this.homeRemouteDataSource,required this.homeLocalDataSource});

  @override
  Future<Either<Failure, List<BookEntity>>> fetchFeaturedBooks() async {
    try {
      var books = await homeRemouteDataSource.fetchFeaturedBooks();
      return right(books);
    }on Exception catch(e)
    {
      return left(ServerFailure(e.toString()));
    }

  }


  @override
  Future<Either<Failure, List<BookEntity>>> fetchNewestBooks() async {
    try {
      var books = await homeRemouteDataSource.fetchNewestBooks();
      return right(books);
    }on Exception catch(e)
    {
      if (e is DioException) {
        return left(ServerFailure.fromDiorError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

}