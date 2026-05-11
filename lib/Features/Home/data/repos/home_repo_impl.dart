import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/product_entity.dart';
import '../../domain/repos/home_repo.dart';
import '../../../../core/errors/failure.dart';
import '../models/product_model.dart';

class HomeRepoImpl extends HomeRepo {
  final SupabaseClient _supabase;

  HomeRepoImpl({required SupabaseClient supabase}) : _supabase = supabase;

  @override
  Future<Either<Failure, List<ProductEntity>>> fetchFeaturedBooks({
    int pageNumber = 0,
  }) async {
    try {
      final data = await _supabase
          .from('products')
          .select('*, categories(name), book_details(*)')
          .eq('is_featured', true)
          .range(pageNumber * 10, pageNumber * 10 + 9);

      final products = (data as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(products);
    } on PostgrestException catch (e) {
      return left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> fetchNewestBooks() async {
    try {
      final data = await _supabase
          .from('products')
          .select('*, categories(name), book_details(*)')
          .order('created_at', ascending: false)
          .limit(20);

      final products = (data as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(products);
    } on PostgrestException catch (e) {
      return left(ServerFailure(e.message));
    }
  }
}