import 'package:adv/Features/Home/domain/entities/product_entity.dart';
import 'package:adv/Features/Home/presentation/manager/product_details_cubit/product_details_cubit.dart';
import 'package:adv/Features/Home/presentation/views/widgets/rating_widget.dart';
import 'package:adv/Features/Home/presentation/views/widgets/similar_books_listview.dart';
import 'package:adv/core/constant/app_text_styles.dart';
import 'package:adv/core/exports/main_exports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'booksActionButton.dart';
import 'custom_book_detailes_app_bar.dart';
import 'custom_list_view_item.dart';

class BookDetailsViewBody extends StatefulWidget {
  const BookDetailsViewBody({
    super.key,
    required this.productId,
    this.productEntity,
  });

  final String productId;
  final ProductEntity? productEntity;

  @override
  State<BookDetailsViewBody> createState() => _BookDetailsViewBodyState();
}

class _BookDetailsViewBodyState extends State<BookDetailsViewBody> {
  @override
  void initState() {
    super.initState();
    if (widget.productEntity == null) {
      context.read<ProductDetailsCubit>().getProductDetails(widget.productId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      builder: (context, state) {
        final product = switch (state) {
          ProductDetailsSuccess(:final product) => product,
          _ => widget.productEntity,
        };

        if (state is ProductDetailsLoading && product == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProductDetailsFailure && product == null) {
          return Center(child: Text(state.message));
        }

        final imageUrl = product?.imageUrl ?? '';
        final name = product?.name ?? '';
        final author = product?.bookDetails?.author ?? '';

        var width = MediaQuery.of(context).size.width;
        // [BACKGROUND COLOR] Change the Scaffold backgroundColor below to adjust the details page background
        return Scaffold(
          backgroundColor: AppColor.whiteColor,
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SafeArea(child: CustomBookDetailesAppBar()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.18),
                        child: CustomListViewItem(image: imageUrl),
                      ),
                      SizedBox(height: 43),
                      Text(name, style: AppTextStyles.textStyle30),
                      SizedBox(height: 6),
                      Opacity(
                        opacity: 0.7,
                        child: Text(
                          author,
                          style: AppTextStyles.textStyle18.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      SizedBox(width: 120, child: RatingWidget(rating: product?.rating ?? 4.5)),
                      SizedBox(height: 45),
                      if (product != null) BooksActionButton(product: product),
                      Expanded(child: SizedBox(height: 45)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "you can also like : ",
                          style: AppTextStyles.textStyle14.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      SimilarBooksListView(categoryName: product?.categoryName),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


