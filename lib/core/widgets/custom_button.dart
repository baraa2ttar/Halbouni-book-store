import 'package:adv/core/exports/main_exports.dart';
import 'package:adv/core/exports/ui_exports.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.textColor,
    this.borderRadius,
    required this.backgroundColor,
    required this.text,
    this.onPressed,
  });
  final String text ;
  final Color textColor;
  final BorderRadius? borderRadius;
  final Color backgroundColor;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextButton(
        onPressed: onPressed ?? () {},
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.textStyle16.copyWith(color: textColor),
        ),
      ),
    );
  }
}
