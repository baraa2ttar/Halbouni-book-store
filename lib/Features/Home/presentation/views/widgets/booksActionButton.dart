
import '../../../../../core/exports/ui_exports.dart';
import '../../../../../core/widgets/custom_button.dart';

class BooksActionButton extends StatelessWidget {
  const BooksActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text :"19.99 \$",
            backgroundColor: Colors.black,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16),bottomLeft: Radius.circular(16)),
            textColor: Colors.white,
          ),
        ),
        Expanded(
          child: CustomButton(
            text: "free Preview",
            backgroundColor: AppColor.primaryColor,
            borderRadius: BorderRadius.only(topRight: Radius.circular(16),bottomRight: Radius.circular(16)),
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
