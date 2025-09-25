import 'package:adv/core/exports/ui_exports.dart';

class AppTopBar extends StatelessWidget {
  final String? appBarText;
  final String? image;
  final TextStyle? style;
  final VoidCallback? onSearchTap;

  const AppTopBar({
    super.key,
    this.appBarText,
    this.image,
    this.style,
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final double buttonSize = context.w(30).clamp(30.0, 50.0);
    final double iconSize = context.sp(14).clamp(16.0, 24.0);
    return Row(
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            height: buttonSize,
            width: buttonSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: AppColor.whiteColor,
            ),
            child: Center(child: Icon(Icons.arrow_back_ios_rounded, color: AppColor.darkGreyColor, size:iconSize)),
          ),
        ),
          SizedBox(width: 22.w),
          Text(
            appBarText ?? '',
            textAlign: TextAlign.center,
            style: style ?? AppTextStyles.doctorNameText(context),
          ),
        Spacer(),
        if (image == null && onSearchTap != null)
          GestureDetector(
            onTap: onSearchTap,
            child: Icon(Icons.search, color: AppColor.darkGreyColor, size: 28.sp,),
          )
        else if (image != null)
          ClipOval(
            child: Image.asset(
              image!,
              width: 36,
              height: 36,
              fit: BoxFit.cover,
            ),
          ),
      ],
    );
  }
}

