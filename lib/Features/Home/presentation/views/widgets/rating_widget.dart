import '../../../../../core/exports/ui_exports.dart';

class RatingWidget extends StatelessWidget {
  const RatingWidget({super.key,  this.mainAxisAlignment=MainAxisAlignment.start});
final MainAxisAlignment mainAxisAlignment;
  @override
  Widget build(BuildContext context) {
    return Row(
mainAxisAlignment: mainAxisAlignment,
      children: [
        Icon(FontAwesomeIcons.solidStar,
          color:Color(0xffffdd4f),
        ),
        SizedBox(width: 6.3),
        Text("4.8",

          style: AppTextStyles.textStyle16,),
        SizedBox(width: 6.3),
        Text("(254)",
          style: AppTextStyles.textStyle14,)
      ],
    );
  }
}