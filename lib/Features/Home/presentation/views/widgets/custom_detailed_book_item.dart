import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/exports/main_exports.dart';
import '../../../../../core/exports/ui_exports.dart';
import '../../../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/product_entity.dart';

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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final dpr = MediaQuery.of(context).devicePixelRatio;
                    final width = constraints.maxWidth;
                    return CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      memCacheWidth: width.isFinite && width > 0
                          ? (width * dpr).round()
                          : null,
                      placeholder: (context, url) =>
                          const Center(
                              child: CircularProgressIndicator(strokeWidth: 2)),
                      errorWidget: (context, url, error) =>
                          Image.asset(AppAssets.book3, fit: BoxFit.cover),
                    );
                  },
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
                        formatSyp(product.price),
                        style: AppTextStyles.textStyle20.copyWith(
                          fontWeight: FontWeight.bold,
                          fontFamily: kGtSectraFine,
                        ),
                      ),
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
