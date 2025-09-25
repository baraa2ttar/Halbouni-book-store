
import '../../../../core/exports/main_exports.dart';

class Dots extends StatelessWidget {
  const Dots({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: context.h(5),
          width: context.w(20),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColor.primaryColor,
          ),
        ),
        SizedBox(width: context.w(7)),
        Container(
          height: context.h(5),
          width: context.w(5),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColor.greyColor,
          ),
        ),
        SizedBox(width: context.w(7)),
        Container(
          height: context.h(5),
          width: context.w(5),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColor.greyColor,
          ),
        ),
        SizedBox(width: context.w(7)),
        Container(
          height: context.h(5),
          width: context.w(5),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColor.greyColor,
          ),
        ),
      ],
    );
  }
}
