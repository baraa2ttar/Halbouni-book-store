import 'package:adv/Features/Home/domain/entities/product_entity.dart';
import 'package:adv/Features/Home/domain/repos/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit(this._homeRepo) : super(ProductDetailsInitial());

  final HomeRepo _homeRepo;

  Future<void> getProductDetails(String id) async {
    emit(ProductDetailsLoading());
    final result = await _homeRepo.fetchProductById(productId: id);
    result.fold(
      (failure) => emit(ProductDetailsFailure(failure.message)),
      (product) => emit(ProductDetailsSuccess(product)),
    );
  }
}
