import 'package:adv/Features/Home/presentation/manager/newest_books_cubit/newest_books_cubit.dart';
import 'package:adv/core/exports/ui_exports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'CustomDetailedBookBuilder.dart';
import 'custom_app_bar.dart';
import 'featured_books_listview_builder.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  static const _categories = [
    'All',
    'Romance',
    'Fantasy',
    'Sci-Fi',
    'Horror',
    'Thriller',
    'Adventure',
    'Biography',
  ];

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
    final active = context.watch<NewestBooksCubit>().activeCategory;
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        itemCount: HomeViewBody._categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = HomeViewBody._categories[index];
          final isAll = category == 'All';
          final isSelected = isAll
              ? active == null
              : active == category;

          return GestureDetector(
            onTap: () {
              context.read<NewestBooksCubit>().fetchNewestBooks(
                categoryName: isAll ? null : category,
              );
            },
            child: Chip(
              label: Text(category),
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


