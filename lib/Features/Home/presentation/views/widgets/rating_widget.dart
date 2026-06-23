import '../../../../../core/exports/ui_exports.dart';

class RatingWidget extends StatelessWidget {
  const RatingWidget({
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.rating = 4.5,
    this.reviewCount,
  });

  final MainAxisAlignment mainAxisAlignment;
  final double rating;
  final int? reviewCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Icon(
          FontAwesomeIcons.solidStar,
          color: const Color(0xffffdd4f),
        ),
        const SizedBox(width: 6.3),
        Text(
          rating.toStringAsFixed(1),
          style: AppTextStyles.textStyle16,
        ),
        if (reviewCount != null) ...[
          const SizedBox(width: 6.3),
          Text(
            "(${reviewCount})",
            style: AppTextStyles.textStyle14,
          ),
        ],
      ],
    );
  }
}