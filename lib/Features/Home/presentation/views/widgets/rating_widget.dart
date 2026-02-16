import '../../../../../core/exports/ui_exports.dart';

class RatingWidget extends StatelessWidget {
  const RatingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(

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