import 'dart:async';

import 'package:adv/Features/Home/domain/entities/product_entity.dart';
import 'package:adv/Features/search/presentation/manager/search_cubit/search_cubit.dart';
import 'package:adv/core/exports/main_exports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/app_text_styles.dart';
import '../../../Home/presentation/views/widgets/custom_detailed_book_item.dart';
import 'custom_search_text_field.dart';

class SearchViewBody extends StatefulWidget {
  const SearchViewBody({super.key});

  @override
  State<SearchViewBody> createState() => _SearchViewBodyState();
}

class _SearchViewBodyState extends State<SearchViewBody> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<SearchCubit>().search(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          CustomSearchTextField(onChanged: _onSearchChanged),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Search results :",
              style: AppTextStyles.titleText(context).copyWith(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return switch (state) {
          SearchInitial() => const SizedBox.shrink(),
          SearchLoading() => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          SearchFailure(:final message) => Center(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          SearchSuccess(:final products) => _SearchResultListView(products),
        };
      },
    );
  }
}

class _SearchResultListView extends StatelessWidget {
  const _SearchResultListView(this.products);

  final List<ProductEntity> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Text(
          'No results found',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: CustomDetailedBookItem(product: products[index]),
        );
      },
    );
  }
}
