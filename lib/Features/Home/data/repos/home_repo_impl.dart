import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repos/home_repo.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/helpers/ilike_escape.dart';
import '../models/category_model.dart';
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
          .eq('is_active', true)
          // Deterministic order so pagination doesn't shuffle between pages.
          .order('created_at', ascending: false)
          .order('id', ascending: false)
          .range(pageNumber * 10, pageNumber * 10 + 9);

      final products = (data as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(products);
    } on PostgrestException catch (e) {
      return left(ServerFailure(failureMessage(e)));
    } catch (e) {
      return left(ServerFailure(failureMessage(e)));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> fetchNewestBooks() async {
    try {
      final data = await _supabase
          .from('products')
          .select('*, categories(name), book_details(*)')
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .order('id', ascending: false)
          .limit(20);

      final products = (data as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(products);
    } on PostgrestException catch (e) {
      return left(ServerFailure(failureMessage(e)));
    } catch (e) {
      return left(ServerFailure(failureMessage(e)));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> fetchProductsByCategory({
    required String categoryId,
  }) async {
    try {
      final data = await _supabase
          .from('products')
          .select('*, categories(name), book_details(*)')
          .eq('category_id', categoryId)
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .order('id', ascending: false);

      final products = (data as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(products);
    } on PostgrestException catch (e) {
      return left(ServerFailure(failureMessage(e)));
    } catch (e) {
      return left(ServerFailure(failureMessage(e)));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> fetchCategories() async {
    try {
      final data = await _supabase
          .from('categories')
          .select('id, name')
          .order('name', ascending: true);

      final categories = (data as List)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(categories);
    } on PostgrestException catch (e) {
      return left(ServerFailure(failureMessage(e)));
    } catch (e) {
      return left(ServerFailure(failureMessage(e)));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts({
    required String query,
  }) async {
    try {
      final pattern = '%${escapeIlikePattern(query)}%';
      final data = await _supabase
          .from('products')
          .select('*, categories(name), book_details(*)')
          .eq('is_active', true)
          .ilike('name', pattern)
          .order('name', ascending: true)
          .order('id', ascending: true)
          .limit(50);

      final products = (data as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(products);
    } on PostgrestException catch (e) {
      return left(ServerFailure(failureMessage(e)));
    } catch (e) {
      return left(ServerFailure(failureMessage(e)));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> fetchProductById({
    required String productId,
  }) async {
    try {
      final data = await _supabase
          .from('products')
          .select('*, categories(name), book_details(*)')
          .eq('id', productId)
          .eq('is_active', true)
          .maybeSingle();

      if (data == null) {
        return left(ServerFailure('Product not found'));
      }

      final product = ProductModel.fromJson(data);
      return right(product);
    } on PostgrestException catch (e) {
      return left(ServerFailure(failureMessage(e)));
    } catch (e) {
      return left(ServerFailure(failureMessage(e)));
    }
  }
}