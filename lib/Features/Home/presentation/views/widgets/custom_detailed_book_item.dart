import 'package:adv/Features/Home/domain/entities/product_entity.dart';
import 'package:adv/Features/Home/presentation/views/widgets/rating_widget.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/exports/main_exports.dart';
import '../../../../../core/exports/ui_exports.dart';

class CustomDetailedBookItem extends StatelessWidget {
  const CustomDetailedBookItem({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).push(
          '${AppRouter.kBookDetailsView}/${product.id}',
          extra: product,
        );
      },
      child: SizedBox(
        height: 125,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 2.5 / 4,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: Image.asset(AppAssets.book3).image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 30),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      product.name,
                      style: AppTextStyles.textStyle20,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.bookDetails?.author ?? '',
                    style: AppTextStyles.textStyle14,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: AppTextStyles.textStyle20.copyWith(
                          fontWeight: FontWeight.bold,
                          fontFamily: kGtSectraFine,
                        ),
                      ),
                      SizedBox(height: 18,),
                      RatingWidget(mainAxisAlignment: MainAxisAlignment.center,),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
