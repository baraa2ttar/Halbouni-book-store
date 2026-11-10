import 'package:adv/Features/Home/presentation/manager/newest_books_cubit/newest_books_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/exports/ui_exports.dart';
import '../../../../../core/widgets/retry_button.dart';
import 'custom_detailed_book_item.dart';

/// Sliver version of the newest-books list.
///
/// Renders a lazy [SliverList.builder] on success so the whole home page is
/// one scroll view that scrolls smoothly to the last book. The loading, empty
/// and failure states render as [SliverToBoxAdapter]s (the failure state
/// reuses the shared [RetryButton]).
class NewestBooksSliver extends StatelessWidget {
  const NewestBooksSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewestBooksCubit, NewestBooksState>(
      builder: (context, state) {
        if (state is NewestBooksSuccess && state.books.isNotEmpty) {
          final books = state.books;
          return SliverList.builder(
            itemCount: books.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: CustomDetailedBookItem(product: books[index]),
            ),
          );
        }
        if (state is NewestBooksFailure) {
          final cubit = context.read<NewestBooksCubit>();
          return SliverToBoxAdapter(
            child: Center(
              child: RetryButton(
                onRetry: () =>
                    cubit.fetchNewestBooks(categoryId: cubit.activeCategoryId),
              ),
            ),
          );
        }
        if (state is NewestBooksSuccess && state.books.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: Text(
                  AppStrings.noBooksInCategory,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.textStyle16,
                ),
              ),
            ),
          );
        }
        // Loading / Initial.
        return const SliverToBoxAdapter(
          child: SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
