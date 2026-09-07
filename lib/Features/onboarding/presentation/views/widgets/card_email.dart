import 'package:adv/core/exports/ui_exports.dart';

/// Prominent bordered action styled like onboarding cards, explicitly for email-based auth — not branded as a Google/third-party chip.
class CardEmail extends StatelessWidget {
  final VoidCallback? onTap;
  final String label;
  final Color backgroundColor;
  final double width;
  final double height;

  const CardEmail({
    super.key,
    required this.label,
    this.onTap,
    this.backgroundColor = Colors.white,
    this.width = 300,
    this.height = 65,
  });

  @override
  Widget build(BuildContext context) {
    final buttonWidth = context.buttonWidth;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: context.responsiveValue(mobile: 56.0, tablet: 60.0, laptop: 64.0),
        width: buttonWidth,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColor.primaryColor, width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mark_email_read_outlined, color: AppColor.primaryColor),
            SizedBox(width: 10.w),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color:
                      backgroundColor == AppColor.primaryColor
                          ? Colors.white
                          : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
