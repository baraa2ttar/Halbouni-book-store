import 'package:adv/Features/Home/domain/entities/category_entity.dart';
import 'package:adv/Features/Home/presentation/manager/newest_books_cubit/newest_books_cubit.dart';
import 'package:adv/core/exports/ui_exports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'custom_app_bar.dart';
import 'custom_detailed_book_builder.dart';
import 'featured_books_listview_builder.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: const CustomAppBar(),
              ),
              FeaturedBooksListViewBlocBuilder(),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "Best Seller ",
                  style: AppTextStyles.titleText(context),
                ),
              ),
              const SizedBox(height: 16),
              _CategoryChips(),
              const SizedBox(height: 16),
            ],
          ),
        ),
        SliverFillRemaining(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: CustomDetailedBookBuilder(),
          ),
        ),
      ],
    );
  }
}

class _CategoryChips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<NewestBooksCubit>();
    final active = cubit.activeCategoryId;

    final items = <({String? id, String label})>[
      const (id: null, label: 'All'),
      ...cubit.categories.map((CategoryEntity c) => (id: c.id, label: c.name)),
    ];

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = active == item.id;

          return GestureDetector(
            onTap: () {
              context.read<NewestBooksCubit>().fetchNewestBooks(
                    categoryId: item.id,
                  );
            },
            child: Chip(
              label: Text(item.label),
              backgroundColor:
                  isSelected ? AppColor.primaryColor : Colors.grey[200],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 13,
              ),
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          );
        },
      ),
    );
  }
}