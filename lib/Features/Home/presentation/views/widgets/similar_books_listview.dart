import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/exports/ui_exports.dart';
import '../../../../../core/services/setup_service_locator.dart';
import '../../../data/repos/home_repo_impl.dart';
import '../../../domain/use_cases/fetch_newest_books_use_case.dart';
import '../../../domain/use_cases/fetch_products_by_category_use_case.dart';
import '../../manager/newest_books_cubit/newest_books_cubit.dart';
import 'custom_list_view_item.dart';

class SimilarBooksListView extends StatefulWidget {
  const SimilarBooksListView({super.key, this.categoryName});

  final String? categoryName;

  @override
  State<SimilarBooksListView> createState() => _SimilarBooksListViewState();
}

class _SimilarBooksListViewState extends State<SimilarBooksListView> {
  late final NewestBooksCubit _cubit;

  @override
  void initState() {
    super.initState();
    final repo = getIt.get<HomeRepoImpl>();
    _cubit = NewestBooksCubit(
      FetchNewestBooksUseCase(repo),
      FetchProductsByCategoryUseCase(repo),
    )..fetchNewestBooks(categoryName: widget.categoryName);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<NewestBooksCubit, NewestBooksState>(
        builder: (context, state) {
          if (state is NewestBooksLoading) {
            return const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }
          if (state is NewestBooksFailure) {
            return const SizedBox.shrink();
          }
          if (state is NewestBooksSuccess && state.books.isNotEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.books.length,
                itemBuilder: (context, index) {
                  final book = state.books[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: CustomListViewItem(image: book.imageUrl),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
