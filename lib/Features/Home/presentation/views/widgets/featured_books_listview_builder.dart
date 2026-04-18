import 'package:adv/Features/Home/presentation/manager/featured_books_cubit/featured_books_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/exports/main_exports.dart';
import 'FeaturedListView.dart';

class FeaturedBooksListViewBlocBuilder extends StatelessWidget {
  const FeaturedBooksListViewBlocBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeaturedBooksCubit, FeaturedBooksState>(
      builder: (context, state) {
        if (state is FeaturedBooksSuccess){
          return FeaturedBooksListView();
        }
        else if (state is FeaturedBooksFailure){
          return Text(state.message);
        }
        else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}