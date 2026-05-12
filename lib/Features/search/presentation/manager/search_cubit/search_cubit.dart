import 'package:adv/Features/Home/domain/entities/product_entity.dart';
import 'package:adv/Features/Home/domain/repos/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._homeRepo) : super(SearchInitial());

  final HomeRepo _homeRepo;

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    final result = await _homeRepo.searchProducts(query: query.trim());
    result.fold(
      (failure) => emit(SearchFailure(failure.message)),
      (products) => emit(SearchSuccess(products)),
    );
  }
}
