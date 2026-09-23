import 'package:adv/Features/Home/presentation/manager/newest_books_cubit/newest_books_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/exports/main_exports.dart';
import '../../../../../core/exports/ui_exports.dart';
import 'custom_detailed_book_item.dart';

class CustomDetailedBookBuilder extends StatelessWidget {
  const CustomDetailedBookBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewestBooksCubit, NewestBooksState>(
      builder: (context, state) {
        if (state is NewestBooksSuccess && state.books.isNotEmpty) {
          final books = state.books;
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: books.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CustomDetailedBookItem(product: books[index]),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
